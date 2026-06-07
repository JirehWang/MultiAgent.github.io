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

- `industry-fit`: product/industry, audience expectations, trust signals, CTA type.
- `layout-pattern`: landing/page structure, section order, density, navigation pattern.
- `palette-type`: choose 1-2 palette directions, not the full palette database.
- `typography-pairing`: choose 1-2 font pairing directions, not the full font database.
- `ux-checklist`: only the necessary UX/accessibility/RWD checks for this task.
- `anti-patterns`: industry-specific things to avoid.

## Token Rules

- Never load all 67 styles, 161 rules, 161 palettes, or 57 font pairings.
- Select at most 1-2 styles, 1-2 palette directions, 1-2 typography directions, and the smallest useful checklist.
- If source data is needed, search the local UI UX Pro Max checkout instead of reading whole files: `D:\program\ui-ux-pro-max-skill\src\ui-ux-pro-max\data`.
- Keep the brief between 300 and 600 words. Shorter is better when the task is narrow.

## Design Strategy Brief Format

```markdown
## Design Strategy Brief

- Context: <product/site type, audience, brand tone>
- Industry fit: <1-2 relevant expectations or trust cues>
- Layout pattern: <1 recommended pattern and why>
- Style direction: <1-2 selected style languages>
- Palette type: <1-2 palette directions with rationale>
- Typography pairing: <1-2 pairings or type moods>
- UX checklist: <only task-critical checks>
- Anti-patterns: <what to avoid for this case>
```

## Handoff

Pass only the completed `Design Strategy Brief` to Open Design or `web-design-polish`. Do not paste the underlying rules database into the next stage.