---
name: model-routing
description: Use after using-superpowers has classified a task and chosen the workflow, primary skill, support skills, or subagent plan. Maps each workflow family to a shared agent profile with explicit Codex and Antigravity model assignments.
---

# Model Routing

Use this skill after `using-superpowers` has made the workflow decision. `using-superpowers` owns intent classification, fast-track vs full workflow, primary/support skill selection, and next workflow node. `model-routing` owns model and agent-family assignment.

## Shared Profiles

Each installed profile lives under `references/agent-profiles/<agent>/`:

- `SKILL.md`: the agent family's responsibility and trigger shape.
- `MODEL.md`: the model assignment for Codex and Antigravity.

When routing, choose the profile first, then read and follow that profile's `MODEL.md`.

## Profile Map

| Workflow family | Profile |
| --- | --- |
| `using-superpowers`, `model-routing` | `workflow-router` |
| Tiny fast-track, simple Q&A, low-risk local edits | `general-light` |
| `test-driven-development`, `executing-plans`, `using-git-worktrees` | `code-worker` |
| `multi-agent-systems-architect`, `subagent-driven-development`, `dispatching-parallel-agents`, `oss-solution-scout` | `architect-deep` |
| `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review` | `debug-reviewer` |
| `design-taste-frontend`, `redesign-existing-projects`, `web-design-polish`, `visual-qa`, `image-to-code`, `ui-ux-pro-max` | `frontend-visual` |
| `brandkit`, image generation planning, frontend image prompts | `creative-visual` |
| Documents, spreadsheets, presentations, PDFs, templates | `doc-ops` |
| `prompt-engineer`, `writing-skills`, `writing-plans`, `brainstorming`, skill/plugin authoring | `prompt-planner` |
| `regulation-lookup-comparator`, compliance, customer-control comparison | `compliance-deep` |
| `email-intelligence-engineer`, MIME/thread extraction | `extractor` |
| Third-party skill, MCP, prompt-pack, extension intake, install trust | `skill-gatekeeper` |
| Security audit, vulnerability review, exploitability, auth/session review, appsec | `security-auditor` |
| `finishing-a-development-branch`, release wrap-up, PR handoff | `release-helper` |

## Security Routing Notes

- `skill-gatekeeper` is a mandatory pre-install and pre-enable gate for third-party skills, MCP servers, prompt packs, and agent bundles.
- `security-auditor` should receive security work only after scope, evidence standard, and safe-testing boundary have been framed by the chosen workflow node.

## Bootstrap Boundary

Skill activation and initial routing happen in the current root session model. A skill cannot by itself force the current session to switch models. Only a Codex custom agent can carry a different `model` setting.

Keep the root session's job small: classify the task, choose the profile, then delegate substantive execution to the mapped custom agent when model separation matters.
