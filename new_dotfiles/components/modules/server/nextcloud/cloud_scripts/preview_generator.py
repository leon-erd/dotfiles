import subprocess as sub
import traceback
from .send_telegram_message import send_telegram_message
from .stdout_assert import stdout_assert


def main():
    try:
        p1 = sub.run(
            [
                "/run/current-system/sw/bin/nextcloud-occ",
                "preview:pre-generate",
            ],
            capture_output=True,
            text=True,
        )
        stdout_assert(p1.stdout, "")
        assert p1.returncode == 0
    except Exception:
        send_telegram_message(
            "The following error(s) occurred in the preview generator script:"
        )
        send_telegram_message(f"{traceback.format_exc()}")
        send_telegram_message(f"{p1.stdout}") # type: ignore
        send_telegram_message(f"{p1.stderr}") # type: ignore


if __name__ == "__main__":
    main()
