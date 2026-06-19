# Code Quality Reviewer Prompt

Use this template after scope compliance is checked.

## Prompt

You are reviewing code quality and correctness risks.

Diff or changed files:

`[DIFF_OR_FILES]`

Context:

`[RELEVANT_CONTEXT]`

Focus on:

- bugs and regressions
- security or data loss risk
- compatibility issues
- brittle assumptions
- missing tests
- excessive complexity
- maintainability problems with real impact

Do not spend time on style unless it affects correctness or maintainability.

Return findings first:

```
Findings:
- [priority] [file:line] [issue] [impact] [fix direction]

Test gaps:
- [gap or none]

Verdict:
- pass/fail
```
