---
name: ui-ux-pro-max
description: Use when a web or app design task needs a compact Design Strategy Brief before Open Design or frontend implementation, especially to choose industry fit, layout pattern, palette type, typography pairing, UX checklist, or anti-patterns without loading a full design rules database.
---

# UI UX Pro Max Strategy Wrapper

Use this as a low-context design strategy engine. Do not load the full UI UX Pro Max rules database into context by default.

## Role

Produce one short `Design Strategy Brief` before `web-design-polish` asks Open Design to create/update `DESIGN.md` or Taste Skill to implement UI polish.

## Strategy Modules

Consider only the modules relevant to the current task:

For product and site work routed through this strategy, UI UX Pro Max owns palette selection and emits the Palette Contract. Brandkit may originate a palette only when creating a new brand identity; implementation, image-generation, and QA skills consume or check the contract rather than selecting a competing palette.

- `industry-fit`: product/industry, audience expectations, trust signals, CTA type.
- `layout-pattern`: landing/page structure, section order, density, navigation pattern.
- `palette-type`: when color decisions are in scope, read [`references/strategy-modules.md`](references/strategy-modules.md) and produce one Palette Contract; preserve supplied brand colors and project tokens.
- `typography-pairing`: choose 1-2 font pairing directions, not the full font database.
- `ux-checklist`: only the necessary UX/accessibility/RWD checks for this task.
- `user-task-model`: identify the user's goal, top tasks, information structure, important actions, and relevant states.
- `human-factors`: for interaction, content-heavy, mobile, or redesign tasks, read [`references/human-factors.md`](references/human-factors.md) and apply only the relevant principles.
- `anti-patterns`: industry-specific things to avoid.

Do not use marketing-page layout guidance as a substitute for modeling product tasks, forms, dashboards, or multi-step flows. Preserve an existing product design system and information architecture unless the user asks to change them.

## Token Rules

- Never load all 67 styles, 161 rules, 161 palettes, or 57 font pairings.
- Select at most 1-2 styles, 1-2 palette directions, 1-2 typography directions, and the smallest useful checklist.
- Use only the relevant modules shipped in this skill's `references/` directory. If a requested detail is not included, state the limit and use project-provided design tokens and evidence; do not depend on an external checkout path.
- Keep the brief between 300 and 600 words. Shorter is better when the task is narrow.

## Design Strategy Brief Format

```markdown
## Design Strategy Brief

- Context: <product/site type, audience, brand tone>
- User goal and top tasks: <what people need to accomplish in this scope>
- Industry fit: <1-2 relevant expectations or trust cues>
- Information and interaction model: <content order, primary/secondary actions, important states>
- Layout pattern: <1 recommended pattern and why>
- Style direction: <1-2 selected style languages>
- Palette Contract: <direction and rationale; role map; brand/system constraints; relevant contrast, mode, or medium requirements>
- Typography pairing: <1-2 pairings or type moods>
- UX checks and success signal: <task-critical accessibility, responsive, and behavior checks; observable evidence when available>
- Anti-patterns: <what to avoid for this case>
```

## Handoff

Pass only the completed `Design Strategy Brief` to Open Design or `web-design-polish`. Do not paste the underlying rules database into the next stage.
Keep the brief compact: user goals and task structure should guide visual choices, while evidence and numerical thresholds should remain tied to their actual platform or product context.
