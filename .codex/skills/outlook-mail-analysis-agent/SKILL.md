---
name: outlook-mail-analysis-agent
description: Analyze exported Outlook email datasets with a low-token workflow that converts raw `.eml` or `.msg` files into structured reports, then uses scripts to query related emails, reply timing, unreplied threads, and thread-level summaries. Use when Codex needs to inspect a whole mail folder, find emails related to a request, calculate how long messages took to get a reply, or answer repeated email-analysis questions without repeatedly loading full message bodies into context.
---

# Outlook Mail Analysis Agent

Use scripts first and context second. Convert raw mail to structured artifacts once, then answer follow-up questions from the generated reports. Only reopen specific source emails when a user needs exact wording or deeper judgment.

## Workflow

1. If the user has raw exports, run the ingestion workflow:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/run-mail-workflow.ps1 -InputDir <raw-mail-dir> -OutputDir <report-dir>
```

2. If the user asks for aggregate status, SLA, unreplied counts, or coverage, run:

```powershell
python scripts/report-mail-kpis.py --report-dir <report-dir>
```

3. If the user asks for related emails, threads, sender-specific items, or delayed replies, query the structured outputs:

```powershell
python scripts/query-mail-report.py --report-dir <report-dir> --mode emails --subject-contains "project x"
python scripts/query-mail-report.py --report-dir <report-dir> --mode emails --sender "alice@example.com" --reply-status not_replied
python scripts/query-mail-report.py --report-dir <report-dir> --mode threads --min-message-count 3
```

4. Only inspect raw source files for the few rows that remain relevant after filtering.

## Output Rules

- Prefer report-driven answers over raw-mail summaries.
- When using filtered results, name the report path and the filters used.
- Distinguish header-based linkage from fallback subject-based linkage when confidence matters.
- If a question needs exact wording from a specific email, reopen only the listed `source_file` rows.
- If the dataset includes `.msg` files and the parser dependency is missing, say so explicitly and continue with the successfully parsed files.

## Tool-Substitution Strategy

- Do not paste or reason over large mail folders directly when scripts can precompute the answer.
- Treat `emails.csv` and `threads.csv` as the default reasoning surface for follow-up work.
- Use `report-mail-kpis.py` for metrics instead of manual counting.
- Use `query-mail-report.py` for narrowing candidate emails instead of loading full reports into context.
- Escalate to raw mail content only for drafting, ambiguity resolution, or evidence quoting.

## References

- Read [references/workflow.md](references/workflow.md) for the end-to-end operating pattern.
- Read [references/report-schema.md](references/report-schema.md) when you need field meanings or want to build more filters.

## Example Requests

- "Read an exported Outlook mail folder and find emails related to supplier follow-up."
- "Calculate which emails took more than 48 hours to receive a first reply."
- "Find unreplied threads from the whole dataset."
- "Convert raw mail into reports first, then filter by subject and sender."
