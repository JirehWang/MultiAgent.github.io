# Implementer Prompt

Use this template when assigning a narrow implementation track to a subagent.

## Prompt

You are implementing one scoped track.

Parent task packet:

`[PARENT_TASK_PACKET]`

Child task packet:

`[CHILD_TASK_PACKET]`

Exact inherited `dispatch_contract` (copy unchanged from the parent):

`[INHERITED_DISPATCH_CONTRACT]`

Contract gate:

- Validate both task packets and the inherited `dispatch_contract` before work.
- If any contract is missing or invalid, return `contract-invalid`, list the exact issue, and escalate. Never infer defaults.
- The child may narrow only `objective`, `decomposition`, `ownership`, `constraints`, and `acceptance_standards`.
- Do not change `execution_required`, `runtime_overlay`, `global_contract`, `validation_tier`, `required_gates`, `required_artifacts`, or `acceptance_owner`.

Goal:

`[GOAL]`

Scope:

`[EXACT_SCOPE]`

Non-goals:

`[NON_GOALS]`

Context:

`[RELEVANT_FILES_AND_NOTES]`

Required verification:

`[COMMANDS_OR_CHECKS]`

Rules:

- Stay inside scope.
- Do not invoke brainstorming, writing-plans, executing-plans, or subagent-driven-development. Execute this brief directly.
- Ask before changing unrelated files.
- Prefer the smallest correct implementation.
- Preserve existing conventions.
- Run required verification if possible.
- Report blockers with exact evidence.
- Execute only; do not return acceptance, `pass`, `retry`, or `rollback`. The independent acceptance process returns those decisions.

Return:

```
Changed files:
- [file] [summary]

Artifacts:
- [artifact] [location or none]

Verification evidence:
- [command/check] [result]

Gaps:
- [gap, blocker, risk, or none]
```
