---
name: subagent-driven-development
description: Use when executing a written plan with 3 or more mostly independent tasks where isolated context will improve speed or quality
---

# Subagent-Driven Development

Use subagents for substantial planned work, not small fixes.

Workflow:
1. Read the plan and extract clear task boundaries.
2. Dispatch only tasks that are mostly independent.
3. For each subagent, provide: goal, exact scope, non-goals, verification, and summary format.
4. If plan context is broad, add a short `Gitingest` summary for the relevant subsystem.
5. If implementation detail is needed, add a focused `Repomix` pack for only the narrowed files or subtree.
6. Review returned work and run verification yourself.

Rules:
- Start from the written plan, not from whole-repo context.
- Keep prompts self-contained and small.
- Never use whole-repo `Repomix` by default.
- Do not trust summaries alone when code behavior matters.
- Avoid subagents when tasks touch the same files heavily.
