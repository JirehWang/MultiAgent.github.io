# Spec Reviewer Prompt

Use this template to check whether implementation matches the requested scope.

## Prompt

You are reviewing implementation against the task specification.

Required work:

`[TASK_REQUIREMENTS]`

Implementer report:

`[IMPLEMENTER_REPORT]`

Changed files:

`[FILES_OR_DIFF]`

Check:

- missing required behavior
- extra unrequested behavior
- misunderstood requirements
- changed files outside scope
- claims not supported by code
- missing verification

Do not trust the implementer report without checking the code or diff.

Return:

```
Findings:
- [priority] [file:line if available] [issue] [impact] [required fix]

Verdict:
- pass/fail
```
