---
name: git-version-management
description: Inspect Git repository revision state and explain what changed locally, what the tracked remote branch currently shows, which commits differ, and what is safe to push next. Use when Codex needs to perform version-management triage, compare local versus remote Git state, summarize staged or unstaged changes, identify unpushed commits, or recommend open source tooling for GitHub-centered revision workflows.
---

# Git Version Management

Inspect revision state before suggesting actions. Separate working tree changes from committed history and separate local-only history from remote-only history.

Prefer the bundled script for repeatable reporting:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/git-version-report.ps1 -RepoPath <repo-path>
```

Add `-Fetch` only when network refresh is needed and permitted.

## Workflow

1. Identify the repository root.
2. Read current branch, HEAD, and upstream tracking branch.
3. Report uncommitted changes from `git status --short --branch`.
4. Report staged and unstaged diff stats separately.
5. Compare `HEAD` with the upstream branch to calculate ahead/behind counts.
6. List commits that are ready to push and commits that exist only on the upstream branch.
7. End with a single push recommendation in plain language.

## Output Rules

- Always separate these buckets:
  - uncommitted changes
  - staged changes
  - local commits not on upstream
  - upstream commits not in local HEAD
- State whether the remote comparison is based on fresh fetch data or cached refs.
- If no upstream exists, say so directly and avoid push claims.
- If branch histories diverged, recommend sync before push.
- If the working tree is dirty, do not blur that with unpushed commits.

## Command Set

Use the script first. Fall back to raw commands only when needed:

- `git status --short --branch`
- `git diff --stat`
- `git diff --cached --stat`
- `git rev-parse --abbrev-ref --symbolic-full-name @{upstream}`
- `git rev-list --left-right --count <upstream>...HEAD`
- `git log --oneline <upstream>..HEAD`
- `git log --oneline HEAD..<upstream>`

Use `gh` only when the user asks for GitHub-specific context such as pull requests, checks, or repository metadata.

## Tool Recommendation Rule

When the user asks which open source tools to adopt, read [references/tool-mapping.md](references/tool-mapping.md) and recommend the smallest stack that fits:

- Default: `Lazygit + gh`
- GUI-heavy preference: `GitHub Desktop + gh`
- Heavy commit-stack work: add `git-branchless`
- Self-hosting need: add `Gitea` or `Forgejo`

## Example Requests

- "Check what changed in this repo and tell me what can be pushed."
- "Compare my local branch with origin/main and summarize the differences."
- "Recommend an open source stack so an agent can manage GitHub version state more easily."
- "Tell me whether these edits are only local changes or already committed and ready to push."
