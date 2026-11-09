---
name: model-routing
description: Use after using-superpowers has classified a task and chosen the workflow, primary skill, support skills, or subagent plan. Maps each workflow family to a semantic agent profile; the canonical router assigns the runtime model and reasoning effort.
---

# Model Routing

Use this skill after `using-superpowers` has made the workflow decision. `using-superpowers`
owns intent classification, primary/support selection, and the next workflow node.
`model-routing` resolves the semantic role and applies the runtime policy from
`agent-routing-rules.yaml`.

## Semantic role and runtime split

Treat semantic profile and execution runtime as separate decisions.

1. Select the profile that best fits the artifact and domain contract.
2. Preserve its instructions, constraints, and verification expectations.
3. For a clear low-risk route, keep execution with the current model and apply the
   direct evidence checks in the canonical YAML.
4. For explicit delegation or review, high-risk or ambiguous work, material boundaries,
   or a stronger domain contract, apply `sol-luna-orchestration` and its packet. Astra
   controls the handoff; the selected executor works; the acceptance process (GPT-6.1-Sol) or the qualified
   domain reviewer independently accepts when required.

Luna is eligible when scope and output are explicit, ambiguity is low, the work is
repeatable or batch-like, and aggregate volume creates a material cost, latency, or
throughput benefit. Use GPT-6.1-Sol for bounded complex coding or agentic execution only
after architecture and acceptance standards are settled, and only when GPT-6.1-Sol will
not independently accept that same packet. Otherwise retain the selected semantic
executor. Delegated workers do not recursively reroute.

Use the canonical `model_effort_policy` in `using-superpowers/agent-routing-rules.yaml`.
Astra is the control/planning/evaluation role (medium default), Luna is the repeatable
work executor (medium default), GPT-6.1-Sol may execute bounded complex engineering
(medium default), Independent acceptance uses GPT-6.1-Sol at high
default effort. All support low, medium, high, and max. Explicit supported user effort choices
win within safety and domain contracts; packet effort is never silently lowered.

## Shared Profiles

Each installed profile lives under `references/agent-profiles/<agent>/`:

- `SKILL.md`: the agent family's responsibility and trigger shape.
- `MODEL.md`: a reminder that profiles do not pin a runtime model or reasoning effort.

Choose the semantic profile first. Resolve model and reasoning effort only from
`using-superpowers/agent-routing-rules.yaml#model_effort_policy`, the selected route, and
any explicit user model or effort request. Direct work inherits the current model;
delegated work follows the inherited `dispatch_contract`. Agent TOML and profile files
must not assign or override a runtime model or reasoning effort.

## Profile Map

| Workflow family | Profile |
| --- | --- |
| `using-superpowers`, `model-routing` | `workflow-router` |
| Tiny fast-track, simple Q&A, low-risk local edits | `general-light` |
| `test-driven-development`, `executing-plans`, `using-git-worktrees` | `code-worker` |
| `multi-agent-systems-architect`, `subagent-driven-development`, `dispatching-parallel-agents`, `oss-solution-scout` | `architect-deep` |
| `api-contract-governance` | `api-contract-guardian` |
| `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review` | `debug-reviewer` |
| `design-taste-frontend`, `redesign-existing-projects`, `web-design-polish`, `visual-qa`, `image-to-code`, `ui-ux-pro-max`, `minimalist-ui`, `industrial-brutalist-ui`, `high-end-visual-design`, `stitch-design-taste`, `hallmark`, GSAP skills | `frontend-visual` |
| `brandkit`, `imagegen-frontend-web`, `imagegen-frontend-mobile`, image generation planning, frontend image prompts | `creative-visual` |
| Documents, spreadsheets, presentations, PDFs, templates | `doc-ops` |
| `prompt-engineer`, `writing-skills`, `writing-plans`, `brainstorming`, skill/plugin authoring | `prompt-planner` |
| `regulation-lookup-comparator`, compliance, customer-control comparison | `compliance-deep` |
| `email-intelligence-engineer`, MIME/thread extraction | `extractor` |
| `supervisor-agent`, AWU governance, plan-vs-actual review, trajectory QA, completion gating | `supervisor-agent` |
| Personal-global tool, CLI, SDK/library, skill, plugin, agent bundle, MCP server, app connector, or extension fit/adoption decision (`personal-tool-evaluator`) | `general-light` |
| Pure third-party skill, MCP, prompt-pack, extension trust/security intake | `skill-gatekeeper` |
| Security audit, vulnerability review, exploitability, auth/session review, appsec | `security-auditor` |
| `finishing-a-development-branch`, release wrap-up, PR handoff | `release-helper` |

## Security Routing Notes

- `personal-tool-evaluator` is the sole primary for a personal-global adoption decision and maps to `general-light`. For a third-party proposal, add `skill-gatekeeper` as mandatory trust support; use `skill-gatekeeper` as primary only for a pure trust or security report.
- `skill-gatekeeper` is a mandatory pre-install and pre-enable gate for third-party skills, MCP servers, prompt packs, and agent bundles.
- `security-auditor` should receive security work only after scope, evidence standard, and safe-testing boundary have been framed by the chosen workflow node.

## Boundaries

Skill activation and initial routing happen in the current session model. Do not change
stored model or effort settings, agent assignments, plugins, MCP servers, or disabled
skills as part of routing. A user preference for no subagents keeps execution local while
retaining risk gates and disclosing any unavailable independent check.
