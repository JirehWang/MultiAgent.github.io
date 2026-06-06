---
name: web-design-polish
description: Use when the user asks for website UI polishing, visual design review, redesign, web aesthetics, design-system extraction, DESIGN.md generation, responsive/layout/color/typography/CTA improvements, or asks to use Open Design with a URL, screenshot, source code, or reference site. This is an Antigravity global agent skill for web visual design work.
---

# Web Design Polish

Use this skill as the dedicated website visual-design agent skill. Its job is to turn a website, screenshot, source tree, or reference site into a clear design system and then improve the UI with that system.

## When to Use

Use for:

- Website UI polish, visual redesign, landing page beautification, component styling, CSS cleanup.
- Extracting or creating `DESIGN.md` from a URL, screenshot, source code, brand material, or reference site.
- Auditing layout, visual hierarchy, color, typography, spacing, CTA clarity, RWD, accessibility, and brand consistency.
- Applying `DESIGN.md` to real frontend source code.

Do not use for non-web backend work unless it affects user-facing UI.

## Routing

1. Start through `using-superpowers` routing.
2. Because this is creative UI/UX work, use `brainstorming` before major redesign decisions.
3. Fast-track is allowed for tiny, local CSS/UI fixes: color, spacing, alignment, copy, one component.
4. Use full Superpowers mode for cross-file component work, new pages, design-system migration, or risky frontend refactors.
5. Before editing real code, inspect the existing framework, CSS architecture, component boundaries, and current visual language.
6. Before claiming completion, use `verification-before-completion` and include visual/browser evidence when possible.

## Open Design Integration

Prefer Open Design when available.

- MCP server name: `open-design`
- Preferred MCP command shape: `od mcp --daemon-url http://127.0.0.1:7456`
- If using a source checkout instead of packaged `od`, point the MCP command to that machine's built `apps/daemon/dist/cli.js`.
- If Open Design daemon is running, use it to list skills/design systems, read or generate artifacts, and consult `DESIGN.md` systems.
- If the MCP server is unavailable, continue manually using the workflow below and note the limitation.

## Input Handling

Accept any combination of:

- Website URL or localhost URL.
- Screenshot or visual reference image.
- Source files, repo, CSS, components, HTML, Tailwind config, design tokens.
- Reference websites or desired brands.
- Existing `DESIGN.md`.

When inputs are incomplete, make reasonable assumptions for low-risk polish. Ask only when brand direction, audience, or edit scope is genuinely ambiguous.

## Analysis Checklist

Evaluate:

- Visual hierarchy: first viewport, heading scale, content rhythm, contrast, scan path.
- Layout and spacing: grid, alignment, density, whitespace, section rhythm, card usage.
- Color system: palette, contrast, semantic roles, accent discipline, CTA visibility.
- Typography: font pairing, scale, weight, line-height, readable measure, language support.
- Components: buttons, cards, forms, nav, tables, badges, empty/loading/error states.
- CTA and conversion: primary action clarity, secondary action restraint, repeated CTA placement.
- RWD: mobile/tablet/desktop behavior, wrapping, overflow, tap targets, stable constraints.
- Brand consistency: tone, imagery, icon style, motion, product/domain fit.
- Accessibility: contrast, focus states, keyboard states, semantic structure.

## DESIGN.md Contract

Create or update `DESIGN.md` when the task involves design-system extraction, reference-site translation, broad UI polish, or cross-file UI work.

Recommended sections:

``markdown
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
``

Make `DESIGN.md` actionable: include concrete tokens, sizes, CSS variable names, component rules, and dos/don'ts. Avoid vague adjectives without implementation rules.

## Implementation Workflow

1. Capture current state: inspect files and, when possible, browser screenshots at desktop and mobile widths.
2. Extract the current visual system and identify mismatches against the target direction.
3. Draft or update `DESIGN.md`.
4. Apply UI changes in the smallest sensible surface: CSS variables, design tokens, shared components, then page-specific styling.
5. Preserve behavior and data flow; do not redesign by deleting functionality.
6. Verify with build/test/lint as appropriate and visual inspection in browser.
7. Report what changed, which `DESIGN.md` rules were applied, and any residual design tradeoffs.

## Output Style

For review-only tasks, return:

- Overall design diagnosis.
- Top 5-10 highest-impact fixes.
- Concrete token/component recommendations.
- `DESIGN.md` draft or patch when requested.

For implementation tasks, return:

- Files changed.
- Visual/design-system changes made.
- Verification performed, including browser/screenshot checks when available.
