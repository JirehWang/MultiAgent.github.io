---
name: project-delivery-governor
description: Govern multi-step project delivery so work keeps moving without constant user supervision. Use when Codex needs to run or restore a cross-stage execution loop that includes task-wall management, blocker parking, next-task selection, architecture SSOT upkeep, state-gate checks, milestone promotion, or autonomous project follow-through across planning, implementation, verification, and handoff.
---

# Project Delivery Governor

## Overview

Run governed project delivery as one continuous workflow, not as isolated one-off tasks.

Own the delivery loop when the request is about keeping a project moving across multiple stages, especially when the user wants less manual supervision and clearer operational state.

## Workflow

1. establish or refresh the architecture SSOT
2. derive or refresh the task wall
3. move blocked work into blocker parking instead of freezing the project
4. pick the next ready task
5. execute or delegate that task
6. run the relevant verification
7. apply a state gate before promoting status
8. repeat until no safe ready task remains

## Core Rules

- stay the primary owner across planning, execution, verification, and promotion
- do not collapse the workflow into a one-shot plan if the request is clearly about continued delivery management
- do not leave blocked work mixed into the active queue; park it explicitly
- do not claim progress only because code changed; pass a state gate first
- do not let delegated support skills silently own the overall project state
- use support skills for local expertise, but keep the task wall and state model centralized here

## Support-Skill Routing

- architecture framing or workflow topology -> `multi-agent-systems-architect`
- project boundary or repo understanding -> `context-scout`
- delivery-board or execution-plan artifact -> `writing-plans`
- parallel implementation tracks -> `subagent-driven-development`
- completion proof or promotion checks -> `verification-before-completion`
- revision and push-readiness checks -> `git-version-management`
- implementation work itself -> choose the best domain or execution skill after governance state is clear

## Required Artifacts

Maintain or create these artifacts when the request is substantive:

- architecture SSOT
- task wall
- blocker parking log
- state gate checklist

Read [references/operating-cycle.md](references/operating-cycle.md) for the operating model.

Read [references/artifact-templates.md](references/artifact-templates.md) when creating or refreshing the governance artifacts.

## Decision Triggers

Take ownership when the request sounds like:

- keep pushing the project
- do not make me watch every step
- build a task wall
- park blockers and continue
- choose the next task automatically
- keep one architecture SSOT
- gate status changes before claiming done
- resume governed delivery from partial progress

## Outputs

Return a compact governance update that includes:

- current objective
- active tasks
- parked blockers
- next selected task
- verification state
- whether the state gate passed
- what needs user escalation, if any

## Boundaries

- do not use this skill for tiny one-file edits or simple questions
- do not use this skill when the user wants a one-time plan only; use `writing-plans`
- do not use this skill when the request is pure implementation with already-clear local scope
- do not use this skill when the request is only architecture exploration with no delivery loop

## Notes

If the user request is broad and the project state is unclear, rebuild the minimum architecture SSOT first, then resume the loop rather than improvising from scattered context.
