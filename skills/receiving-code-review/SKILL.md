---
name: receiving-code-review
description: Use after receiving code review feedback, especially when feedback is ambiguous or may require careful technical verification before implementation.
---

# Receiving Code Review

Use this skill when a reviewer, user, or CI comment asks for changes.

## Workflow

1. Read every review item before editing.
2. Classify each item: bug, requirement gap, test gap, style, question, or optional suggestion.
3. Verify technical claims against the code.
4. Ask for clarification only when intent cannot be inferred safely.
5. Apply fixes for confirmed issues.
6. Do not implement optional suggestions that conflict with requirements.
7. Re-run relevant verification.
8. Report what was changed, declined, or still open.

## Rules

- Do not blindly accept review comments.
- Do not dismiss comments without checking evidence.
- Keep fixes scoped to the reviewed issue.
- Preserve user changes unrelated to the review.
- If a comment is wrong, explain with code evidence.

## Caveman Compression

For review triage, use caveman style: item, type, evidence, action, verification. Do not compress code snippets or final explanation that needs nuance.
