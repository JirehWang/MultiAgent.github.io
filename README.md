# MultiAgent.github.io

This repository contains a repo-local Codex workflow package. Its routing rules, agents, capabilities, and skills live under `.codex/`, so the workflow can be read and used from a cloud checkout without relying on a maintainer's global Codex directory.

## Start here

1. Read [AGENTS.md](AGENTS.md) for the repository workflow and path rules.
2. Read [project_contract.yml](project_contract.yml) for the workflow map and project boundaries.
3. Follow [using-superpowers](.codex/skills/using-superpowers/SKILL.md) and its [routing rules](.codex/skills/using-superpowers/agent-routing-rules.yaml).
4. Use [workflow-router](.codex/agents/workflow-router.toml) and [model-routing](.codex/skills/model-routing/SKILL.md) to select the specialist profile and skill.
5. Finish with the relevant review and [verification guidance](.codex/skills/verification-before-completion/SKILL.md).

The runtime flow is `using-superpowers` → `workflow-router` → `model-routing` → a domain or execution skill → review and verification. The [architecture map](docs/codex-global-application-architecture.md) describes the handoffs.

## Portability

- Resolve links relative to this repository or to the file that contains them.
- Use `.codex/` as the source for repository-owned instructions and skills.
- Do not require a global Codex profile, a specific username, drive, checkout path, local binary, or cache.
- Optional MCP tools may be used when available. Continue with repository search and source inspection when they are absent.
- Keep credentials, session history, logs, caches, and generated company artifacts out of Git.

For contribution and project boundaries, see [project_contract.yml](project_contract.yml). For the repository's global capability map, see [.codex/global-agent-map/](.codex/global-agent-map/).
