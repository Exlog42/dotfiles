#!/usr/bin/env python3
import argparse
import hashlib
import json
import shlex
import subprocess
import time
from typing import Any, Dict, List, Optional


def run_i3_msg(*args: str) -> str:
    result = subprocess.run(["i3-msg", *args], capture_output=True, text=True, check=False)
    return result.stdout


def i3_command(command: str) -> None:
    subprocess.run(["i3-msg", command], capture_output=True, text=True, check=False)


def get_tree() -> Dict[str, Any]:
    raw = run_i3_msg("-t", "get_tree")
    return json.loads(raw)


def iter_nodes(node: Dict[str, Any]):
    yield node
    for child in node.get("nodes", []):
        yield from iter_nodes(child)
    for child in node.get("floating_nodes", []):
        yield from iter_nodes(child)


def is_window_node(node: Dict[str, Any]) -> bool:
    return node.get("window") is not None


def get_window_nodes(tree: Dict[str, Any]) -> List[Dict[str, Any]]:
    return [node for node in iter_nodes(tree) if is_window_node(node)]


def find_marked_windows(tree: Dict[str, Any], mark: str) -> List[Dict[str, Any]]:
    return [node for node in get_window_nodes(tree) if mark in node.get("marks", [])]


def find_focused_window(tree: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    for node in get_window_nodes(tree):
        if node.get("focused"):
            return node
    return None


def command_to_mark(command: str) -> str:
    digest = hashlib.sha1(command.encode("utf-8")).hexdigest()[:12]
    return f"__cmd_scratch_{digest}"


def criteria_for_mark(mark: str) -> str:
    escaped = mark.replace('"', '\\"')
    return f'[con_mark="^{escaped}$"]'


def hide_marked(mark: str) -> None:
    criteria = criteria_for_mark(mark)
    i3_command(f"{criteria} move scratchpad")


def show_marked(mark: str) -> None:
    criteria = criteria_for_mark(mark)
    i3_command(f"{criteria} scratchpad show")
    i3_command(f"{criteria} focus")


def wait_new_window(before_ids: set, timeout: float) -> Optional[int]:
    end_time = time.time() + timeout
    while time.time() < end_time:
        tree = get_tree()
        focused = find_focused_window(tree)
        if focused and focused.get("id") not in before_ids:
            return focused.get("id")

        current_windows = get_window_nodes(tree)
        new_windows = [node for node in current_windows if node.get("id") not in before_ids]
        if new_windows:
            new_windows.sort(key=lambda node: node.get("id", 0))
            return new_windows[-1].get("id")
        time.sleep(0.1)
    return None


def launch_and_mark(command: str, mark: str, timeout: float) -> bool:
    before_tree = get_tree()
    before_ids = {node.get("id") for node in get_window_nodes(before_tree)}

    subprocess.Popen(command, shell=True)

    new_id = wait_new_window(before_ids, timeout)
    if new_id is None:
        return False

    i3_command(f'[con_id={new_id}] mark --add {mark}')
    i3_command(f'[con_id={new_id}] move scratchpad')
    i3_command(f'[con_id={new_id}] scratchpad show')
    i3_command(f'[con_id={new_id}] focus')
    return True


def handle_toggle(command: str, timeout: float) -> int:
    mark = command_to_mark(command)
    tree = get_tree()
    focused = find_focused_window(tree)

    if focused and mark in focused.get("marks", []):
        hide_marked(mark)
        return 0

    marked = find_marked_windows(tree, mark)
    if marked:
        show_marked(mark)
        return 0

    launched = launch_and_mark(command, mark, timeout)
    if launched:
        return 0

    tree = get_tree()
    marked = find_marked_windows(tree, mark)
    if marked:
        show_marked(mark)
        return 0

    return 1


def handle_show(command: str) -> int:
    show_marked(command_to_mark(command))
    return 0


def handle_hide(command: str) -> int:
    hide_marked(command_to_mark(command))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Create a dedicated i3 scratchpad bucket per launch command."
        )
    )
    parser.add_argument(
        "action",
        choices=["toggle", "show", "hide"],
        nargs="?",
        default="toggle",
        help="toggle (default), show, or hide the command-specific scratchpad",
    )
    parser.add_argument(
        "command",
        help="launch command used as unique key, e.g. 'alacritty --class notes'",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        default=8.0,
        help="seconds to wait for a new window when launching (default: 8)",
    )
    return parser


def main() -> int:
    args = build_parser().parse_args()

    if not shutil_which("i3-msg"):
        print("i3-msg not found in PATH")
        return 2

    if args.action == "toggle":
        return handle_toggle(args.command, args.timeout)
    if args.action == "show":
        return handle_show(args.command)
    if args.action == "hide":
        return handle_hide(args.command)
    return 2


def shutil_which(name: str) -> Optional[str]:
    try:
        return subprocess.run(["which", name], capture_output=True, text=True, check=False).stdout.strip() or None
    except Exception:
        return None


if __name__ == "__main__":
    raise SystemExit(main())
