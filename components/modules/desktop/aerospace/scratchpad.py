"""Launch and toggle one scratchpad on the workspace focused at invocation."""

import argparse
import fcntl
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path


def toggle(
    *,
    app_name,
    command,
    title="",
    fullscreen=False,
    aerospace="aerospace",
    scratchpad="aerospace-scratchpad",
    timeout=15,
):
    def run(*args):
        return subprocess.run(
            args, check=True, text=True, capture_output=True
        ).stdout.strip()

    title_pattern = re.compile(title)

    def find_window():
        windows = json.loads(
            run(
                aerospace,
                "list-windows",
                "--all",
                "--json",
                "--format",
                "%{window-id} %{app-name} %{window-title} %{workspace}",
            )
        )
        matches = [
            w
            for w in windows
            if w["app-name"] == app_name and title_pattern.search(w["window-title"])
        ]
        # Select one window deterministically, even for apps with multiple windows.
        return min(matches, key=lambda w: w["window-id"], default=None)

    destination = run(aerospace, "list-workspaces", "--focused")
    window = find_window()
    needs_launch = window is None

    if needs_launch:
        subprocess.Popen(
            command,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
        deadline = time.monotonic() + timeout
        while window is None:
            window = find_window()
            if window is not None:
                break
            if time.monotonic() >= deadline:
                raise TimeoutError(
                    f"No matching {app_name} window appeared within {timeout}s"
                )
            time.sleep(0.1)

    window_id = str(window["window-id"])
    window_filter = f"window-id=^{window_id}$"
    run(aerospace, "fullscreen", "off", "--window-id", window_id)
    # Upstream only sets floating when hiding; set it for the first display too.
    run(aerospace, "layout", "floating", "--window-id", window_id)

    if needs_launch:
        # A new window may already have focus, in which case show would hide it.
        run(aerospace, "workspace", "--", destination)
        run(scratchpad, "summon", ".", "-F", window_filter)
    else:
        result = json.loads(run(scratchpad, "show", ".", "-F", window_filter, "--output", "json"))
        if result["result"] != "ok":
            raise ValueError(result["message"] or "Unable to toggle scratchpad")
        if result["action"] == "to-scratchpad":
            return

    if fullscreen:
        run(aerospace, "fullscreen", "on", "--window-id", window_id)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--aerospace", default="aerospace")
    parser.add_argument("--scratchpad", default="aerospace-scratchpad")
    parser.add_argument("--app-name", required=True)
    parser.add_argument("--title", default="")
    parser.add_argument("--fullscreen", action="store_true")
    parser.add_argument("command", nargs=argparse.REMAINDER)
    options = vars(parser.parse_args())
    if options["command"][:1] == ["--"]:
        options["command"] = options["command"][1:]
    if not options["command"]:
        parser.error("a launch command is required after --")

    # Ignore callback context; explicit IDs and the actual focused workspace are used.
    os.environ.pop("AEROSPACE_WINDOW_ID", None)
    os.environ.pop("AEROSPACE_WORKSPACE", None)

    # A nonblocking OS lock prevents duplicate launches on repeated keypresses.
    # The kernel releases it even if this process is terminated unexpectedly.
    key = hashlib.sha256(
        json.dumps([options["app_name"], options["title"]]).encode()
    ).hexdigest()
    lock_dir = Path(tempfile.gettempdir()) / f"aerospace-scratchpad-{os.getuid()}"
    lock_dir.mkdir(mode=0o700, exist_ok=True)
    with (lock_dir / f"{key}.lock").open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return
        toggle(**options)


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"scratchpad: {getattr(error, 'stderr', None) or error}", file=sys.stderr)
        sys.exit(1)
