from __future__ import annotations

import argparse
import csv
import json
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Compute KPIs from generated mail analysis reports.")
    parser.add_argument("--report-dir", required=True, help="Directory containing emails.csv and threads.csv.")
    return parser.parse_args()


def main() -> int:
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except AttributeError:
        pass
    args = parse_args()
    report_dir = Path(args.report_dir)
    emails_path = report_dir / "emails.csv"
    threads_path = report_dir / "threads.csv"

    if not emails_path.exists():
        raise SystemExit(f"Report not found: {emails_path}")
    if not threads_path.exists():
        raise SystemExit(f"Report not found: {threads_path}")

    emails = load_rows(emails_path)
    threads = load_rows(threads_path)

    delays = [
        int(row["first_reply_delay_minutes"])
        for row in emails
        if row.get("first_reply_delay_minutes")
    ]
    unreplied = [row for row in emails if row.get("reply_status") == "not_replied"]
    replied = [row for row in emails if row.get("reply_status") == "replied"]

    summary = {
        "email_count": len(emails),
        "thread_count": len(threads),
        "replied_count": len(replied),
        "unreplied_count": len(unreplied),
        "missing_date_count": sum(1 for row in emails if row.get("reply_status") == "missing_date"),
        "avg_first_reply_minutes": round(sum(delays) / len(delays), 2) if delays else None,
        "max_first_reply_minutes": max(delays) if delays else None,
        "top_unreplied_subjects": top_values(unreplied, "subject_raw"),
        "top_senders": top_values(emails, "sender"),
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


def load_rows(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def top_values(rows: list[dict[str, str]], field: str, limit: int = 5) -> list[dict[str, int | str]]:
    counts: dict[str, int] = {}
    for row in rows:
        value = (row.get(field) or "").strip()
        if not value:
            continue
        counts[value] = counts.get(value, 0) + 1
    ordered = sorted(counts.items(), key=lambda item: (-item[1], item[0]))
    return [{"value": value, "count": count} for value, count in ordered[:limit]]


if __name__ == "__main__":
    raise SystemExit(main())
