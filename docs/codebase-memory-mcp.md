# Codebase Memory MCP Landing Guide

This repo treats `codebase-memory-mcp` as the designated architecture discovery tool for Codex architecture agents.

## Agent Assignment

Primary agent:

```text
architect-deep
```

Use this agent when the task involves:

- Architecture understanding.
- Cross-module wiring.
- Workflow and adapter boundaries.
- Call path tracing.
- Impact analysis.
- Dead-code or dependency risk.
- Understanding how existing code pieces fit together.

Routing agent:

```text
workflow-router
```

`workflow-router` should route architecture and codebase graph discovery tasks to `architect-deep` and mark `codebase-memory-mcp` as the preferred discovery tool.

## MCP Server Block

The managed MCP block lives in:

```text
codex/mcp/codebase-memory.toml
```

Default local installation:

```text
D:\py\tools\codebase-memory-mcp\bin\codebase-memory-mcp.exe
```

Default graph cache:

```text
D:\py\tools\codebase-memory-mcp\cache
```

Default UI:

```text
http://127.0.0.1:9749
```

## Install Or Update

Install routing agents only:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Target codex
```

Install or update the Codebase Memory MCP config block:

```powershell
powershell -ExecutionPolicy Bypass -File .\install-codebase-memory.ps1
```

Test without touching real global Codex config:

```powershell
powershell -ExecutionPolicy Bypass -File .\install-codebase-memory.ps1 -CodexHome D:\tmp\.codex
```

## Current Integrated Tool Project

The current indexed project is:

```text
D-py-integrated_tool
```

Source root:

```text
D:/py/integrated_tool
```

Reindex command:

```cmd
D:\py\tools\codebase-memory-mcp\index_integrated_tool.cmd
```

## Usage Rule For Architect Agent

For architecture questions, use the graph first:

1. `list_projects`
2. `get_architecture`
3. `search_graph`
4. `trace_path`
5. `query_graph`
6. `search_code`
7. `detect_changes`

Then inspect files only where the graph points.

Keep bulky runtime data out of architecture discovery. For `integrated_tool`, `.cbmignore` excludes staging/cache/output artifacts.
