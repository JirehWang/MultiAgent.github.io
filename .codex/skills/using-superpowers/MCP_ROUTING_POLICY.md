---
title: MCP Routing Policy
date: 2026-06-30
---

# MCP Routing Policy

Use this file when routing or executing work in an environment with multiple enabled MCP servers.

## Enabled MCP Baseline

Evaluate the currently enabled global MCPs:

- `github`
- `context7`
- `markitdown`
- `codebase_memory`
- `notebooklm`
- `node_repl`

Do not force every MCP into every task. Evaluate all of them, then pick only the ones that materially improve correctness, speed, or evidence quality.

## Priority By Task Shape

### Repo, PR, issue, release, workflow state

Prefer:

1. `github`
2. local repo files and git state
3. `codebase_memory` if architecture context is also needed

Use `github` when the task depends on remote repository state, pull requests, issues, workflow runs, discussions, releases, or code search outside the checked-out tree.

### Package docs, framework APIs, latest library behavior

Prefer:

1. `context7`
2. official primary docs if still needed
3. open web only when the official path is insufficient

Use `context7` when correctness depends on current package or framework documentation, version-sensitive APIs, migration guidance, or example usage.

### Document ingestion, conversion, routine extraction

Prefer:

1. `markitdown`
2. local file reads or document-specific runtime tools
3. OCR or image fallback only when necessary

Use `markitdown` first for `.pdf`, Office docs, slides, and mixed-format text extraction when the task is primarily about reading the document contents.

### Codebase map, architecture, cross-module discovery

Prefer:

1. `codebase_memory`
2. local search such as `rg`
3. focused source reads

Use `codebase_memory` first when the task asks for project maps, workflow nodes, module boundaries, cross-repository understanding, or architecture memory.

### Research pack, long-form synthesis, multi-source recall

Prefer:

1. `notebooklm`
2. `markitdown` or local reads to prepare source material
3. manual synthesis when the source set is small

Use `notebooklm` only when the task benefits from curated source packs, repeated retrieval over the same document set, or study-style synthesis. Do not use it as first-pass proof for exact code or security findings.

### JavaScript execution or browser-connected automation

Prefer:

1. `node_repl`
2. other local tools only if JS-side execution is unnecessary

Use `node_repl` for JavaScript execution, browser-oriented automation support, JS package inspection, or persistent Node state. Do not route plain repository reading through it.

## Agent-Specific MCP Rules

- `context-scout`
  - prefer `codebase_memory` for large-repo mapping
  - prefer `github` when onboarding depends on remote PR, issue, or workflow context
  - prefer `markitdown` when onboarding starts from attached docs or exported reports

- `architect-deep`
  - prefer `codebase_memory` for architecture and dependency maps
  - add `github` when cross-repo or remote governance context matters
  - add `context7` when design decisions depend on current platform docs

- `security-auditor`
  - prefer `github` for security alerts, PR context, workflow context, and remote evidence
  - prefer `context7` for current framework or dependency security-related documentation
  - prefer `markitdown` when the audit evidence starts from reports, PDFs, or policies

- `skill-gatekeeper`
  - evaluate every enabled MCP as part of extension-risk governance
  - prefer `github` for upstream repo, issues, releases, and maintenance signals
  - prefer `context7` only when a server or package depends on current library docs
  - prefer `markitdown` when reviewing bundled docs, manifests, or policy files in document formats

## Hard Rules

- MCP availability alone is not a reason to invoke a tool.
- For evidence-heavy tasks, cite which MCP provided which class of evidence.
- If an MCP result conflicts with inspected local source or an official primary source, resolve the conflict explicitly.
- For security and governance work, distinguish between:
  - local checked-out evidence
  - MCP-provided remote evidence
  - inferred conclusions
- When a task is MCP-heavy, use compression that preserves evidence readability.
