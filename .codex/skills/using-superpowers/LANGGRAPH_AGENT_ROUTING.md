# LangGraph-Style Agent Routing

Date: 2026-10-08

Purpose:
- classify current global agents
- define which agents are allowed at each workflow node
- give a dispatcher a graph-shaped routing spec instead of a flat list of skills

Note:
- this file is the reference routing model for `using-superpowers`
- `using-superpowers` remains the top-level router and should read this file only when workflow shape or node boundaries are unclear

## Runtime Boundary

- Clear, bounded, low-risk work may execute in the current model after source or input
  inspection and relevant behavior/output verification.
- Explicit delegation or review, high-risk or ambiguous work, material cross-boundary
  changes, and stronger domain contracts use the delegated route defined in
  `agent-routing-rules.yaml`; `sol-luna-orchestration` is that route's overlay.
- Explicit user preferences for a model, delegation, review, or no subagents take
  precedence within safety and domain limits. No-subagent high-risk work retains its
  applicable checks and records the unavailable independent review.
- A delegated worker executes its bounded packet and does not recursively reroute or
  create unsolicited subdelegation.

## Global Agent Categories

### Router / Control Plane
- `using-superpowers`
- `dispatching-parallel-agents`
- `subagent-driven-development`
- `using-git-worktrees`
- `finishing-a-development-branch`

### Domain Specialists
- `email-intelligence-engineer`
- `prompt-engineer`
- `multi-agent-systems-architect`
- `context-scout`
- `oss-solution-scout`
- `skill-gatekeeper`
- `security-auditor`

### Planning / Execution
- `brainstorming`
- `writing-plans`
- `executing-plans`
- `test-driven-development`
- `systematic-debugging`

### Review / Quality Gates
- `requesting-code-review`
- `receiving-code-review`
- `verification-before-completion`

### Writing / Documentation
- `writing-skills`

### Frontend / Design Specialists
- `design-taste-frontend`
- `redesign-existing-projects`
- `web-design-polish`
- `visual-qa`
- `image-to-code`
- `ui-ux-pro-max`
- `minimalist-ui`
- `industrial-brutalist-ui`
- `high-end-visual-design`
- `stitch-design-taste`
- `hallmark`
- GSAP skills

### Creative Visual Assets
- `brandkit`
- `imagegen-frontend-web`
- `imagegen-frontend-mobile`

## Workflow Graph Nodes

### Intent Router
- purpose: classify the request before meaningful work
- allowed agent: `using-superpowers`

### Domain Classification
- purpose: decide whether the task belongs to a specialist domain
- allowed agents:
  - `email-intelligence-engineer`
  - `prompt-engineer`
  - `multi-agent-systems-architect`
  - `context-scout`
  - `oss-solution-scout`
  - `skill-gatekeeper`
  - `security-auditor`
  - frontend specialists when UI/visual signals are present

### Framing / Planning
- purpose: prepare the work contract before execution
- allowed agents:
  - `brainstorming`
  - `writing-plans`
  - `multi-agent-systems-architect`
  - `writing-skills`
  - `security-auditor` when scope, evidence standard, and safe-testing limits must be fixed before audit work

### Decomposition / Dispatch
- purpose: split work when single-agent execution is not enough
- allowed agents:
  - `dispatching-parallel-agents`
  - `subagent-driven-development`
  - `multi-agent-systems-architect`

### SDD Child-Dispatch Boundary
- `subagent-driven-development` is routed to `decomposition_dispatch` only.
- `subagent-driven-development` is decomposition/child-dispatch control only; never a production runtime or final acceptance decision owner.
- Every child clones the parent `dispatch_contract` exactly for `execution_required`, `runtime_overlay`, and `global_contract`.
- A child cannot change `validation_tier`, `required_gates`, `required_artifacts`, or `acceptance_owner`; no local downgrade is allowed. Missing or invalid parent or child `dispatch_contract` is `contract-invalid` and must be escalated.
- Implementers and reviewers return evidence or advisory recommendations only; the acceptance process alone owns final `pass`, `retry`, and `rollback`.
- Parent/child packet context uses the existing task-packet schema and handoff; do not create a child schema or runtime lane.

### Execution
- purpose: perform the main work
- allowed agents:
  - chosen domain specialist
  - `executing-plans`
  - `test-driven-development`
  - `systematic-debugging`
  - `writing-skills`
  - frontend specialists

## Security Constraints

- Third-party skill, MCP, prompt-pack, and agent-bundle installs must be gated by `skill-gatekeeper` before execution or enablement.
- Security audits should not enter execution until scope, evidence standard, and safe-testing boundaries are framed.
- If `trust-boundary` appears with `security-audit`, `appsec`, `auth-review`, `session-review`, or `exploitability`, prefer `security-auditor` over `multi-agent-systems-architect` unless the artifact is explicitly a workflow design.

### Review
- purpose: inspect implementation or process review feedback
- allowed agents:
  - `requesting-code-review`
  - `receiving-code-review`

### Verification
- purpose: prove that work is actually done
- allowed agents:
  - `verification-before-completion`
  - `visual-qa`

### Finish / Integration
- purpose: merge, handoff, or clean up
- allowed agents:
  - `finishing-a-development-branch`
  - `using-git-worktrees`
  - `writing-skills`
