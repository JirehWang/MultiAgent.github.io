# Git Version Management Architecture

## Role Split

- `git`:
  Source of truth for working tree changes, commit graph, and branch relationships.

- `pre-push hook`:
  Auto-runs a version summary before every `git push`.

- `git-version-management` skill:
  Converts raw Git state into a readable decision summary.

- `gh`:
  Optional GitHub layer for pull requests, checks, and repository metadata.

- `PromptHub`:
  Management layer for the skill, prompts, and future agent assets.

## Current Stack

Execution layer:
- Git
- Global `pre-push` hook at [pre-push](D:\py\git-hooks\pre-push)
- Global skill at [SKILL.md](C:\Users\105221\.codex\skills\git-version-management\SKILL.md)

Management layer:
- PromptHub as the recommended future workspace for skill lifecycle management

## Why PromptHub Was Added

- It helps manage the skill as a reusable asset.
- It improves long-term maintenance and cross-tool distribution.
- It does not replace the Git checks already wired into push.

## Recommended Future Direction

1. Keep Git hooks responsible for automatic trigger timing.
2. Keep the skill responsible for analysis logic and human-readable output.
3. Add PromptHub for asset lifecycle management.
4. Add `gh` only when GitHub PR or checks context is needed.
