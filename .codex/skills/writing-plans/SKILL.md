---
name: writing-plans
description: Use when a specification or multi-step request needs an implementation plan before coding.
---

# Writing Plans

Write plans that make execution safer and easier.

Before expanding scope, apply the anti-overengineering ladder from
`C:\Users\105221\.codex\skills\using-superpowers\ANTI_OVERENGINEERING_POLICY.md`.
Plans should prefer the smallest safe path that solves the requested problem.

Use for medium or large changes, cross-file work, unclear sequencing, or requests where the user asks for a plan.

## Workflow

1. Restate the goal.
2. List constraints, non-goals, and assumptions.
3. Check whether reuse, stdlib, native platform features, or a local edit can avoid extra architecture or dependencies.
4. Identify affected areas and unknowns.
5. Split work into ordered steps.
6. Mark dependencies and risky steps.
7. Define verification for each major step.
8. Keep the plan short enough to execute.

## Task Granularity

- Make each task an independently testable deliverable, normally 20-60 minutes of focused work.
- Fold setup, documentation, and mechanical edits into the deliverable that needs them.
- Split only where sequencing, risk, or independent acceptance justifies a boundary.
- Include exact interfaces or code snippets only when ambiguity would otherwise be costly.

## Rules

- Do not plan tiny obvious edits.
- Do not hide open questions inside the plan.
- Do not add speculative features.
- Do not create plan steps for abstractions, wrappers, or dependency additions unless they are necessary.
- Prefer fewer moving parts, fewer files, and fewer workflow stages when they still satisfy correctness.
- Prefer concrete file areas, commands, and checkpoints.
- Do not include full implementation code by default; avoid duplicating the same requirements across the plan, brief, and handoff.
- If implementation can start safely, make the next action obvious.

## Output Shape

Goal:
Constraints:
Steps:
Risks:
Verification:
