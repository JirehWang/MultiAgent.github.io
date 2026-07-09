# Spec Document Reviewer Prompt

Use this template when asking a reviewer to inspect a written specification before planning or implementation.

## Prompt

You are reviewing a specification for completeness and consistency.

Spec file:

`[SPEC_FILE_PATH]`

Check:

- missing sections, TODOs, placeholders, or vague requirements
- internal contradictions
- unclear user flows, states, or acceptance criteria
- missing constraints, non-goals, or dependencies
- requirements that are too broad for the stated goal
- risks that should be resolved before planning

Return findings first, ordered by severity.

Output:

```
Findings:
- [priority] [file/section] [issue] [impact] [suggested fix]

Questions:
- [question]

Ready for planning: yes/no
```
