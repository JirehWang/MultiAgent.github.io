---
name: visual-qa
description: Use when verifying frontend UI, visual polish, responsive layout, browser interactions, screenshots, canvas/Three.js rendering, text overflow, overlap, or design regressions
---

# Visual QA

Verify what the user will actually see. This skill focuses on browser-based inspection after frontend changes or when visual correctness is uncertain.

## When To Use

Use for:

- Frontend UI changes, layout, styling, responsiveness, or animation.
- Canvas, SVG, image, video, chart, map, or Three.js rendering.
- Suspected text overflow, clipping, overlap, blank areas, or broken assets.
- Before claiming a visual change is complete.
- Comparing desktop and mobile behavior.

Skip for:

- Backend-only changes.
- Nonvisual copy changes where rendering risk is negligible.
- Cases where no runnable UI target exists and the user only requested code review.

## QA Workflow

1. Identify how to run or open the UI: existing dev server, static HTML, storybook, test page, or route.
2. Open the relevant target in the in-app browser when available.
3. Check at least one desktop and one mobile-sized viewport for responsive work.
4. Inspect the changed workflow, not just the first screen.
5. Look for concrete visual failures:
   - Text overflow, clipping, wrapping, or unreadable contrast.
   - UI elements overlapping or shifting unexpectedly.
   - Broken/missing images, icons, fonts, charts, or media.
   - Blank canvas/WebGL/Three.js scenes.
   - Hover/focus/disabled/loading states when relevant.
6. Capture evidence with screenshots or clear observations.
7. Fix issues and re-check the affected viewport/state.

## Output Format

Report only useful evidence:

```text
Checked:
- route/page, viewport, state

Findings:
- issue or "no visual issues found"

Fixes made:
- concise list, if any

Remaining risk:
- what was not checked and why
```

## Red Flags

- Claiming visual correctness from code inspection alone.
- Checking only desktop for responsive changes.
- Looking only at the landing state when the changed UI is in a modal/menu/form/error state.
- Ignoring browser console errors that affect rendering.
- Not re-checking after CSS/layout fixes.

## Handoff

If a visual issue is found, fix the smallest relevant cause and re-run Visual QA. If the issue requires product/design judgment, show the evidence and ask one focused question.
