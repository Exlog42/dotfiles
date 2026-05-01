#!/usr/bin/env python3

import json
import os
import re
import shutil
import subprocess
import sys
import time
from typing import Dict, Tuple

STATE_FILE = os.path.expanduser("~/.config/polybar/scripts/timer_state.json")
DEFAULT_SECONDS = 25 * 60


def default_state() -> Dict:
    return {
        "running": False,
        "remaining": 0,
        "end_at": None,
        "notified": False,
        "title": "计时器",
    }


def ensure_state_dir() -> None:
    os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)


def load_state() -> Dict:
    ensure_state_dir()
    try:
        with open(STATE_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
            state = default_state()
            state.update(data)
            return state
    except (FileNotFoundError, json.JSONDecodeError):
        return default_state()


def save_state(state: Dict) -> None:
    ensure_state_dir()
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump(state, f)


def notify(title: str, message: str) -> None:
    if shutil.which("notify-send"):
        subprocess.run(["notify-send", "-u", "normal", title, message], check=False)


def parse_duration_to_seconds(raw: str) -> int:
    value = raw.strip().lower()

    if re.fullmatch(r"\d+", value):
        return int(value) * 60

    if re.fullmatch(r"\d{1,2}:\d{2}:\d{2}", value):
        hour, minute, second = map(int, value.split(":"))
        return hour * 3600 + minute * 60 + second

    if re.fullmatch(r"\d{1,3}:\d{2}", value):
        minute, second = map(int, value.split(":"))
        return minute * 60 + second

    total = 0
    for num, unit in re.findall(r"(\d+)\s*([hms])", value):
        n = int(num)
        if unit == "h":
            total += n * 3600
        elif unit == "m":
            total += n * 60
        elif unit == "s":
            total += n

    if total > 0:
        return total

    raise ValueError("invalid duration")


def get_remaining(state: Dict) -> Tuple[int, bool]:
    if not state["running"]:
        return max(0, int(state["remaining"])), False

    end_at = state.get("end_at")
    if end_at is None:
        return max(0, int(state["remaining"])), False

    remain = max(0, int(end_at - time.time()))

    if remain == 0:
        if not state.get("notified", False):
            notify(state.get("title", "计时器"), "时间到了")
            state["notified"] = True
        state["running"] = False
        state["remaining"] = 0
        state["end_at"] = None
        return 0, True

    state["remaining"] = remain
    return remain, False


def start_timer(state: Dict, seconds: int) -> None:
    seconds = max(0, int(seconds))
    state["running"] = seconds > 0
    state["remaining"] = seconds
    state["end_at"] = int(time.time()) + seconds if seconds > 0 else None
    state["notified"] = False


def pause_timer(state: Dict) -> None:
    remain, _ = get_remaining(state)
    state["running"] = False
    state["remaining"] = remain
    state["end_at"] = None


def resume_timer(state: Dict) -> None:
    remain = max(0, int(state["remaining"]))
    if remain > 0:
        state["running"] = True
        state["end_at"] = int(time.time()) + remain


def stop_timer(state: Dict) -> None:
    state["running"] = False
    state["remaining"] = 0
    state["end_at"] = None
    state["notified"] = False


def add_time(state: Dict, delta_seconds: int) -> None:
    remain, _ = get_remaining(state)
    new_remain = max(0, remain + delta_seconds)
    state["remaining"] = new_remain

    if new_remain == 0:
        state["running"] = False
        state["end_at"] = None
        return

    if state["running"]:
        state["end_at"] = int(time.time()) + new_remain


def format_mmss(seconds: int) -> str:
    minute = seconds // 60
    second = seconds % 60
    return f"{minute:02d}:{second:02d}"


def render(state: Dict) -> str:
    remain, _ = get_remaining(state)
    if remain == 0:
        return "%{F#13e014}󱫠%{F-} --:--"

    if state["running"]:
        return f"%{{F#13e014}}󱫟%{{F-}} {format_mmss(remain)}"

    return f"%{{F#13e014}}󱫠%{{F-}} {format_mmss(remain)}"


def print_help() -> None:
    print("usage: timer.py [start <duration>|toggle|pause|resume|stop|add <duration>|sub <duration>|set <duration>|status]")


def main() -> None:
    state = load_state()

    args = sys.argv[1:]
    if not args:
        print(render(state))
        save_state(state)
        return

    cmd = args[0].lower()

    try:
        if cmd in {"start", "set"}:
            if len(args) < 2:
                start_timer(state, DEFAULT_SECONDS)
            else:
                start_timer(state, parse_duration_to_seconds(args[1]))
        elif cmd == "toggle":
            remain, _ = get_remaining(state)
            if state["running"]:
                pause_timer(state)
            elif remain > 0:
                resume_timer(state)
            else:
                start_timer(state, DEFAULT_SECONDS)
        elif cmd == "pause":
            pause_timer(state)
        elif cmd == "resume":
            resume_timer(state)
        elif cmd == "stop":
            stop_timer(state)
        elif cmd == "add":
            if len(args) < 2:
                raise ValueError("missing duration")
            add_time(state, parse_duration_to_seconds(args[1]))
        elif cmd == "sub":
            if len(args) < 2:
                raise ValueError("missing duration")
            add_time(state, -parse_duration_to_seconds(args[1]))
        elif cmd == "status":
            pass
        elif cmd in {"help", "-h", "--help"}:
            print_help()
            return
        else:
            raise ValueError("unknown command")
    except ValueError:
        print_help()
        print(render(state))
        save_state(state)
        return

    print(render(state))
    save_state(state)


if __name__ == "__main__":
    main()
