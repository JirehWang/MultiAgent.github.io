---
name: using-git-worktrees
description: Use when feature work needs isolation from the current checkout, when the user asks for a worktree, or before executing a substantial implementation plan
---

# Using Git Worktrees

Use an isolated workspace when it protects the user's current checkout from risky or multi-step work. Keep this lightweight for small tasks.

## When To Use

Use a worktree for:

- Substantial feature work.
- Multi-step implementation plans.
- Risky refactors or experiments.
- Work that should become a separate branch or PR.
- User explicitly asks for isolation.

Skip worktree setup for:

- Read-only analysis.
- Small single-file edits.
- Quick fixes the user expects in the current checkout.
- Repositories already managed by the harness or an existing isolated workspace.

## Detect First

Before creating anything, check whether you are already isolated:

```bash
git rev-parse --git-dir
git rev-parse --git-common-dir
git branch --show-current
git rev-parse --show-superproject-working-tree
```

If `git-dir` differs from `git-common-dir` and this is not a submodule, you are already in a linked worktree. Use it.

## Ask Before Creating

If no existing preference is known, ask before creating a new worktree:

> Would you like me to set up an isolated worktree? It protects your current branch from these changes.

If the user declines, work in place.

## Create

Prefer native worktree/session tools when available. Use manual `git worktree add` only as fallback.

Directory preference:

1. User-specified location.
2. Existing `.worktrees/` in the repo.
3. Existing `worktrees/` in the repo.
4. Existing global path for this project.
5. Default `.worktrees/` at repo root.

For project-local directories, verify the directory is ignored before creating the worktree. If it is not ignored, ask before editing `.gitignore`.

## Setup And Baseline

Do not automatically install dependencies or run the full test suite just because a worktree was created.

After entering the worktree:

- Inspect project files to identify the package manager and test commands.
- Run dependency install only when dependencies are missing or the user asked for setup.
- Run a baseline check when it is cheap and relevant, or before substantial implementation.
- If baseline checks fail, report the evidence and ask whether to investigate or proceed.

## Report

Keep the report short:

```text
Workspace: <path>
Branch: <branch>
Baseline: <command run or skipped with reason>
```

## Red Flags

- Creating nested worktrees.
- Editing `.gitignore` without need or consent.
- Running network-heavy installs automatically.
- Treating worktree setup as mandatory for tiny changes.
- Claiming the baseline is clean without running the relevant command.
