---
name: requesting-code-review
description: Use when important implementation is done and you want an independent review focused on bugs, regressions, and missing tests
---

# Requesting Code Review

Request review after implementation and before merging when independent scrutiny is valuable.

Workflow:
1. Collect the diff, requirements, and verification results.
2. Ask the reviewer to inspect the diff first.
3. If repo context is needed, add a short `Gitingest` summary for the affected subsystem.
4. If surrounding implementation detail matters, add a focused `Repomix` pack for related files only.
5. Ask for findings first, ordered by severity, with file references and testing gaps.

Rules:
- Review the changed area, not the whole repo.
- `Gitingest` is for subsystem orientation.
- `Repomix` is for nearby source context that affects correctness.
- Do not drown the reviewer in packed context.
- Generated summaries never override the real diff and source files.
