---
name: rohs-pdf-analysis
description: Extract, audit, and judge RoHS PDF test reports, including scanned or multi-report PDFs, substance results, report metadata, confidence, and Excel output. Use when analyzing RoHS/IEC 62321/2011-65-EU/2015-863 laboratory PDFs or converting them into auditable structured results.
---

# RoHS PDF Analysis

Analyze laboratory PDF reports and produce an evidence-backed RoHS workbook. This is normally a delegated Antigravity task: Codex first runs `agy auth login`, confirms the authenticated session, then packages the input files and sends one bounded task; Antigravity runs OCR, performs the report review, makes the RoHS judgment, fills the workbook, and reports completion. Codex only checks that the delegated task returned, the expected workbook exists, and the artifact is readable. Do not redo the report analysis in Codex unless delegation fails or the output cannot be verified.

Before every delegated run, use the explicit Antigravity login flow:

```cmd
agy auth login
agy models
```

Do not use a prompt-only command as a substitute for login. If login or model discovery fails, stop dispatch and report the authentication failure.

## Default delegation contract

Delegate the whole task to Antigravity when the request is routine and self-contained. The handoff must include:

- absolute paths of the PDF inputs;
- the required output workbook path and sheet format;
- permission to use the bundled extractor and OCR;
- the requirement to review OCR anomalies, including decimal-point and table-column errors;
- the requirement to fill `RoHS_Result`, `Extraction_Audit`, and `PDF_Inventory`;
- a completion report listing processed files, decisions, exceptions, and output path.

After delegation, verify only the completion signal, output path, workbook existence/readability, expected sheet names, and that the delegated report lists all inputs. Do not independently re-extract or re-judge normal records.

## Core rule: Antigravity performs the delegated judgment

Do not call Gemini, NVIDIA, or any other unrelated external provider. Antigravity performs report classification, field repair, OCR review, and compliance decisions within the delegated task. Do not read or copy API keys from `.env` files. Codex only verifies delegation completion and output integrity unless an exception requires escalation.

For every uncertain record:

1. Decide whether the document is RoHS-related from directive wording, restricted-substance tables, lab/test context, and report purpose.
2. Verify report number, date, laboratory, sample/part, and each of the 10 restricted substances against nearby page evidence.
3. Normalize `n.d.`, `not detected`, `pass`, `<limit`, numeric values, units, and obvious OCR spacing errors without inventing missing values.
4. Mark unresolved fields as unknown and explain the evidence gap in notes.
5. Decide compliance only when the report covers the applicable restricted substances and every reported value is within the stated limit or explicitly compliant. Otherwise use an indeterminate outcome and state why.
6. Record the reasoning, source page(s), confidence, and any correction in the audit output.

### OCR and token-saving safeguard

Use OCR as the normal first-pass extractor. Antigravity owns both the OCR review and the report judgment for this delegated task. Do not split the same report into separate Codex analysis work. Apply deterministic rules first:

- accept clear `ND`/`N.D.`/`Not Detected` values;
- accept explicit laboratory `Pass`/`Comply` conclusions when the required RoHS items are present;
- accept numeric values that have a clear result/limit column mapping and are plainly below the report limit;
- invoke Codex review only for anomalies: missing results, conflicting extraction methods, values near a limit, suspicious decimal/column mapping, garbled OCR, or a report conclusion that conflicts with the table.

When review is triggered, Antigravity inspects only the relevant page/table crop and field, not the entire report. OCR can drop decimal points or merge columns (for example `4.61` versus `461`), so a suspicious numeric field must be checked against the source image before finalizing it. Record the corrected value and page in the audit notes.

## Workflow

1. Identify the input PDFs. For a folder, use the bundled script with `--input`; for selected files, pass repeated `--file` arguments.
2. Authenticate Antigravity explicitly, then verify the selected model with `agy models` before dispatching.
3. Run deterministic extraction with AI disabled:

   ```powershell
   python scripts/rohs_pdf_extract.py --input <pdf-folder> --output <output.xlsx> --no-ai
   ```

   The script writes per-PDF JSON to `intermediate_json` and an initial workbook to `outputs` unless explicit paths are supplied.

4. Inspect the extracted JSON and source PDF pages for records with low text, fallback/OCR flags, split report numbers, missing results, contradictory values, or low confidence; include exceptions in the Antigravity handoff.
5. Dispatch the complete review to Antigravity. Preserve original evidence and distinguish extracted facts from interpretation in the requested workbook.
6. Validate only that every input PDF has a delegated record, no API key was exposed, and the workbook opens successfully.

## Substance checklist

Check Lead, Mercury, Cadmium, Hexavalent Chromium, PBBs, PBDEs, DEHP, BBP, DBP, and DIBP. Use the report's own limits when present; do not silently substitute a regulatory limit when the report does not state one.

## Failure handling

- For image-only PDFs, use available local OCR/PDF fallback tools, then inspect the rendered page evidence.
- For multi-report PDFs, split by report number/page group and retain the original file plus page range.
- For conflicting extraction methods, prefer clearly rendered table evidence and document the conflict.
- Never infer a pass from an empty cell, a missing table, or a generic declaration alone.

## Bundled resource

- `scripts/rohs_pdf_extract.py`: deterministic extractor and Excel first-pass generator copied from the source project. Its network AI-assistance path is intentionally not part of this skill's workflow.
