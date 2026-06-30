---
name: using-superpowers
description: Use when starting a substantive task, choosing which workflow skills apply, or deciding whether a request needs lightweight handling or a fuller execution workflow.
---

# Superpowers Router

Classify the task before doing meaningful work. Choose the smallest workflow that still protects correctness.

This skill remains the top-level router. It does not replace specialist skills or workflow skills; it decides when to use them.

## Caveman Compression

For routing notes, use caveman style: short labels, exact decision, exact next step. Keep reasons only when they affect routing. Do not use caveman for final user-facing explanations.

## Required Reads For Routing

When the task requires agent selection, workflow-node selection, or primary/support-agent decisions, read these files in the same folder before routing:

- `agent-routing-rules.yaml`
- `AGENT_ROUTER_PROMPT.md`
- `COMPRESSION_POLICY_ROUTING.md`

Use `LANGGRAPH_AGENT_ROUTING.md` in the same folder as the reference model when the workflow shape, node boundaries, or dispatch logic are unclear.

## Fast-Track

Use fast-track for low-risk local work:
- questions
- context gathering
- small obvious edits
- mechanical cleanup

If fast-track is enough, do not force the task through the full routing graph.

Fast-track specialist routing is defined in `agent-routing-rules.yaml`.

## Full Workflow

Use a fuller workflow when design, integration, or verification risk is real.

## Routing Order

When full routing is needed, follow this order:
1. identify the artifact being produced
2. identify domain signals
3. choose exactly one primary agent
4. choose zero to two support agents
5. choose one compression policy for the routed agent
6. choose the next workflow node
7. only then decide whether extra workflow skills are needed

Specialist-first rule:
- if a narrow domain specialist clearly fits, choose it before a generic workflow skill
- workflow skills shape the work; they do not replace the primary domain owner unless the artifact itself is a plan, review, or verification output

## Complexity Signals

Estimate complexity from these signals:
- multiple subsystems or filesets
- dependency depth between steps
- unclear approach or high uncertainty
- merge/conflict risk between tracks
- large context volume
- broad verification surface

If most signals are low, stay single-agent.
If complexity is moderate or high, decompose first.

Treat complexity as moderate/high when 2 or more of these are true:
- 2+ subsystems or responsibility boundaries are involved
- there are meaningful step dependencies
- investigation or design choice is required before coding
- verification spans more than one surface such as code, tests, UI, or data flow
- the agent would likely overload itself by keeping all context at once

Treat context isolation as useful when 1 or more of these are true:
- a subtask can be completed from a narrow file or subsystem slice
- different tracks have low file overlap
- a track benefits from deep focus in one domain such as frontend, backend, or tests
- results can be returned in a fixed format and recomposed cleanly

For large tasks, dispatch by stage, not all at once.
Keep simultaneously active agents within about 3-4, including the manager when relevant.

## Skill Routing

- creative design -> `brainstorming`
- multi-step plan needed -> `writing-plans`
- existing plan to execute -> `executing-plans`
- 2+ independent investigations -> `dispatching-parallel-agents`
- moderate/high complexity with isolatable implementation tracks -> `subagent-driven-development`
- practical behavior change -> `test-driven-development`
- broken or unexplained behavior -> `systematic-debugging`
- done but needs verification -> `verification-before-completion`
- third-party skill, MCP, prompt-pack, or agent intake review -> `skill-gatekeeper` before any install, enable, or promotion step
- codebase, service, or workflow security audit -> `security-auditor` after scope, evidence standard, and safe-testing boundary are framed

## Domain Routing

When domain signals are clear, route to the narrow specialist first:

- raw email, thread extraction, MIME, quoted replies, mailbox exports -> `email-intelligence-engineer`
- prompt design, prompt testing, prompt evaluation, schema hardening -> `prompt-engineer`
- multi-agent topology, handoffs, retries, role boundaries, failure recovery -> `multi-agent-systems-architect`
- unfamiliar repo, unclear entry points, codebase onboarding -> `context-scout`
- third-party skill, MCP server, prompt pack, extension permissions, install trust -> `skill-gatekeeper`
- exploitability review, appsec, vuln triage, auth/session weakness, trust-boundary abuse -> `security-auditor`

Do not skip these specialists just because a generic workflow skill also seems applicable.

## Rules

- Do not trigger subagents from task count alone.
- Use task count only as a weak hint.
- Prefer decomposition before delegation.
- Avoid heavy workflows for tiny obvious changes.
- Choose one primary agent only.
- Support agents advise; they do not create equal ownership.
- If routing is ambiguous, use the artifact-first rule from `agent-routing-rules.yaml`.
- Decide `headroom` and `caveman` after agent selection, not before it.
- Treat `headroom` as context control and `caveman` as output-style control.
- Do not install, enable, or promote a third-party skill, MCP server, prompt pack, or agent bundle until `skill-gatekeeper` has produced an explicit allow, manual-review, or block decision.
- Do not start a security audit in execution mode until the scope, evidence standard, and safe-testing boundary are stated.
