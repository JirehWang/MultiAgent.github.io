# Repo Skill Delta

Compared against:
- Repo: `JirehWang/MultiAgent.github.io`
- Repo skills path: `skills/`
- Comparison date: `2026-06-18`

This folder contains the skill directories that differ from the repo and are ready to be copied into the repo manually.

## What To Copy Into The Repo

Copy these directories into `skills/` in the repo:

- `using-superpowers`
- `context-scout`
- `writing-skills`
- `requesting-code-review`
- `receiving-code-review`
- `email-intelligence-engineer`
- `prompt-engineer`
- `multi-agent-systems-architect`
- `high-end-visual-design`
- `minimalist-ui`
- `industrial-brutalist-ui`
- `stitch-design-taste`
- `imagegen-frontend-web`
- `imagegen-frontend-mobile`
- `brandkit`
- `full-output-enforcement`

## Difference Summary

### Changed in this machine vs repo

These already exist in the repo, but the global versions on this machine are intentionally different:

- `using-superpowers`
  - remains the top-level router
  - now reads routing spec files from the same folder
  - keeps high-level routing in `SKILL.md`
  - moves concrete fast-track specialist mapping into `agent-routing-rules.yaml`
  - now recognizes the design signals `minimalist`, `brutalist`, `soft-premium`, `brand-kit`, `mobile-flow`, `stitch`, and `full-output-risk`
  - now includes a design strengthening plan and explicit overlay rules

- `context-scout`
  - expanded to absorb `codebase-onboarding-engineer`
  - adds evidence-first onboarding behavior
  - adds explicit start-here guidance and partial-coverage disclosure

- `writing-skills`
  - expanded to cover general technical documentation, not only skill authoring
  - adds audience clarity, prerequisites, scannable structure, and realistic example expectations

- `requesting-code-review`
  - adds stronger reviewer guidance around correctness, security, testing, and priority buckets
  - asks reviewers to separate confirmed bugs from assumptions and open questions

- `receiving-code-review`
  - adds an explicit classify -> validate -> respond flow
  - makes the difference between defects, regressions, style suggestions, and unclear intent more explicit

### New on this machine vs repo

These do not currently exist in the repo `skills/` directory and should be added:

- `email-intelligence-engineer`
- `prompt-engineer`
- `multi-agent-systems-architect`
- `high-end-visual-design`
- `minimalist-ui`
- `industrial-brutalist-ui`
- `stitch-design-taste`
- `imagegen-frontend-web`
- `imagegen-frontend-mobile`
- `brandkit`
- `full-output-enforcement`

## Repo-Only Note

The repo currently has `task-decomposition`, but this machine's global skills do not include that directory. It is not part of this payload because the task here was to export local differences into the sandbox.

## Design Skill Expansion Notes

The payload now includes a fuller frontend/design stack from `Leonxlnx/taste-skill`:

- style overlays:
  - `high-end-visual-design`
  - `minimalist-ui`
  - `industrial-brutalist-ui`
  - `stitch-design-taste`

- image-only design skills:
  - `imagegen-frontend-web`
  - `imagegen-frontend-mobile`
  - `brandkit`

- cross-cutting output overlay:
  - `full-output-enforcement`

The router-side invocation logic for these is documented inside:
- `skills/using-superpowers/agent-routing-rules.yaml`
- `skills/using-superpowers/AGENT_ROUTER_PROMPT.md`
- `skills/using-superpowers/DESIGN_AGENT_STRENGTHENING_PLAN.md`

## Source Of Truth For This Payload

These directories were copied from:
- `C:\Users\105221\.codex\skills`

They were staged into:
- `D:\py\repo-skill-delta-2026-06-18`
