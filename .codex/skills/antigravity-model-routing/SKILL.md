---
name: antigravity-model-routing
description: Chooses the smallest capable official Google Antigravity model for a task. Use before substantive work, delegation, subagents, workflow execution, code review, debugging, architecture, frontend visual work, routine extraction, or when deciding whether to use Gemini 3.5 Flash, Gemini 3 Flash, Gemini 3.1 Pro, Claude Sonnet 4.6, Claude Opus 4.6, GPT-OSS-120b, or Nano Banana 2.
---

# Antigravity Model Routing

Choose the smallest capable official Antigravity model before doing substantive work.

## Shared Profiles

Installed agent profiles live under `resources/agent-profiles/<agent>/`.

Each profile contains:

- `SKILL.md`: the agent family's responsibility and trigger shape.
- `MODEL.md`: the model assignment for both Codex and Antigravity.

Choose the profile first, then read that profile's `MODEL.md` when the model choice is not obvious.

## Official Model Set

Reasoning models available in Antigravity official docs:

- `Gemini 3.5 Flash`
- `Gemini 3.1 Pro (high)`
- `Gemini 3.1 Pro (low)`
- `Gemini 3 Flash`
- `Claude Sonnet 4.6 (thinking)`
- `Claude Opus 4.6 (thinking)`
- `GPT-OSS-120b`

Additional non-customizable model:

- `Nano Banana 2` for generative image tasks through Antigravity's image tool.

## Core Policy

Default to `Gemini 3.5 Flash` for normal daily work. Route down for simple work and up for rare complex work.

Antigravity subagents use the same model as their parent. If subagents are needed, choose the parent model based on the highest-risk subtask, or split work into separate conversations with different selected models.

## Routing Table

| Task | Model |
| --- | --- |
| Workflow routing, task classification, normal planning | `Gemini 3.5 Flash` |
| Tiny fast-track tasks, simple Q&A, formatting, trivial edits | `Gemini 3 Flash` |
| Low-sensitivity, repeatable, cost-first tasks | `GPT-OSS-120b` |
| Routine docs, extraction, summaries, table cleanup | `Gemini 3 Flash`; use `Gemini 3.5 Flash` when nuance matters |
| General coding, small/medium bugfixes, plan execution | `Gemini 3.5 Flash` |
| Multi-file coding, repo onboarding, moderate uncertainty | `Gemini 3.5 Flash`; escalate to `Gemini 3.1 Pro (low)` |
| Hard implementation, high uncertainty, broad verification surface | `Gemini 3.1 Pro (high)` |
| Debugging, regression hunting, verification, code review | `Gemini 3.1 Pro (high)` or `Claude Sonnet 4.6 (thinking)` |
| Architecture, multi-agent workflows, role boundaries, long-term tradeoffs | `Claude Opus 4.6 (thinking)`; fallback `Gemini 3.1 Pro (high)` |
| Frontend implementation, UI polish, visual QA, image-to-code | `Gemini 3.5 Flash`; escalate to `Gemini 3.1 Pro (high)` for complex product/visual judgment |
| Generative UI mockups, page images, diagrams, visual assets | Use Antigravity image tool with `Nano Banana 2` |
| Compliance, security, customer-control comparison, high-stakes review | `Claude Opus 4.6 (thinking)` or `Gemini 3.1 Pro (high)` |

## Execution Rule

Before substantive execution, state the chosen model in one short line when the choice is not obvious.

If the current Antigravity model differs from the recommended model:

- Continue without interruption for tiny or low-risk work.
- Ask the user to switch the model selector before high-risk, high-cost, or long-running work.
- For subagent work, choose the parent conversation model before invoking subagents.

## Codex Delegation Policy

### Mandatory Antigravity preflight

Every Antigravity CLI invocation must pass these gates in order:

```cmd
agy auth login
agy models
agy --mode accept-edits -p "<task prompt>"
```

The first command establishes the authenticated session. The second confirms that the selected model is available. The third must use `-p` (or the equivalent `--print <prompt>` form); do not pass the task prompt as a positional argument. If login or model discovery fails, do not dispatch the task. If the CLI returns help text instead of running the prompt, correct the argument form before retrying.

Use Antigravity CLI as a low-cost execution delegate when the task is self-contained, low-risk, and has an observable output. Prefer delegation for:

- repository exploration, file/function searches, and concise technical summaries
- routine documentation, extraction, table cleanup, formatting, and translation
- small isolated edits, repetitive multi-file changes, and test scaffolding
- running tests, collecting failures, and performing an initial traceback analysis
- implementing a clear, already-approved brief without architectural decisions

Keep the task in Codex when it involves requirements interpretation, architecture, security, compliance, legal/financial/medical judgment, destructive operations, ambiguous product decisions, final review, or completion claims. Antigravity output is never evidence of completion by itself; Codex must inspect the diff/output and run proportional verification.

When delegating, provide the absolute workspace path, an explicit read-only or edit boundary, the exact deliverable, and a required test/report step. Complete the mandatory preflight first. Use `agy -p` for bounded one-shot work, `--mode plan` for analysis, and `--mode accept-edits` only when the edit scope is explicit. Do not use `--dangerously-skip-permissions` by default.
