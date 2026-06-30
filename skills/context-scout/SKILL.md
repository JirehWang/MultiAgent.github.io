---
name: context-scout
description: Use when starting medium or large code changes, onboarding to an unfamiliar repo, or when the relevant files, entry points, or data flow are not yet clear
---

# Context Scout

Map the codebase without over-reading it. This skill is also the default home for lightweight codebase onboarding.

Use for unfamiliar repos, cross-file changes, unclear entry points, or when another agent would benefit from a crisp orientation pack. Skip tiny single-file edits.

Workflow:
1. Start with local search: `rg`, filenames, routes, config, scripts, tests.
2. If the repo is large, architectural boundaries are unclear, or the user asked for a codebase map, prefer `codebase_memory` before broad manual crawling.
3. If onboarding depends on remote PRs, issues, workflow runs, or repo state outside the local checkout, use `github`.
4. If onboarding starts from PDFs, docs, slides, or exported reports, use `markitdown` first to ingest the source material.
5. If the repo is large or boundaries are still unclear after that, use `Gitingest` for a high-level map.
6. Narrow to the few files or directories that matter.
7. If exact cross-file logic is still unclear, use `Repomix` only on that narrowed subtree or file set.
8. Read the real source and trace input -> module -> side effect.
9. Report only the context needed to move work forward:
   relevant files, entry points, data flow, commands to run, local conventions, risks, next step.

Rules:
- Evaluate enabled MCPs first when they can remove repo-discovery uncertainty faster than more file crawling.
- Prefer `codebase_memory` for map questions; prefer exact source reads for proof.
- Prefer `github` over guesswork when the missing context is remote GitHub state.
- Prefer `markitdown` over ad hoc scraping when the source is document-heavy.
- `Gitingest` is for orientation, not proof.
- `Repomix` is for focused deep context, not whole-repo dumping.
- Never let generated summaries replace exact file reads.
- Ignore generated, vendor, or build output unless they are the true source of behavior.
- When onboarding, prefer a compact map over a long narrative.
- State facts grounded in inspected files; if something was not inspected, say so.
- Use exact file paths, function names, routes, commands, or config keys when they matter.
- Capture conventions that affect future edits: naming, folder layout, testing style, env/config loading, and common scripts.
- If the repo has an obvious "start here" path, say it explicitly instead of listing many equal-weight files.
- Surface ambiguity, duplicate abstractions, dead-looking code, or misleading names as onboarding risks, but do not slide into review or redesign.
- If you include a suggested next action, keep it separate from the factual repo map.
