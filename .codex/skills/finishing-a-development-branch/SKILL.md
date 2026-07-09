---
name: finishing-a-development-branch
description: Use when implementation is complete, verification has passed, and the branch needs integration, PR, cleanup, or handoff decisions.
---

# Finishing A Development Branch

Use after implementation and verification, before merge or handoff.

## Workflow

1. Confirm verification evidence is fresh.
2. Inspect `git status` and the final diff.
3. Separate intended changes from unrelated work.
4. Summarize what changed and why.
5. Identify remaining risks or test gaps.
6. Prepare the requested finish action: commit, push, PR, merge, cleanup, or handoff.
7. Do not delete or revert user changes unless explicitly asked.

## Rules

- Do not claim ready without verification evidence.
- Do not include unrelated files in commits.
- Do not hide uncommitted or untracked work.
- Prefer non-interactive git commands.
- If the working tree is dirty from other work, call that out clearly.

## Caveman Compression

For finish notes, use caveman style: branch, status, diff scope, verification, risks, action. Do not compress final release notes or PR text if detail is needed.
