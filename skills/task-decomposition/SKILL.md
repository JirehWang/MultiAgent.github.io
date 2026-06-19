---
name: task-decomposition
description: Use when a task is large, cross-cutting, or naturally divisible, so the agent should split it into bounded workstreams before execution.
---

# Task Decomposition

Use this skill only when decomposition improves clarity, safety, or speed.

## Caveman Compression

For workstream summaries and handoff packets, use caveman style: compact labels, exact scope, dependencies, risks, and verification. No filler. Do not compress final user-facing rationale.

## Workflow

1. Restate the goal and key constraints.
2. Split work into natural workstreams:
   - investigation
   - implementation
   - verification
3. For each workstream, label:
   - type
   - risk
   - independence
4. State dependencies between workstreams.
5. Choose one mode:
   - single-agent
   - parallel-investigation
   - subagent-implementation
   - plan-first
6. For large tasks, dispatch by stage, not all at once.
7. Keep simultaneously active agents within about 3-4, including the manager when relevant.
8. If dispatching, create a handoff packet with:
   - goal
   - exact scope
   - non-goals
   - required verification
9. Recompose results and verify final integration yourself.

## Rules

- Do not decompose small or obvious tasks.
- Do not split by filename alone.
- Prefer workflow boundaries over file boundaries.
- Use subagents only when context isolation helps.
- Keep handoffs self-contained.
- Do not claim completion without final verification.

## Output Format

Goal:
Constraints:
Workstreams:
Dependencies:
Mode:
Verification:
