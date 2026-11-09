# Codex Global Application Architecture

This repository is the portable source package for the Codex workflow. A cloud checkout can use its repo-local instructions and skills directly; the workflow does not depend on host-global files.

Start with [AGENTS.md](../AGENTS.md) for the repository entry point and [project_contract.yml](../project_contract.yml) for workflow links and path policy. The task-level handoff starts at [using-superpowers](../.codex/skills/using-superpowers/SKILL.md), follows [workflow-router](../.codex/agents/workflow-router.toml), and uses [model-routing](../.codex/skills/model-routing/SKILL.md) to find the correct profile and skill.

## Layer Model

The stack is intentionally split into four layers:

1. `.codex/skills/`
   - workflow methods
   - domain-specialist instructions
   - top-level routing behavior such as `using-superpowers`
2. `.codex/agents/`
   - executable agent profiles used by Codex subagents
   - model tier and developer instruction boundary
3. `.codex/skills/model-routing/references/agent-profiles/`
   - shared profile references for `model-routing`
   - keeps routing semantics aligned between skills and agent definitions
4. `.codex/capabilities/`
   - repository-owned capability metadata and routing relationships

## Control Flow

The intended runtime flow is:

1. `using-superpowers`
   - classify the task
   - decide fast-track vs full workflow
   - identify artifact type and domain signals
   - evaluate enabled MCPs before broad exploration
2. `workflow-router`
   - preserve the routing decision
   - choose the right execution family
   - keep the root session lightweight
3. `model-routing`
   - map the workflow family to a shared agent profile
4. specialist or execution skill
   - perform the real work with the chosen agent
5. review or verification skill
   - only after an execution artifact exists

## Agent Ownership

- `workflow-router`
  - routing control plane
  - MCP selection policy entry point
- `architect-deep`
  - architecture, multi-module reasoning, workflow topology
  - prefers `codebase_memory` for system maps
- `context-scout`
  - repo onboarding and codebase orientation
  - prefers `codebase_memory`, then local search, then focused reads
- `security-auditor`
  - appsec, exploitability, auth/session, trust-boundary work
  - prefers `github`, `context7`, `markitdown`, and `codebase_memory` when they improve proof
- `skill-gatekeeper`
  - third-party skill and MCP trust review
  - treats MCP servers themselves as part of the governed extension surface
- `supervisor-agent`
  - QA and governance review for agent work
  - handles AWU supervision, plan-vs-actual checks, trajectory QA, and completion gating

## MCP Policy Model

Enabled MCPs are not treated as random optional tools. The router now evaluates the full enabled baseline first:

- `github`
- `context7`
- `markitdown`
- `codebase_memory`
- `notebooklm`
- `node_repl`

Then it chooses only the MCPs that materially improve correctness.

### Preferred MCP by task shape

- Remote repository state, PRs, issues, releases, workflow runs
  - `github`
- Latest framework, package, or API documentation
  - `context7`
- Document ingestion and conversion
  - `markitdown`
- Project maps, module boundaries, architecture memory
  - `codebase_memory`
- Multi-source study-pack style synthesis
  - `notebooklm`
- JavaScript execution or browser-connected support
  - `node_repl`

## Repo-Managed vs Host-Managed Components

This repository manages:

- skills
- agents
- model-routing profile references
- repo-local capability metadata and workflow references

## Optional Integrations

This repository does not bundle MCP servers or require them to use the repo-local workflow. Use an integration when it is available and improves the task; otherwise continue with the repository content.

Optional host-provided integrations can include:

- GitHub for remote repository state, pull requests, issues, releases, and workflow runs
- Context7 for current framework and package documentation
- Codebase Memory for project maps and architecture memory
- MarkItDown and NotebookLM for document-oriented work
- Node REPL for JavaScript or browser-connected support

Local runtime binaries, credentials, and MCP server configuration remain host-managed. No repository-owned workflow step depends on a particular installation path.
## Use From A Cloud Checkout

1. Start with the repository [AGENTS.md](../AGENTS.md) and [project contract](../project_contract.yml).
2. Load `.codex/skills/using-superpowers/` and classify the task with its local routing rules.
3. Follow `.codex/agents/workflow-router.toml` and `.codex/skills/model-routing/` to select the semantic owner and skill.
4. Read any skill overlay relative to the file that declares its path.
5. Complete the selected work with the applicable review and verification guidance.

Optional MCPs are host integrations. Their absence must leave the repo-local workflow usable through repository search and direct source inspection.

## Source Of Truth

The repository's `.codex/` tree is the source of truth for distributable instructions, skills, routing rules, agent definitions, and capability metadata. A host's global Codex or Gemini directory may contain private or machine-specific resources; do not use it as a runtime dependency. Keep the handoff links relative so the same workflow works from a local checkout or cloud workspace.
