---
name: subagent-driven-development
description: Use when a decomposed plan has moderate or high complexity and includes implementation tracks that are mostly independent, context-heavy, or better isolated for quality.
---

# Subagent-Driven Development

Use subagents for substantial decomposed work, not small fixes.

Apply the anti-overengineering ladder from
`C:\Users\105221\.codex\skills\using-superpowers\ANTI_OVERENGINEERING_POLICY.md`
before dispatch. Do not multiply agents when a single well-scoped execution path is enough.

## Caveman Compression

For manager notes and subagent handoffs, use caveman style: compact labels, exact scope, non-goals, verification, and return format. No filler. Do not compress final user-facing rationale.

## Trigger

Prefer subagents when these are true:
- the task was decomposed first
- complexity is moderate or high
- at least one implementation track benefits from context isolation
- tracks have limited file overlap

Task count is only a hint, not the main rule.

## Complexity Signals

- cross-subsystem scope
- dependency depth
- unclear local reasoning burden
- large context packs
- high verification burden
- conflict risk if one agent keeps all context

Treat complexity as moderate/high when 2 or more of these are true:
- 2+ subsystems or responsibility boundaries are involved
- there are meaningful dependencies between tracks
- some coding should wait on investigation or design choice
- verification spans multiple surfaces such as code, tests, UI, or data flow
- one agent would likely carry too much context at once

Treat context isolation as beneficial when 1 or more of these are true:
- a track can be solved from a narrow repo slice
- file overlap between tracks is low
- a track needs concentrated domain focus
- returned outputs can be recomposed from a standard summary format

For large tasks, dispatch by stage, not all at once.
Keep simultaneously active agents within about 3-4, including the manager when relevant.

Decomposition guard:
- first ask whether the apparent complexity comes from the task itself or from an avoidable abstraction, oversized scope, or premature parallelism
- if a smaller plan or narrower scope removes the need for subagents, prefer that

## Workflow

1. Read the decomposition or plan.
2. Check whether the work can stay single-agent after narrowing scope or reducing unnecessary structure.
3. Extract only the tracks worth isolating.
4. Dispatch each subagent with:
   - goal
   - exact scope
   - non-goals
   - verification
   - return summary format
5. Keep prompts self-contained and narrow.
6. Review returned work and run final verification yourself.

## Rules

- Do not dispatch purely because there are many tasks.
- Do not create subagents to compensate for a plan that is too broad, vague, or overbuilt.
- Avoid subagents when tracks touch the same files heavily.
- Prefer one agent over many when the same safety and quality can be achieved without parallel coordination overhead.
- Do not trust summaries alone when behavior matters.
- The manager agent owns recomposition and final judgment.
