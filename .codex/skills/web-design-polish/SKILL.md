---
name: web-design-polish
description: Default orchestrator for website UI work, including UI polishing, visual review, redesign, DESIGN.md generation, reference-site analysis, screenshot-to-UI, responsive polish, and frontend visual improvements. Route explicit Hallmark requests through its opt-in anti-slop stage.
---

# Web Design Polish

A low-context orchestrator for website design polish. It coordinates UI UX Pro Max, Open Design, and Taste Skill through short intermediate artifacts instead of loading all three rule sets into context.

## Core Principle

Do not keep Open Design, Taste Skill, and UI UX Pro Max fully resident in context. Make them collaborate through compact handoffs:

```text
UI UX Pro Max -> Design Strategy Brief -> optional Hallmark -> Open Design -> DESIGN.md -> Taste Skill -> UI implementation/polish -> Visual QA
```

## Optional Hallmark Stage

Invoke `hallmark` only when the user explicitly names Hallmark or requests one of its verbs:

- `hallmark` for a greenfield page needing structural variety.
- `hallmark audit` for an anti-slop punch list without edits.
- `hallmark redesign` for a visual/interaction redesign within existing implementation boundaries.
- `hallmark study` for design-DNA extraction from a screenshot or public URL.

Hallmark does not replace the strategy, implementation, or verification stages. For ordinary UI requests, skip it.

Precedence and persistence:

- Existing `DESIGN.md` and project tokens win over Hallmark themes and rotation.
- Do not create a second token system in an established product.
- `.hallmark/preflight.json` and `.hallmark/log.json` are opt-in project memory; create them only after explicit user approval.
- Hallmark self-critique is advisory. Browser and responsive completion evidence belongs to `visual-qa`.

## Stage 1: UI UX Pro Max Strategy Brief

First produce a `Design Strategy Brief` of 300-600 words. Use `ui-ux-pro-max` only as a strategy engine and only for task-relevant slices:

- `industry-fit`: product/industry, audience expectations, trust cues, CTA type.
- `layout-pattern`: page structure and section rhythm.
- `palette-type`: 1-2 palette directions.
- `typography-pairing`: 1-2 font pairing directions.
- `ux-checklist`: only necessary UX/RWD/accessibility checks.
- `anti-patterns`: what this site must avoid.

Token control: never load the full 67 styles, 161 rules, 161 palettes, or 57 font pairings. If raw data is needed, search the local UI UX Pro Max data files and extract only the top 1-2 matches.

## Stage 2: Open Design DESIGN.md

Pass only the `Design Strategy Brief` plus the user's actual inputs to Open Design: URL, localhost, screenshot, reference site, source code, or existing `DESIGN.md`.

Use Open Design MCP (`open-design`) when available to analyze artifacts, read or create design systems, and generate/update task-specific `DESIGN.md`. Keep only the relevant `DESIGN.md` in context. If useful, ask Open Design to generate a prototype/artifact; do not replace the brief with a huge rules dump.

## Stage 3: Taste Skill Implementation

Use Taste Skill only when implementation or polish begins:

- `design-taste-frontend`: default anti-generic frontend quality layer.
- `redesign-existing-projects`: existing site/codebase redesigns.
- `image-to-code`: screenshot/reference-image-first work.

Taste Skill should work from `DESIGN.md`, not from all upstream rules. Apply concrete improvements to visual hierarchy, typography, spacing, CTA, interaction states, RWD, and anti-template UI.

## DESIGN.md Contract

For broad polish or cross-file work, create/update:

```markdown
# DESIGN.md

## Design Summary
## Brand Voice
## Color Tokens
## Typography
## Spacing and Layout
## Components and CTA
## Responsive Rules
## Accessibility Rules
## Implementation Notes
```

Make it executable: token names, CSS variables, sizes, component states, responsive rules, and dos/don'ts.

## Design Rules

- Do not copy a reference site 1:1.
- Preserve the user's brand content and information architecture.
- Borrow style language, not proprietary assets.
- Prefer fewer, sharper design moves over decoration.
- With source code, land the changes directly in HTML/CSS/React/Next/Vue components.
- Verify desktop and mobile visual behavior before claiming completion.

## Output

For review-only tasks: return the brief, DESIGN.md recommendations, and highest-impact fixes.

For implementation tasks: report files changed, design rules applied, and verification evidence.
