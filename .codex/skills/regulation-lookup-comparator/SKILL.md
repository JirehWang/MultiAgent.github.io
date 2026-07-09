---
name: regulation-lookup-comparator
description: Use when performing green-product regulatory lookup, customer-control extraction, internal-control extraction, or gap analysis across regulatory controls, customer controls, and internal controls. Use for compliance work involving PPWR, RoHS, REACH, batteries, packaging, PFAS, TSCA, conflict minerals, or similar material compliance topics where exact dates, official legal sources, role split, evidence requirements, and Excel-based comparison outputs are required.
---

# Regulation Lookup Comparator

Create reusable regulatory lookup and comparison outputs for green-product compliance review.

## What This Skill Is For

Use this skill when the task is to:

- look up current regulatory requirements from official sources
- extract customer control items from PDF, DOCX, XLSX, or screenshots
- extract internal control items from SOPs, specs, declarations, or forms
- compare `regulatory controls`, `customer controls`, and `internal controls`
- determine manufacturer / brand owner / importer / distributor responsibility split
- prepare evidence lists, effective dates, transition dates, and implementation timing
- output the result in the established Excel comparison format

## Core Rules

1. Always verify current legal requirements from primary or official sources.
2. Always use exact dates such as `2029-02-12`; do not rely on vague wording like `later` or `soon`.
3. When ingesting a law or revision package, first classify whether it is:
   - `增修條文`
   - `舊版廢除並改新版`
   - `全新法規`
4. When dates differ, separate:
   - publication date
   - entry-into-force date
   - application date
   - delegated / implementing act deadline
   - transitional period end date
5. When a requirement is role-specific, explicitly state:
   - `屬我方責任`
   - `非我方責任`
   - `主要為品牌商責任`
   - `主要為進口商責任`
   - `需依商業模式再確認`
6. Distinguish `測試證據`, `宣告文件`, `技術文件`, `追溯識別`, and `標示要求`.
7. If detailed implementing rules are not yet issued, state that clearly and separate:
   - what is already mandatory now
   - what is technically foreseeable
   - what still depends on future implementing acts

## Workflow

1. Confirm the task type.
   - Regulatory lookup
   - Customer document extraction
   - Internal rule extraction
   - Three-way gap analysis
2. Identify source artifacts.
   - Official law / regulation
   - Customer PDF / DOCX / XLSX / screenshot
   - Internal SOP / spec / declaration / form
3. If the source is a file, extract first.
   - Prefer `markitdown` for PDF / DOCX / supported files
   - Preserve chapter order and clause references
4. Normalize controls into structured items.
5. Map each item to:
   - topic
   - source clause
   - role
   - responsibility
   - required evidence
   - effective date
   - transition / old-rule note
   - related customer/internal clause
6. Build the workbook in the standard format.

## Required Output Format

Unless the user explicitly requests another format, output using the Excel template standard defined in:

- `C:\Users\105221\Documents\Codex\2026-06-24\new-chat\outputs\ALSO_PPWR_製造商責任判讀表.xlsx`

Follow the format guidance in:

- `C:\Users\105221\Documents\Codex\2026-06-24\new-chat\docs\output-format-standard.md`

Default workbook structure:

1. `摘要`
2. `主對應/責任判讀表`
3. `時程與舊規` or equivalent timing / transition sheet

Main table should preserve, when relevant:

- requirement / topic
- role applicability
- whether it is our responsibility
- evidence needed
- effective date
- transition note
- remarks / limits / assumptions
- related customer clause
- related internal clause

## Source Priority

For legal lookup, use this order:

1. official legal text / official regulator source
2. official agency implementation guidance
3. customer document original text
4. internal SOP / spec / declaration

Do not let secondary summaries override official text.

## Role Split Rules

Always interpret obligations according to the user's actual role. If the user states they are a manufacturer rather than a brand owner or importer, filter the result accordingly and explicitly identify the non-applicable items.

## Evidence Classification

Use these categories consistently:

- `測試證據`
  - lab test report
  - analytical report
  - material composition test
- `宣告文件`
  - DoC
  - supplier declaration
  - non-use statement
- `技術文件`
  - BOM
  - material structure
  - drawings
  - assessment records
- `識別/追溯`
  - part number
  - batch / lot
  - manufacturer information
  - linked document ID
- `標示`
  - physical label
  - printed marking
  - QR / digital data carrier

## Recommended Structured Fields

When extracting laws or controls, normalize to fields like:

- `control_id`
- `control_type`
- `topic`
- `source_document`
- `source_clause`
- `control_statement`
- `applicable_role`
- `our_responsibility`
- `evidence_required`
- `effective_date`
- `transition_note`
- `related_customer_clause`
- `related_internal_clause`
- `remarks`

Read [input-schema.md](references/input-schema.md) when preparing or validating ingestion fields.

## File Extraction Guidance

- Use `markitdown` first for PDF / DOCX extraction when available.
- Preserve the original clause order from customer or internal documents.
- If the extracted text is noisy, still keep the original section numbering and table context.
- For screenshots, capture only what is visible and flag uncertainty.

## Common Compliance Topics

This skill is especially suitable for:

- PPWR
- packaging substance restrictions
- recyclability
- minimisation of packaging
- labeling obligations
- battery substance and labeling rules
- RoHS
- REACH SVHC
- REACH Annex XVII
- PFAS
- TSCA PBT
- conflict minerals
- SCIP-related data preparation
- hazardous substance declarations for networking products

## Red Flags

- Mixing projected implementing-act dates with actual application dates
- Treating customer requests as if they were already law
- Forgetting transition periods
- Forgetting to split role responsibility
- Using generic wording instead of exact dates
- Listing evidence without saying what actual file type it means
- Rebuilding a new workbook layout instead of using the standard template

## Deliverables

Typical deliverables:

- structured JSON controls
- Chinese summary markdown
- Excel comparison matrix in the standard workbook format

