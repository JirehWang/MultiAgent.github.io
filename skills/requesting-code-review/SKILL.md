---
name: requesting-code-review
description: Use when important implementation is done and you want an independent review focused on bugs, regressions, and missing tests
---

# Requesting Code Review

Request review after implementation and before merging when independent scrutiny is valuable. The reviewer should act like a bug finder and mentor, not a co-author polishing style.

## Caveman Compression

For review packets and findings, use caveman style: priority, file, impact, evidence, fix direction. Keep each finding tight. Do not compress source quotes, code snippets, or final user-facing explanation.

Workflow:
1. Collect the diff, requirements, verification results, and any known risk areas.
2. Ask the reviewer to inspect the diff first.
3. If repo context is needed, add a short `Gitingest` summary for the affected subsystem.
4. If surrounding implementation detail matters, add a focused `Repomix` pack for related files only.
5. Ask for findings first, ordered by severity, with file references, concrete impact, and testing gaps.
6. Ask the reviewer to call out assumptions or open questions separately from confirmed bugs.
7. Ask the reviewer to use clear priority buckets such as blocker, suggestion, and nit.

Rules:
- Review the changed area, not the whole repo.
- `Gitingest` is for subsystem orientation.
- `Repomix` is for nearby source context that affects correctness.
- Do not drown the reviewer in packed context.
- Generated summaries never override the real diff and source files.
- Prioritize correctness, regressions, security, data loss, compatibility, and missing coverage before style.
- Separate bugs from optional improvements or nits.
- Ask the reviewer to say explicitly when no findings were found.
- Prefer evidence tied to code paths, tests, or behavior over vague suspicion.
- Prefer comments that explain why something matters, not only what to change.
- When intent is unclear, ask the reviewer to question it instead of assuming the code is wrong.
