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
