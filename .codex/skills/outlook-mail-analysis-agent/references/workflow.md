# Workflow

Use this workflow to minimize token usage while keeping analysis traceable.

## 1. Ingest Once

Convert raw mail exports into structured files once per dataset.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/run-mail-workflow.ps1 -InputDir <raw-mail-dir> -OutputDir <report-dir>
```

Outputs:

- `emails.csv`
- `threads.csv`

## 2. Query Reports First

For most questions, operate on generated reports instead of raw email bodies.

Examples:

```powershell
python scripts/query-mail-report.py --report-dir <report-dir> --mode emails --reply-status not_replied
python scripts/query-mail-report.py --report-dir <report-dir> --mode emails --sender "alice@example.com"
python scripts/query-mail-report.py --report-dir <report-dir> --mode threads --subject-contains "rfq"
```

## 3. Compute Metrics with a Script

For summary metrics, use:

```powershell
python scripts/report-mail-kpis.py --report-dir <report-dir>
```

This avoids manual counting and keeps follow-up prompts short.

## 4. Reopen Raw Emails Only When Needed

Only reopen `source_file` entries when:

- exact wording matters
- evidence quoting is required
- thread linkage is ambiguous
- the user asks for draft replies based on email content

## 5. State Confidence Clearly

- High confidence: direct `Message-ID` / `In-Reply-To` / `References` linkage
- Medium confidence: thread-level grouping from normalized subject plus participants and time window
- Lower confidence: user asks for semantic relatedness beyond thread structure
