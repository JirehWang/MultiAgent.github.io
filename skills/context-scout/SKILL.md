---
name: context-scout
description: Use when starting medium or large code changes, unfamiliar repo work, cross-file behavior changes, or when the relevant files, entry points, data flow, or existing patterns are not yet clear
---

# Context Scout

Map the codebase before changing it. This skill prevents premature edits by finding the relevant files, ownership boundaries, data flow, and local conventions first.

## When To Use

Use for:

- Unfamiliar repositories or areas of the codebase.
- Medium or large changes touching multiple files.
- Behavior changes where the entry point is unclear.
- Features involving routes, APIs, state, storage, jobs, scripts, or integrations.
- Before planning work when you need a reliable mental map.

Skip for:

- Tiny single-file edits with obvious context.
- Pure text/content updates.
- User explicitly asks to skip exploration.

## Scout Workflow

1. Identify the repo shape: top-level files, package/framework markers, docs, tests.
2. Find likely entry points with `rg`, `rg --files`, routes, config, package scripts, or filenames from the request.
3. Trace the path from user action/input to output/side effect.
4. Find local patterns: nearby similar features, helper APIs, naming, test style, error handling.
5. Note risk areas: shared modules, generated files, external services, caches, migrations, global state.
6. Return a concise map before implementation or planning.

## Output Format

Keep the scout report short:

```text
Relevant files:
- path: why it matters

Flow:
input/action -> module/function -> side effect/output

Patterns to follow:
- existing convention or helper

Risks / unknowns:
- item needing care or confirmation

Recommended next step:
- direct edit, plan, test-first fix, or ask one question
```

## Red Flags

- Editing before knowing the entry point.
- Searching only for one exact name and stopping.
- Ignoring nearby similar implementations.
- Treating generated/build/vendor files as source of truth.
- Producing a huge repo summary instead of a focused map.

## Handoff

After scouting:

- For small clear work, proceed directly.
- For multi-step work, use `writing-plans`.
- For bugs discovered during scouting, switch to `systematic-debugging`.
- For UI changes, pair with `visual-qa` during verification.
