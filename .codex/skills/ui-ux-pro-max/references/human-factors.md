# Human Factors for UI/UX

Use this reference when a design task includes navigation, forms, choices, dense content, mobile controls, or an existing user flow. Select only the principles that help with the requested task.

Treat each principle as a design hypothesis. Start from the user's goal, existing information architecture, product conventions, accessibility needs, and available evidence. A principle does not create a universal item limit or prescribe a single visual style.

## Design cues

### Gestalt grouping and visual hierarchy

People infer relationships from proximity, similarity, alignment, connectedness, common regions, and figure/ground contrast. Use these cues to show which label belongs to which field, which actions are related, and what content is primary. Use size, weight, contrast, and placement to establish reading order. Keep appearance consistent with meaning; don't make unrelated actions look interchangeable.

**Ask:** Can users tell what belongs together and where to start without reading every word?

### Fitts' Law: target acquisition

Target size, distance, and spacing affect how easily people can select a control. Consider the effective hit area, not only the visible icon or border. Keep frequently used controls comfortably reachable where the platform and task allow, and leave enough space between neighboring targets to prevent slips.

Use the intended platform's guidance rather than a universal pixel value. Apple's current guidance recommends a 44 × 44 pt button hit region on iOS/iPadOS and 60 × 60 pt in visionOS; Android recommends at least 48 × 48 dp for touch targets. These units are not interchangeable with CSS pixels. Web projects should follow their applicable accessibility and component-system requirements. A larger target is not useful if it obscures neighboring actions or makes a destructive action easy to trigger accidentally.

**Ask:** Can the intended user activate the control accurately with the expected input method?

### Hick's Law: choice complexity

More choices and more complex choices can increase decision effort. Reduce unnecessary choices, group related options, make useful defaults visible, or reveal advanced choices when they become relevant. Keep choices that users need to compare or that support different goals.

**Ask:** Does each choice help the user complete a current task, and are the differences clear?

### Miller and chunking

Chunking helps people scan and understand related information by presenting it in meaningful groups. Group by the user's task, category, or sequence; use headings, steps, or summaries when they clarify structure.

Do not treat “7 ± 2” as a fixed limit for navigation, lists, or form fields. Working-memory demands vary with familiarity, context, and how information is grouped.

**Ask:** Can users understand each group and its relationship to the next one?

### Web scanning patterns

F-shaped scanning is one observed pattern, especially when a page has weak structure. Reading behavior also depends on the user's goal, interest, language direction, page layout, and content. Use informative headings, meaningful link labels, concise summaries, bullets, and visual grouping to support different scanning strategies. Do not assume every user follows an F or place every important action according to that shape.

**Ask:** Can a user scanning for a specific answer find it from the headings and visible cues?

### Pareto Principle: prioritization

Usage and impact may be unevenly distributed. When product analytics, research, or support evidence is available, use it to identify high-value tasks and prioritize improvements. Do not assume a product follows an exact 80/20 ratio or invent usage data when none is available.

**Ask:** Which task or friction point has the strongest evidence of value for users?

## Lightweight application

1. Identify the user's goal and the most important task in scope.
2. Choose the relevant design cues above; skip principles that do not affect the task.
3. State the design choice as a hypothesis, including the user or platform context that supports it.
4. Inspect the relevant flow, viewport, input method, and interaction states. Use usability feedback or existing usage data when available.

## Sources

- [Laws of UX](https://lawsofux.com/)
- [Figma: What are the Gestalt Principles?](https://www.figma.com/resource-library/gestalt-principles/)
- [NN/g: F-Shaped Pattern of Reading](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/)
- [NN/g: Text Scanning Patterns](https://www.nngroup.com/articles/text-scanning-patterns-eyetracking/)
- [Apple Human Interface Guidelines: Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons/)
- [Apple Human Interface Guidelines: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [Android Developers: Accessibility](https://developer.android.com/design/ui/mobile/guides/foundations/accessibility)
