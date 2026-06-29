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
- System-level impact analysis.
- Impact analysis.
- Dead-code or dependency risk.
- Understanding how existing code pieces fit together.

Routing agent:

```text
workflow-router
```

`workflow-router` should route architecture and codebase graph discovery tasks to `architect-deep` and mark `codebase-memory-mcp` as the preferred discovery tool.

## Codebase Memory And Codegraph Cooperation

Use Codebase Memory and codegraph as paired architecture tools, not substitutes.

Codebase Memory is the system-level memory layer:

- project maps
- module and workflow boundaries
- cross-repository relationships
- integration planning
- long-term architecture context

Codegraph is the implementation-level graph layer:

- call paths
- symbol relationships
- class and function dependencies
- importer/importee chains
- concrete change impact

Recommended flow:

1. Start with Codebase Memory to form the architecture hypothesis.
2. Use codegraph to trace the concrete implementation path.
3. Read the referenced source files to verify behavior.
4. If graph outputs disagree, trust source inspection and tests as final evidence.

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
