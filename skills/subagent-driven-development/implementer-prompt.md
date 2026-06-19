# Implementer Prompt

Use this template when assigning a narrow implementation track to a subagent.

## Prompt

You are implementing one scoped track.

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
- Ask before changing unrelated files.
- Prefer the smallest correct implementation.
- Preserve existing conventions.
- Run required verification if possible.
- Report blockers with exact evidence.

Return:

```
Changed:
- [file] [summary]

Verification:
- [command/check] [result]

Risks:
- [risk or none]

Next:
- [needed follow-up or none]
```
