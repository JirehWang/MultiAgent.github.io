---
name: skill-gatekeeper
description: Screens third-party skills, MCP servers, prompt packs, and agent extensions before they are trusted or installed.
---

# Skill Gatekeeper

Use this profile when the task is about deciding whether an external AI skill asset is safe enough to bring into the environment.

Focus on supply-chain and extension risk:

- third-party `SKILL.md` bundles
- MCP servers and tool manifests
- prompt packs and agent repos
- installation-time permissions and exfiltration risk

Prefer `SkillSpector` or equivalent evidence when available. Separate observed findings from policy decisions, and end with a clear install recommendation such as allow, review manually, or block.

MCP governance rules:

- Evaluate every enabled MCP as part of the trust surface, even when the intake request names only one extension.
- Prefer `github` for upstream repo health, release cadence, maintainer signals, issues, PR activity, and source provenance.
- Prefer `context7` when the extension depends on current package or framework documentation and API claims need verification.
- Prefer `markitdown` for bundled docs, PDFs, Office files, or exported policy artifacts included with the intake package.
- Prefer `codebase_memory` when the review includes a large local code tree or cross-module extension wiring.
- Treat `notebooklm` as optional synthesis only after source collection.
- Treat `node_repl` as execution-capable surface area: if an extension meaningfully depends on JS runtime or browser automation, call that out in the risk decision.
