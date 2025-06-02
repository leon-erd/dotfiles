import os
import sys
import subprocess as sub
import time
import traceback
import logging
from datetime import datetime
from pathlib import Path
from typing import Optional
from .send_telegram_message import send_telegram_message
from .stdout_assert import stdout_assert

# Variables
CLOUD_DATA_PATH = Path("/media/nextcloud/main_drive/data")
CLOUD_CONFIG_PATH = Path("/media/nextcloud/main_drive/config")
BACKUP_REPO_PATH = Path("/media/nextcloud/backup_drive/borg")
LOGFILE = Path("/var/lib/nextcloud/cloudbackup.log")
SQL_TMP_FILE = Path(f"/tmp/cloud_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.sql")
DBNAME = "nextcloud"
OCC_CMD = "/run/current-system/sw/bin/nextcloud-occ"
BORG_CMD = "/run/current-system/sw/bin/borg"
MYSQLDUMP_CMD = "/run/current-system/sw/bin/mysqldump"
RM_CMD = "/run/current-system/sw/bin/rm"


class TelegramHandler(logging.Handler):
    def emit(self, record: logging.LogRecord):
        log_entry = self.format(record)
        try:
            send_telegram_message(log_entry)
        except Exception as e:
            print(f"Failed to send Telegram message: {e}", file=sys.stderr)


logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
file_handler = logging.FileHandler(LOGFILE, mode="w")
console_handler = logging.StreamHandler(sys.stdout)
telegram_handler = TelegramHandler()
file_handler.setLevel(logging.DEBUG)
console_handler.setLevel(logging.DEBUG)
telegram_handler.setLevel(logging.INFO)
formatter = logging.Formatter("{asctime}::{levelname:<8}::{message}", style="{")
file_handler.setFormatter(formatter)
console_handler.setFormatter(formatter)
telegram_handler.setFormatter(formatter)
logger.addHandler(file_handler)
logger.addHandler(console_handler)
logger.addHandler(telegram_handler)


def check_mounted_correctly():
    """
    Check if backup and main drives are mounted, triggering automount if needed.

    Returns
    -------
    bool
    """
    paths = [CLOUD_DATA_PATH.parent, BACKUP_REPO_PATH.parent]
    # Trigger automount by accessing the directory
    for path in paths:
        try:
            os.listdir(path)  # Touch the directory to trigger automount
        except Exception:
            pass  # Ignore errors here; we just want to try triggering mount

    return all(p.is_mount() for p in paths)


def run_cmd(
    command: list[str],
    capture_output: bool = True,
    text: bool = True,
    expect_stdout: Optional[str] = None,
    logger: logging.Logger = logger,
    **kwargs,
) -> sub.CompletedProcess:
    try:
        logger.debug(f"Running: {' '.join(command)}")
        p = sub.run(command, capture_output=capture_output, text=text, **kwargs)
        assert p.returncode == 0, f"Command failed with return code {p.returncode}"
        if expect_stdout is not None:
            stdout_assert(p.stdout, expect_stdout)
        if p.stderr is not None and p.stderr.strip():
            logger.warning(f"Stderr output detected in command execution!\n{p.stderr}")
        return p
    except Exception as e:
        logger.error("The following error(s) occurred in the backup script:")
        logger.error(f"{e}")
        logger.error(f"{traceback.format_exc()}")
        logger.error(f"{p.stderr}")  # type: ignore
        sys.exit(1)


def main():
    start_time = time.perf_counter()
    logger.debug("Starting cloud backup script...")

    if not check_mounted_correctly():
        logger.error("The hard drives are not correctly mounted!")
        sys.exit(1)

    p = run_cmd([BORG_CMD, "info", f"{BACKUP_REPO_PATH}"])
    logger.debug(p.stdout)

    p = run_cmd(
        [
            OCC_CMD,
            "maintenance:mode",
            "--on",
        ],
        expect_stdout="Maintenance mode enabled\n",
    )
    logger.debug(p.stdout)

    with open(SQL_TMP_FILE, "w") as f:
        run_cmd(
            [MYSQLDUMP_CMD, "--single-transaction", DBNAME],
            capture_output=False,
            text=False,
            stdout=f,
        )

    p = run_cmd(
        [
            BORG_CMD,
            "create",
            "--stats",
            "--compression=none",
            f"{BACKUP_REPO_PATH}::nextcloud-{datetime.now().strftime('%Y-%m-%d_%H-%M')}",
            f"{CLOUD_DATA_PATH}",
            f"{CLOUD_CONFIG_PATH}",
            f"{SQL_TMP_FILE}",
        ],
    )
    logger.debug(p.stdout)

    p = run_cmd(
        [
            BORG_CMD,
            "prune",
            "-v",
            "--list",
            f"{BACKUP_REPO_PATH}",
            "--keep-daily=1",
            "--keep-weekly=1",
            "--keep-monthly=1",
        ]
    )
    logger.debug(p.stdout)

    p = run_cmd(
        [
            OCC_CMD,
            "maintenance:mode",
            "--off",
        ],
        expect_stdout="Maintenance mode disabled\n",
    )
    logger.debug(p.stdout)

    run_cmd([RM_CMD, f"{SQL_TMP_FILE}"], expect_stdout="")

    total_time = time.perf_counter() - start_time
    minutes = f"{total_time // 60:.0f}"
    seconds = f"{total_time % 60:02.0f}"

    logger.info(
        f"The cloudbackup finished successfully after {minutes}:{seconds} (min:sec)!"
    )


if __name__ == "__main__":
    main()
