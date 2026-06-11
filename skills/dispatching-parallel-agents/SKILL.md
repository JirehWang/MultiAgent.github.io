---
name: dispatching-parallel-agents
description: Use when 2 or more investigations or review tasks are independent enough to run in parallel with isolated context
---

# Dispatching Parallel Agents

Use parallel agents only when tasks are independent and can be scoped cleanly.

Workflow:
1. Split work into non-overlapping tasks.
2. Give each agent a narrow goal, exact files or subsystem, constraints, and expected output.
3. If the area is large or unfamiliar, attach a short `Gitingest` summary for that area.
4. If the agent needs exact implementation context, attach a focused `Repomix` pack for only the narrowed files or subtree.
5. Review all results yourself before integrating.

Rules:
- Prefer direct file paths over generic repo summaries.
- Do not send full-repo `Repomix` for narrow tasks.
- Do not give two agents overlapping edit scope.
- `Gitingest` helps orientation; `Repomix` helps depth.
- Generated context must support, not replace, the agent reading real files.
