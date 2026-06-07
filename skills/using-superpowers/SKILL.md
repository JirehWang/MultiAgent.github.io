---
name: using-superpowers
description: Use when starting a substantive task, choosing which workflow skills apply, or deciding whether a request needs lightweight handling or a full implementation workflow
---

# Superpowers Router

Use this skill as a lightweight router. Its job is to choose the smallest useful workflow, not to make every request heavy.

## Core Rule

Classify the task before doing meaningful work. Do not force a workflow for simple answers, status updates, command output, or a single clarifying question.

User instructions override this router. If the user asks to only analyze, pause, skip edits, or use a specific workflow, follow that.

## Fast-Track

Use Fast-track for low-risk, local work:

- Answering questions or explaining code.
- Reading/searching files to gather context.
- Small UI/CSS/text/config changes.
- Single-file edits with obvious intent.
- Mechanical cleanup with no behavior change.

Fast-track flow:

```text
classify -> act directly -> run the most relevant verification -> report evidence
```

Fast-track may skip written specs, subagents, full TDD, and worktree setup. It must not skip honest completion verification.

## Full Workflow

Use the full workflow only when the request has real design or integration risk:

- New feature modules, new pages, or new app flows.
- Cross-file or cross-system changes involving APIs, data, auth, sync, deploy, cache, or storage.
- Core business logic, security, permissions, or data model changes.
- Ambiguous requirements where implementation choices materially affect the result.
- User explicitly asks for a plan, strict TDD, subagents, branch cleanup, or review.

Typical full flow:

```text
brainstorming -> writing-plans -> implementation/TDD as appropriate -> review if useful -> verification-before-completion
```

Use subagents only when the task is large enough to benefit from independent work or review.

## Skill Routing

| Situation | Use |
|---|---|
| Creative feature, UX, component, or behavior design | `brainstorming` |
| Multi-step implementation plan needed | `writing-plans` |
| Existing written plan to execute | `executing-plans` |
| 3+ independent tasks in the same session | `subagent-driven-development` |
| 2+ independent investigations or failures that can run in parallel | `dispatching-parallel-agents` |
| Code behavior change or bugfix where tests are practical | `test-driven-development` |
| Bug, failing test, build failure, or unknown root cause | `systematic-debugging` |
| User provides review feedback | `receiving-code-review` |
| Important implementation is done and needs independent scrutiny | `requesting-code-review` |
| Before claiming done/fixed/tests passing | `verification-before-completion` |
| PR/merge/cleanup decision after verified work | `finishing-a-development-branch` |

## Avoid Overuse

- Do not invoke `brainstorming` for tiny, obvious changes; write a short intent note instead.
- Do not invoke `writing-plans` unless there are multiple steps or meaningful sequencing risk.
- Do not invoke `subagent-driven-development` unless there is a written plan and several independent tasks.
- Do not invoke `systematic-debugging` unless something is actually broken or unexplained.
- Do not invoke `finishing-a-development-branch` unless the user is deciding how to integrate or clean up completed work.

## Windows / PowerShell Note

For ordinary file reads and searches, use direct commands such as `Get-Content -Encoding UTF8`, `Select-String`, `Get-ChildItem`, or `rg`. Only change console output encoding when there is an actual encoding problem.
