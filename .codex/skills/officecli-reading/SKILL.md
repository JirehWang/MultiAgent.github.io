---
name: officecli-reading
description: Read and inspect .docx, .xlsx, and .pptx files with OfficeCLI when structured extraction, formatting diagnostics, HTML rendering, screenshots, or OpenXML validation is useful. Use as a document-tool support skill, not as a standalone coding agent.
---

# OfficeCLI Reading

Use OfficeCLI as a deterministic reader and inspector for Office documents. Let `doc-ops`, `documents`, `spreadsheets`, or `presentations` own the overall task and interpretation.

## Preconditions

- Check `officecli --version` before using the tool.
- If OfficeCLI is unavailable, report that fact and use the existing document skill/tool path; do not install it silently.
- Never run the vendor's one-line installer or overwrite other agent skill directories without explicit authorization.
- Prefer a pinned, checksum-verified release. Record the version used when evidence matters.

## Reading Workflow

1. Identify the file format and the user's requested information.
2. Run a low-cost structural read first:

```text
officecli view <file> outline
officecli view <file> stats
officecli view <file> text
```

3. Use structured inspection for targeted questions:

```text
officecli get <file> <path> --json
officecli query <file> <selector>
officecli dump <file> -o blueprint.json
```

4. For layout or visual questions, render evidence:

```text
officecli view <file> html -o output.html
officecli view <file> screenshot -o output.png
```

5. For quality checks, run:

```text
officecli validate <file>
officecli view <file> issues
```

6. Pass the extracted evidence to the owning document skill for analysis or editing.

## Safety and Integrity

- Treat Office files as untrusted input; do not execute embedded macros or external links.
- Use read-only commands for inspection unless the user explicitly requests editing.
- Before another program reads a file changed by OfficeCLI, run `officecli save` or `officecli close` so resident changes are flushed to disk.
- Do not infer visual correctness from text extraction alone; render when layout matters.
- Do not claim a document is valid or unchanged without fresh command output.
