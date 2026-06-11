---
name: context-scout
description: Use when starting medium or large code changes, unfamiliar repo work, or when the relevant files, entry points, or data flow are not yet clear
---

# Context Scout

Map the codebase without over-reading it.

Use for unfamiliar repos, cross-file changes, or unclear entry points. Skip tiny single-file edits.

Workflow:
1. Start with local search: `rg`, filenames, routes, config, scripts, tests.
2. If the repo is large or boundaries are still unclear, use `Gitingest` for a high-level map.
3. Narrow to the few files or directories that matter.
4. If exact cross-file logic is still unclear, use `Repomix` only on that narrowed subtree or file set.
5. Read the real source, trace input -> module -> side effect, and report:
   relevant files, flow, patterns to follow, risks, next step.

Rules:
- `Gitingest` is for orientation, not proof.
- `Repomix` is for focused deep context, not whole-repo dumping.
- Never let generated summaries replace exact file reads.
- Ignore generated, vendor, or build output unless they are the true source of behavior.
