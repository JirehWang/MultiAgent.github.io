---
name: subagent-driven-development
description: 當在目前會話中執行已有書面計畫，且包含 3 個以上可獨立完成或審查的任務時使用
---

# Subagent-Driven Development

Use subagents when independent context actually improves speed or quality. This skill is for executing a written plan, not for ordinary small implementation work.

## When To Use

Use when all are true:

- There is a written implementation plan or clearly enumerated task list.
- There are 3 or more tasks or review areas.
- Tasks are mostly independent and can be scoped cleanly.
- The work is substantial enough that isolated context or independent review is worth the overhead.

Do not use for:

- Small fixes.
- One or two tightly coupled tasks.
- Exploratory debugging where the root cause is unknown.
- Work where subagents would edit the same files at the same time.

## Workflow

1. Read the plan and extract task boundaries.
2. Decide which tasks genuinely benefit from subagents.
3. Give each subagent a focused, self-contained prompt with scope, constraints, and expected output.
4. Review returned changes or findings before integrating.
5. Run the relevant verification yourself before claiming success.

## Prompt Shape

Each subagent prompt should include:

- Goal.
- Files or subsystem to inspect.
- Constraints and non-goals.
- Verification expected.
- Summary format.

Keep prompts narrow. A vague “fix everything” prompt wastes the advantage of isolated context.

## Review

For risky implementation, use two review passes when valuable:

- Spec fit: did it implement what was asked, without extra scope?
- Code quality: is it maintainable, tested, and consistent with the codebase?

For straightforward tasks, one careful review is enough.

## Red Flags

- Dispatching subagents before understanding the plan.
- Parallel edits to the same file or shared state.
- Trusting a subagent success report without checking diff and running verification.
- Using subagents to avoid making an architectural decision.
- Adding subagent overhead to work that is faster to do directly.
