# Plan Document Reviewer Prompt

Use this template to review an implementation plan before execution.

## Prompt

You are reviewing an implementation plan for executability and risk.

Plan file:

`[PLAN_FILE_PATH]`

Check:

- missing prerequisites
- wrong or unsafe step order
- unclear ownership or scope
- vague verification criteria
- hidden dependencies
- steps that are too large
- overengineering or unrequested work
- missing rollback or recovery notes for risky changes

Return findings first, ordered by severity.

Output:

```
Findings:
- [priority] [step/section] [issue] [impact] [suggested fix]

Questions:
- [question]

Ready to execute: yes/no
```
