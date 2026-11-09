---
name: visual-qa
description: Use when verifying frontend UI, visual polish, responsive layout, browser interactions, screenshots, canvas/Three.js rendering, text overflow, overlap, or design regressions
---

# Visual QA

Verify what the user will actually see. This skill focuses on browser-based inspection after frontend changes or when visual correctness is uncertain.

For task clarity, grouping, choice complexity, content scanning, and touch targets, consult the relevant principles in [`../ui-ux-pro-max/references/human-factors.md`](../ui-ux-pro-max/references/human-factors.md). Apply them to the tested task and platform rather than as universal layout rules.

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
   - When color is in scope, compare rendered colors with the Palette Contract or authoritative project tokens and check relevant text/control contrast, focus and status states, and whether meaning is conveyed by more than color alone. Verify a contrast ratio from source values when available; otherwise report the visual evidence without claiming a measured ratio. QA reports palette issues but does not choose a replacement palette.
6. For interaction-bearing changes, inspect the relevant task from its starting point through completion. Check whether grouping, hierarchy, labels, and available choices make the next action clear.
7. For touch interfaces, inspect the effective hit area and spacing between targets using the platform's guidance; don't judge target size from the visible icon alone. Check keyboard focus and other input methods when in scope.
8. Check content scanning with the task in mind. Use headings, meaningful labels, and grouping to expose relevant information; do not treat an F-shaped gaze path as a universal requirement.
9. If usage data or research is supplied, confirm the highest-priority task remains supported. Don't infer a fixed 80/20 distribution without evidence.
10. Capture evidence with screenshots or clear observations.
11. Fix issues and re-check the affected viewport/state.

## Output Format

Report only useful evidence:

```text
Checked:
- route/page, viewport, task, and state

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
