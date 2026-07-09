# Design Agent Strengthening Plan

Date: 2026-06-18

Purpose:
- document the new design routing signals
- state the invocation rules clearly
- decide which additional design skills are worth adding later

## Current Routing Additions

The router now recognizes these design signals:

- `minimalist`
- `brutalist`
- `soft-premium`
- `brand-kit`
- `mobile-flow`
- `stitch`
- `full-output-risk`

## Invocation Rules

### Installed-skill-first rule

If a signal maps to a design direction but no dedicated overlay skill is installed yet, route to the nearest installed design specialist and add a handoff note explaining the missing specialist.

### Current signal-to-agent mapping

- `minimalist`
  - primary: `design-taste-frontend`
  - support: `ui-ux-pro-max`
  - use when the task wants restrained layout, editorial clarity, calmer motion, or lower visual density

- `brutalist`
  - primary: `design-taste-frontend`
  - support: `ui-ux-pro-max`
  - use when the task wants harder contrast, sharper geometry, experimental asymmetry, or Swiss / industrial language

- `soft-premium`
  - primary: `design-taste-frontend`
  - support: `ui-ux-pro-max`
  - use when the task wants expensive but calm UI, softer contrast, premium spacing, or luxury-product polish

- `brand-kit`
  - primary: `ui-ux-pro-max`
  - support: `writing-skills`
  - use when the output is strategy, palette, type direction, or brand-system notes rather than implemented code

- `mobile-flow`
  - primary: `ui-ux-pro-max`
  - support: `design-taste-frontend`
  - use when the task is mainly mobile structure, screen sequencing, or flow planning

- `stitch`
  - primary: `web-design-polish`
  - support: `ui-ux-pro-max`
  - use when the task needs `DESIGN.md`-style handoff or design-system export discipline

- `full-output-risk`
  - primary: `web-design-polish`
  - support: `writing-skills`
  - use when the design task is likely to stop at half-polished output, placeholders, or incomplete implementation notes

## Add-Skill Decisions

### Recommended to add if these requests recur

- `high-end-visual-design`
  - recommendation: yes
  - reason: it cleanly covers `soft-premium` without overloading `design-taste-frontend`

- `minimalist-ui`
  - recommendation: yes
  - reason: it gives a precise overlay for restrained editorial / product UI directions that currently rely on inferred dials only

### Add only if the style is genuinely recurring

- `industrial-brutalist-ui`
  - recommendation: conditional
  - reason: useful if brutalist / Swiss / industrial language shows up more than occasionally; otherwise fallback routing is enough

- `stitch-design-taste`
  - recommendation: conditional
  - reason: valuable if Stitch-specific export or DESIGN.md interoperability becomes a repeated requirement

### Add only if pure image deliverables are common

- `imagegen-frontend-web`
  - recommendation: conditional
  - reason: use when the deliverable is website comps only, not implementation

- `imagegen-frontend-mobile`
  - recommendation: conditional
  - reason: use when the deliverable is mobile screens or flows as images only

- `brandkit`
  - recommendation: conditional
  - reason: use when the deliverable is a brand board or identity set rather than code or a strategy memo

## Practical Threshold

Add a missing specialist when one of these is true:

- the same signal appears across 3 or more separate tasks
- fallback routing keeps producing too much manual handoff text
- the output artifact is consistently image-first rather than code-first
- the current primary agent is doing style inference that could be delegated to a cleaner overlay skill
