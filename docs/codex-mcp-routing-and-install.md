# Codex MCP Routing And Install Guide

This guide explains how the repo-managed MCPs are expected to land on another Windows machine and how the workflow decides when to call them.

## Repo-Managed MCPs

These MCPs have repo-owned snippets or install scripts here:

- `github`
- `context7`
- `codebase_memory`

## Host-Managed MCPs

These are part of the expected environment but are not fully provisioned by this repo:

- `markitdown`
- `notebooklm`
- `node_repl`

## Files

- `codex/mcp/github-oauth-local.toml`
- `codex/mcp/context7.toml`
- `codex/mcp/codebase-memory.toml`
- `install-github-mcp.ps1`
- `install-context7-mcp.ps1`
- `install-codebase-memory.ps1`
- `install-codex-mcp-suite.ps1`

## GitHub MCP

This repo uses the official local GitHub MCP server with browser-based OAuth.

Runtime shape:

- command: local `github-mcp-server.exe`
- args: `stdio`
- auth: first-use browser login

Why this choice:

- avoids storing a PAT in repo-managed config
- keeps parity with the current maintainer machine
- works as a reusable global MCP for repo, PR, issue, and workflow operations

## Context7 MCP

This repo uses:

- command: local `npx.cmd`
- args: `-y @upstash/context7-mcp`

Why this choice:

- no custom local binary packaging required
- good fit for latest package and framework docs
- easy to land on Windows machines with Node installed

## MCP Routing Rules

The router and specialist layers now follow this policy:

- always evaluate all enabled MCPs first
- choose only the ones that improve evidence quality
- do not call an MCP just because it is available

### Routing examples

- "Check PR comments and remote workflow failures"
  - prefer `github`
- "Confirm the current Next.js API behavior"
  - prefer `context7`
- "Read this PDF requirements pack"
  - prefer `markitdown`
- "Map module boundaries in this repo"
  - prefer `codebase_memory`
- "Build a study pack from several uploaded docs"
  - prefer `notebooklm`
- "Inspect JS behavior or browser-connected automation"
  - prefer `node_repl`

## New Machine Checklist

1. Install Codex routing package from this repo.
2. Install GitHub MCP with `install-github-mcp.ps1`.
3. Install Context7 MCP with `install-context7-mcp.ps1`.
4. Optionally install Codebase Memory MCP with `install-codebase-memory.ps1`.
5. Verify `config.toml` contains the managed blocks.
6. Restart Codex.
7. Trigger a test prompt that should route through each MCP.
