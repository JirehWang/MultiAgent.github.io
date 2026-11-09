# Design Agent Strengthening Plan

Date: 2026-10-08

Status: Implemented. The active route definitions are in `agent-routing-rules.yaml`; this note summarizes the current design routing and follow-up criteria.

Purpose:
- document the design routing signals and current skill assignments
- state the invocation rules clearly
- prevent style overlays from overriding task, accessibility, or platform needs

## Current Routing Additions

The router recognizes these design signals and artifacts:

- `minimalist`
- `brutalist`
- `soft-premium`
- `brand-kit`
- `mobile-flow`
- `stitch`
- `full-output-risk`
- marketing-page direction
- product UI direction
- website and mobile image-only concepts
- screenshot-to-implementation

## Invocation Rules

### Scope and precedence rule

Start product work with the user's goal, top tasks, information structure, interaction model, and applicable accessibility/platform guidance. Style overlays are optional visual layers. The marketing-page skill applies to landing pages and portfolios, not as the default strategy for forms, dashboards, or multi-step flows.

### Current signal-to-agent mapping

- `minimalist`
  - primary: `ui-ux-pro-max`
  - overlay: `minimalist-ui`
  - use when a restrained editorial direction is explicitly requested; keep product and accessibility requirements authoritative

- `brutalist`
  - primary: `ui-ux-pro-max`
  - overlay: `industrial-brutalist-ui`
  - use the visual treatment only where it preserves readability and task clarity

- `soft-premium`
  - primary: `ui-ux-pro-max`
  - overlay: `high-end-visual-design`
  - keep motion purposeful and honor reduced-motion preferences

- `brand-kit`
  - primary: `brandkit`
  - add `ui-ux-pro-max` when product UI tasks or interaction strategy are included

- `mobile-flow`
  - primary: `ui-ux-pro-max`
  - use when the task is mainly mobile structure, screen sequencing, or flow planning
  - use `imagegen-frontend-mobile` when the requested deliverable is image-only screen concepts

- `stitch`
  - primary: `stitch-design-taste`
  - support: `ui-ux-pro-max`
  - use when the task needs `DESIGN.md`-style handoff or design-system export discipline

- `marketing-page`
  - primary: `design-taste-frontend`
  - support: `ui-ux-pro-max`
  - use only for landing pages and portfolios

- `website image concept` / `mobile screen concept`
  - primary: `imagegen-frontend-web` / `imagegen-frontend-mobile`
  - use for image-only visual artifacts, not implemented UI

- `full-output-risk`
  - primary: `web-design-polish`
  - support: `writing-skills`
  - use when the design task is likely to stop at half-polished output, placeholders, or incomplete implementation notes

## Existing Skills and Future Additions

The global skill collection already includes `high-end-visual-design`, `minimalist-ui`, `industrial-brutalist-ui`, `stitch-design-taste`, `imagegen-frontend-web`, `imagegen-frontend-mobile`, and `brandkit`. Route to them directly for matching deliverables; do not describe them as missing or propose installing duplicates.

## Practical Threshold

Consider a new specialist only when one of these is true:

- the same signal appears across 3 or more separate tasks
- fallback routing keeps producing too much manual handoff text
- the output artifact is consistently image-first rather than code-first
- the current primary agent is doing style inference that could be delegated to a cleaner overlay skill
