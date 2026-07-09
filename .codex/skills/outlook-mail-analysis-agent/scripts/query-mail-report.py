from __future__ import annotations

import argparse
import csv
import json
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Filter generated mail analysis reports.")
    parser.add_argument("--report-dir", required=True, help="Directory containing emails.csv and threads.csv.")
    parser.add_argument("--mode", choices=("emails", "threads"), default="emails")
    parser.add_argument("--sender", help="Case-insensitive sender filter for emails mode.")
    parser.add_argument("--subject-contains", help="Case-insensitive subject filter.")
    parser.add_argument("--reply-status", help="Reply status filter for emails mode.")
    parser.add_argument("--thread-key", help="Exact thread key filter.")
    parser.add_argument("--contains", help="General case-insensitive substring filter across the row.")
    parser.add_argument("--min-delay-minutes", type=int, help="Minimum first reply delay in minutes.")
    parser.add_argument("--max-delay-minutes", type=int, help="Maximum first reply delay in minutes.")
    parser.add_argument("--min-message-count", type=int, help="Minimum thread message count in threads mode.")
    parser.add_argument("--limit", type=int, default=20, help="Maximum rows to print.")
    return parser.parse_args()


def main() -> int:
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except AttributeError:
        pass
    args = parse_args()
    report_dir = Path(args.report_dir)
    filename = "emails.csv" if args.mode == "emails" else "threads.csv"
    target = report_dir / filename

    if not target.exists():
        raise SystemExit(f"Report not found: {target}")

    rows = list(load_rows(target))
    filtered = [row for row in rows if matches(row, args)]
    print(json.dumps(filtered[: args.limit], ensure_ascii=False, indent=2))
    return 0


def load_rows(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def matches(row: dict[str, str], args: argparse.Namespace) -> bool:
    subject = row.get("subject_raw") or row.get("subject") or ""
    if args.sender and args.mode == "emails":
        if args.sender.casefold() not in (row.get("sender") or "").casefold():
            return False
    if args.subject_contains and args.subject_contains.casefold() not in subject.casefold():
        return False
    if args.reply_status and args.mode == "emails":
        if args.reply_status != row.get("reply_status"):
            return False
    if args.thread_key and args.thread_key != row.get("thread_key") and args.thread_key != row.get("conversation_key"):
        return False
    if args.contains:
        haystack = " ".join(value for value in row.values() if value)
        if args.contains.casefold() not in haystack.casefold():
            return False
    if args.min_delay_minutes is not None and args.mode == "emails":
        delay = parse_int(row.get("first_reply_delay_minutes"))
        if delay is None or delay < args.min_delay_minutes:
            return False
    if args.max_delay_minutes is not None and args.mode == "emails":
        delay = parse_int(row.get("first_reply_delay_minutes"))
        if delay is None or delay > args.max_delay_minutes:
            return False
    if args.min_message_count is not None and args.mode == "threads":
        message_count = parse_int(row.get("message_count"))
        if message_count is None or message_count < args.min_message_count:
            return False
    return True


def parse_int(value: str | None) -> int | None:
    if value is None or value == "":
        return None
    try:
        return int(value)
    except ValueError:
        return None


if __name__ == "__main__":
    raise SystemExit(main())
