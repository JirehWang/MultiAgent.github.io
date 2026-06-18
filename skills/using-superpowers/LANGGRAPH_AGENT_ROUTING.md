# LangGraph-Style Agent Routing

Date: 2026-06-18

Purpose:
- classify current global agents
- define which agents are allowed at each workflow node
- give a dispatcher a graph-shaped routing spec instead of a flat list of skills

Note:
- this file is the reference routing model for `using-superpowers`
- `using-superpowers` remains the top-level router and should read this file only when workflow shape or node boundaries are unclear

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
  - frontend specialists when UI/visual signals are present

### Framing / Planning
- purpose: prepare the work contract before execution
- allowed agents:
  - `brainstorming`
  - `writing-plans`
  - `multi-agent-systems-architect`
  - `writing-skills`

### Decomposition / Dispatch
- purpose: split work when single-agent execution is not enough
- allowed agents:
  - `dispatching-parallel-agents`
  - `subagent-driven-development`
  - `multi-agent-systems-architect`

### Execution
- purpose: perform the main work
- allowed agents:
  - chosen domain specialist
  - `executing-plans`
  - `test-driven-development`
  - `systematic-debugging`
  - `writing-skills`
  - frontend specialists

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
