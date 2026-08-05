---
name: using-superpowers
description: Use when starting a substantive task or choosing between a lightweight, standard, or governed workflow. Route to the smallest safe workflow before loading specialist skills.
---

# Superpowers Router

Choose the lowest-cost tier that protects correctness. Escalate only from observed risk; do not infer complexity from task count or from an optional architecture.

Apply the anti-overengineering ladder in `ANTI_OVERENGINEERING_POLICY.md` before adding dependencies, abstractions, agents, or workflow stages.

## Fast-Track

Use for questions, context gathering, mechanical cleanup, and small obvious edits with a narrow verification surface.

- Stay single-agent.
- Load at most one narrow specialist unless the user explicitly requests another.
- Skip brainstorming and planning when the requested direction is already clear.
- Run focused verification for edits.

## Standard

Use for normal features and bug fixes when intent is clear but implementation or verification needs care.

- Stay single-agent by default.
- Use the narrow domain specialist plus the minimum process skill, such as TDD or systematic debugging.
- Write a compact plan only when sequencing or cross-file coordination is material.
- Prefer one integrated review or verification pass over per-step reviewers.

## Governed

Use only when two or more material complexity signals apply:

- multiple subsystems or responsibility boundaries
- meaningful dependencies between stages
- unresolved design choice or high uncertainty
- broad verification across code, tests, UI, security, or data flow
- context volume too large for one focused execution path
- high consequence of failure

Decompose first. Use subagents only when context isolation improves quality and file overlap is low. For large work, dispatch by stage and keep about 3-4 agents active including the manager.

## Routing

1. Identify the artifact and domain.
2. Choose Fast-Track, Standard, or Governed.
3. Check the capability registry when a narrow specialist may exist.
4. Choose exactly one primary owner and zero to two support skills.
5. Load only the next skill needed; do not preload a future workflow chain.
6. Set verification proportional to risk.

Before assigning substantive execution to Codex or a subagent, check whether the work matches the Antigravity Delegation Policy. Route self-contained, repetitive, low-risk exploration, extraction, testing, or clearly specified edits to Antigravity CLI when this reduces context or token cost. Keep planning, architecture, high-stakes judgment, destructive actions, ambiguous requirements, final review, and completion verification in Codex. Delegation does not remove the Codex verification gate.

Whenever Antigravity is selected, its mandatory preflight is: run `agy auth login`, run `agy models` and confirm the selected model is available, then dispatch with `agy ... -p "<task prompt>"`. The prompt must be passed with `-p`/`--print`, never as a positional argument. A failed login, unavailable model, or help-text response is a dispatch failure and must be corrected before work proceeds.

Common routes:

- unclear creative direction -> `brainstorming`
- implementation plan genuinely needed -> `writing-plans`
- approved plan -> `executing-plans`
- practical behavior change -> `test-driven-development`
- unexplained failure -> `systematic-debugging`
- completion claim -> `verification-before-completion`
- complex isolatable tracks -> `subagent-driven-development`
- personal-global tool adoption -> `personal-tool-evaluator` (add `skill-gatekeeper` as mandatory support for third-party proposals)
- third-party extension intake -> `skill-gatekeeper`
- security or trust-boundary audit -> `security-auditor`
- governed project task walls or state gates -> `project-delivery-governor`

Use the required routing references only for Governed work or real agent-selection ambiguity:

- `agent-routing-rules.yaml`
- `AGENT_ROUTER_PROMPT.md`
- `COMPRESSION_POLICY_ROUTING.md`
- `MCP_ROUTING_POLICY.md`
- `SPECIALIZED_CAPABILITY_DISCOVERY.md`

Use `LANGGRAPH_AGENT_ROUTING.md` only when workflow topology is unclear.

## Delegation Budget

- Do not trigger subagents from task count alone.
- Do not delegate work that is cheaper to complete in the current context.
- Delegated implementers execute their brief; they do not restart brainstorming, planning, or delegation.
- Use one combined reviewer for standard-risk delegated work.
- Reserve multiple review perspectives for high-risk boundaries.
- Allow one automatic re-review per finding set; then the manager adjudicates or asks the user.

## Rules

- User instructions override skill defaults.
- Prefer reuse, native features, and local edits over new structure.
- Do not reduce safety, validation, accessibility, or essential verification to save tokens.
- Automatically route a request to evaluate, add, install, enable, promote, or connect a tool, CLI, SDK/library, skill, plugin, agent bundle, MCP server, app connector, or extension in the user's personal global environment to `personal-tool-evaluator` before adoption work; no explicit skill invocation is required.
- Keep `personal-tool-evaluator` as the sole primary for personal-global fit. For a third-party proposal, add `skill-gatekeeper` as mandatory trust support; keep `skill-gatekeeper` primary for a pure trust or security report with no personal-global fit decision.
- Only `YES` may proceed to a separately requested global action. `TRY LOCALLY FIRST` limits work to project/local/sandbox scope, and `NO` stops global adoption unless the user explicitly overrides it or provides materially new evidence.
- Do not use the personal-global route for ordinary usage help, documentation, debugging, or project-local dependency installation unless the user asks to promote it globally.
- Questions and tiny edits do not become Governed work merely because skills exist.
- Announce a skill only when it causes a material action or pause.
- Keep routing notes short; keep final user explanations complete where tradeoffs matter.
