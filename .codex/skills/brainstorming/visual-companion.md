# Visual Companion

Use a browser-based visual companion only when seeing options is better than reading them.

## Use For

- UI layout options
- architecture diagrams
- side-by-side design comparisons
- visual hierarchy or spacing decisions
- state diagrams and relationship maps

## Prefer Text For

- scope questions
- API or data model tradeoffs
- requirements clarification
- simple A/B/C choices that can be described clearly

## Workflow

1. Start or locate the visual companion server.
2. Write one new HTML screen per decision.
3. Use semantic filenames such as `layout.html` or `visual-style-v2.html`.
4. Do not reuse old screen filenames.
5. Tell the user what the screen shows and what choice is needed.
6. On the next turn, read terminal feedback and any `.events` file.
7. Iterate only when the current visual question is still unresolved.

## Content Rules

- Keep each screen focused on one decision.
- Use two to four options.
- Use realistic content when placeholder text would hide the design problem.
- Keep prototypes simple enough to compare quickly.
- Return to text mode when the visual decision is done.
