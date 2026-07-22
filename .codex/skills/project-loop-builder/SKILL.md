---
name: project-loop-builder
description: Create and maintain a project-folder AI development loop. Use when a project needs a LOOP.md, durable state, run records, budgets, skill reuse, or a standardized workflow assembled from existing global and project skills.
---

# Project Loop Builder

Create the smallest useful loop for one project folder. This skill builds orchestration and project state; it is not a general coding, debugging, or maintenance agent.

## Workflow

1. Identify the project root and inspect its existing instructions, skills, tests, package configuration, and repository state.
2. Inspect the global skill registry and the project's local `skills/` directory.
3. Build a capability registry before creating anything:
   - reuse a global skill when it already covers the capability;
   - reuse a project skill when it already covers the capability;
   - create a project-local skill only when neither scope provides it and the capability is genuinely project-specific;
   - never copy a global skill into the project just to reference it.
4. Define the loop objective, task sources, stages, completion criteria, allowed actions, forbidden paths, retry ceiling, token/time budget, and human gates.
5. Create or update the project loop directory at `.loop/`:
   - `LOOP.md`: workflow, permissions, gates, escalation, and skill references
   - `STATE.md`: durable current state and next action
   - `registry.yaml`: global/project skill references and loop stages
   - `loop-budget.md`: cadence, token/time budget, and retry limits
   - `loop-run-log.md`: timestamped run evidence and outcomes
6. Start in report-only mode. Do not enable unattended edits, commits, merges, or external side effects without an explicit human gate.
7. Validate that every referenced skill exists, every stage has an owner, and the workflow has a verifier and escalation path.

## Folder Scope Rules

- `.loop/` belongs to one project root and must not mix state between projects.
- A child directory inherits the nearest ancestor `.loop/` unless it has its own `.loop/`.
- Project state stays in the project folder; do not write project state into the global skill directory.
- Keep reusable capabilities global or project-local; keep sequencing and policy in `LOOP.md`.
- Do not create a new skill when an existing skill can be referenced and composed.

## Required Loop Stages

Unless the project explicitly has a different need, compose these stages from existing capabilities:

```text
discover/context
-> plan or triage
-> implement
-> verify
-> state update
-> human gate or safe completion
```

Prefer existing capabilities such as `context-scout`, `systematic-debugging`, `test-driven-development`, `using-git-worktrees`, and `verification-before-completion`. Add only the missing project-specific stage.

## Safety

- Treat ambiguous requirements as an escalation, not permission to invent scope.
- Use an isolated worktree for fix-capable loops when the project supports Git.
- Stop on repeated identical failures, exceeded retry/token budgets, missing verification, or forbidden-path access.
- Report created files, reused skills, newly created project-local skills, and unresolved decisions.
