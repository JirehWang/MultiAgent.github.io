# Codex Global Application Architecture

This repo packages a full global Codex workflow stack so another machine can install the same routing behavior, specialist agents, and MCP-backed tool preferences.

## Layer Model

The stack is intentionally split into four layers:

1. `skills/`
   - workflow methods
   - domain-specialist instructions
   - top-level routing behavior such as `using-superpowers`
2. `codex/agents/`
   - executable agent profiles used by Codex subagents
   - model tier and developer instruction boundary
3. `agent-profiles/`
   - shared profile references for `model-routing`
   - keeps routing semantics aligned between skills and agent definitions
4. `codex/mcp/`
   - MCP server config snippets used to attach external tools into Codex

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

This repo manages:

- skills
- agents
- model-routing profile references
- repo-authored MCP snippets
- install scripts for repo-managed MCPs

This repo does not fully own every runtime binary on every machine.

Examples:

- `github`
  - repo-managed install path and config snippet
- `context7`
  - repo-managed config snippet, host uses local Node and `npx`
- `codebase_memory`
  - repo-managed config snippet and install script
- `markitdown`
  - expected as a host-installed MCP binary
- `notebooklm`
  - expected as a host-managed local server
- `node_repl`
  - bundled by Codex runtime

## Install Order On A New Machine

1. Install routing package:
   - `install.ps1 -Target codex`
2. Install GitHub MCP:
   - `install-github-mcp.ps1`
3. Install Context7 MCP:
   - `install-context7-mcp.ps1`
4. Install Codebase Memory MCP if needed:
   - `install-codebase-memory.ps1`
5. Restart Codex and open a new conversation

## Source Of Truth

When the repo differs from local global Codex state, the intended source of truth is the local installed global package on the maintainer machine, then that state is synced back into this repository for redistribution.
