---
name: using-superpowers
description: Use when starting a substantive task, choosing which workflow skills apply, or deciding whether a request needs lightweight handling or a fuller execution workflow.
---

# Superpowers Router

Classify the task before doing meaningful work. Choose the smallest workflow that still protects correctness.

## Fast-Track

Use fast-track for low-risk local work:
- questions
- context gathering
- small obvious edits
- mechanical cleanup

## Full Workflow

Use a fuller workflow when design, integration, or verification risk is real.

## Complexity Signals

Estimate complexity from these signals:
- multiple subsystems or filesets
- dependency depth between steps
- unclear approach or high uncertainty
- merge/conflict risk between tracks
- large context volume
- broad verification surface

If most signals are low, stay single-agent.
If complexity is moderate or high, decompose first.

Treat complexity as moderate/high when 2 or more of these are true:
- 2+ subsystems or responsibility boundaries are involved
- there are meaningful step dependencies
- investigation or design choice is required before coding
- verification spans more than one surface such as code, tests, UI, or data flow
- the agent would likely overload itself by keeping all context at once

Treat context isolation as useful when 1 or more of these are true:
- a subtask can be completed from a narrow file or subsystem slice
- different tracks have low file overlap
- a track benefits from deep focus in one domain such as frontend, backend, or tests
- results can be returned in a fixed format and recomposed cleanly

## Skill Routing

- creative design -> `brainstorming`
- multi-step plan needed -> `writing-plans`
- existing plan to execute -> `executing-plans`
- 2+ independent investigations -> `dispatching-parallel-agents`
- moderate/high complexity with isolatable implementation tracks -> `task-decomposition`
- after decomposition, use `subagent-driven-development` only if delegation will reduce context load or improve quality
- practical behavior change -> `test-driven-development`
- broken or unexplained behavior -> `systematic-debugging`
- done but needs verification -> `verification-before-completion`

## Rules

- Do not trigger subagents from task count alone.
- Use task count only as a weak hint.
- Prefer decomposition before delegation.
- Avoid heavy workflows for tiny obvious changes.
