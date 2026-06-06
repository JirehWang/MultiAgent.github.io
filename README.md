# MultiAgent Global Skills

Shared global agent skills for Codex, Antigravity, and other agents that read `SKILL.md`-style skill folders.

## Skills

The published skills live in `skills/`:

- `using-superpowers`
- `brainstorming`
- `writing-plans`
- `executing-plans`
- `subagent-driven-development`
- `dispatching-parallel-agents`
- `test-driven-development`
- `systematic-debugging`
- `receiving-code-review`
- `requesting-code-review`
- `verification-before-completion`
- `finishing-a-development-branch`
- `web-design-polish`

## Install

Clone this repository, then run one of the install scripts from the repo root.

Install for Codex:

```powershell
.\install-codex.ps1
```

Install for Antigravity:

```powershell
.\install-antigravity.ps1
```

Both scripts copy `skills/*` into the agent's global skill directory. Existing skills with the same names are overwritten.

## Web Design Polish

`web-design-polish` is a dedicated website UI/design skill. It can analyze URLs, screenshots, source code, reference sites, and `DESIGN.md`, then provide or apply visual design improvements.

If you also use Open Design, configure its MCP server separately for your own machine. The skill can still work without MCP by following its manual workflow.
