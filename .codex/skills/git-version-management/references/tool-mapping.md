# Open Source Tool Mapping

Use this reference when the user asks which Git or GitHub tools pair well with the skill.

## Recommended Stack

### Primary pairing

- `Lazygit`: Best local Git TUI for staging, commit review, stash, branch switching, and quick diff inspection.
- `GitHub CLI (gh)`: Best GitHub-facing CLI for PR state, checks, repo metadata, and remote collaboration workflows.

Use both when the user wants a lightweight agent that can summarize status but still hand off cleanly to strong human-facing tools.

### Management layer

- `PromptHub`: Best fit for managing Prompt, Skill, Agent, and rules assets as a reusable local-first workspace with version history and multi-tool distribution.

Use it to manage the `git-version-management` skill itself, not to replace Git status or push safety checks.

### GUI option

- `GitHub Desktop`: Good fit when the user prefers visual history and drag-select staging over terminal workflows.

Use it as the human UI layer, not as the agent's automation core.

### Advanced history option

- `git-branchless`: Good fit when the user often rebases, restacks branches, or wants better commit-stack visibility.

### Self-hosted platform option

- `Gitea` or `Forgejo`: Good fit when the user wants to host repositories outside GitHub while keeping Git-native workflows.

## Selection Rules

- Recommend `Lazygit + gh` by default.
- Recommend `PromptHub` as the management layer when the user wants to maintain or distribute the skill across tools.
- Prefer `GitHub Desktop + gh` when the user dislikes terminal-first Git workflows.
- Add `git-branchless` only when branch-stack maintenance is a recurring pain point.
- Add `Gitea` or `Forgejo` only when self-hosting is a real requirement.

## Agent Integration Notes

- Use `git` as the source of truth for working tree state, staged changes, commit graph, and ahead/behind counts.
- Use `gh` only for GitHub-specific state such as PRs, checks, or repository metadata.
- Use `PromptHub` as the asset registry for the skill, prompt variants, and future rule packs.
- Treat network-refresh steps such as `git fetch` or `gh` API calls as optional actions that may require approval.
- Always separate:
  - uncommitted local changes
  - committed but unpushed local commits
  - remote-only commits
  - recommended next action
