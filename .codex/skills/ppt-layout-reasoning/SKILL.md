---
name: ppt-layout-reasoning
description: "Plan, review, revise, and analyze PowerPoint slides and decks (.ppt, .pptx, or slide images) by reasoning about composition, hierarchy, spacing, density, diagrams, and editable native shapes. Use when Codex needs a layout brief, slide critique, geometry or placeholder analysis, or a revision plan while the user's existing PowerPoint workflow performs actual editing or generation."
---

# PPT Layout Reasoning

Produce an implementation-ready layout handoff, not a slide file. Do not require or assume PptxGenJS, python-pptx, PPTist, Slidev, Marp, or PPTAgent; treat them as optional conceptual references only. Leave editing and generation to the user's existing PowerPoint tool or workflow.

## 1. Classify the request

State one mode before making recommendations:

- **Planning:** define the message, archetype, zones, object plan, and risks for a new slide or deck.
- **Reviewing:** inspect an existing slide/deck or screenshot; separate observed evidence from recommendations.
- **Revising:** preserve the intended message and useful existing structure; describe before/after changes and tradeoffs.
- **Analyzing:** extract geometry, placeholders, repeated layout patterns, hierarchy, density, and narrative patterns; label inferred values as assumptions.

If a PPT/PPTX is available, use its actual slide size, theme, masters, placeholders, object bounds, and repeated patterns before proposing changes. If only images or prose are available, state the measurement assumptions.

## 2. Choose the slide archetype first

Name one primary archetype before placing content. If a slide is hybrid, name the primary archetype and the one supporting pattern.

- **Title/hero:** establish a single claim with one dominant visual.
- **Comparison:** make two or more alternatives comparable on shared dimensions.
- **Process/timeline:** show ordered stages, handoffs, or milestones.
- **Hierarchy:** show parent-child ownership, taxonomy, or decision structure.
- **Matrix/dashboard:** expose multiple dimensions, status, or coverage at a glance.
- **Data story:** make one evidence-backed trend, contrast, or implication salient.
- **Quote/section divider/appendix:** create emphasis, transition, or reference space.

Write the slide's one-sentence takeaway and its reading path (start, scan, finish) before assigning objects.

## 3. Establish geometry before objects

Record these constraints in the handoff:

- **Canvas:** aspect ratio, orientation, and actual width/height when known. Use widescreen 16:9 only as a marked assumption.
- **Safe area:** outer margins and reserved title/footer/source areas. Start around 5-8% of slide width for outer margins and 2-3% for gutters, then adjust to the master and typography.
- **Grid:** columns or rows, gutter size, anchor lines, baseline, and the dominant alignment axis.
- **Zones:** give each zone a proportional or native-unit `x, y, w, h`; reserve space before filling it.
- **Layers:** state background, structural shapes, content, connectors, labels, and annotations in z-order.

Use normalized coordinates (`0-1`) when measurements are unavailable and native units when artifact geometry is available. Align related objects to shared edges or baselines, keep repeated gaps equal, and use whitespace to show grouping. Do not begin with a pile of boxes and retrofit the grid later.

## 4. Control hierarchy and content density

Set one focal element, up to two supporting levels, and a clear reading order. Budget content before styling:

- one short title claim, not a topic label;
- one focal visual or comparison;
- a small number of scannable supporting items, each carrying one claim;
- source, qualifier, or next-step text in a visibly subordinate zone.

If content exceeds the density budget, first shorten, group, remove, or split it. Shrinking typography or tightening spacing is a last resort. Specify title, section label, body, annotation, and source roles with consistent font, weight, line spacing, and contrast. Keep one semantic color meaning stable across the slide and deck.

## 5. Map meaning to editable native objects

Choose objects for what they communicate, not for decoration. Explain the semantic job of every nontrivial object.

| Native object | Use it to convey | Planning rule |
| --- | --- | --- |
| Text box | Claim, label, annotation, or source | Keep meaningful text separate and editable; give its bounds and alignment. |
| Rectangle/rounded rectangle | Container, card, region, or status block | Use a container only when grouping has meaning; avoid boxing every item. |
| Circle/ellipse | Node, milestone, status, or part-to-whole emphasis | Reserve the shape for point-like or cyclical meaning. |
| Attached connector with arrowhead | Sequence, cause, dependency, or handoff | Attach endpoints to nodes; route around labels; prefer connectors over decorative lines. |
| Chevron/arrow | Directional stage or progression | Use for ordered phases, not for arbitrary grouping. |
| Table/grid or aligned cells | Shared-dimension comparison or matrix | Keep each datum editable; align headers and values to a repeatable grid. |
| Native chart, diagram, or SmartArt | Quantitative trend or recognized hierarchy | Use only when its structure helps the message; state any editability tradeoff. |
| Freeform/curve | Irregular emphasis or annotation | Use sparingly because it is harder to edit, align, and reuse. |

For each object, provide a compact manifest: `id/type`, semantic role, bounds, text/data, fill/line/typography, connector endpoints, group/layer, and editability note. Preserve native objects when requested: keep text, shapes, connectors, tables, charts, and diagrams as separate editable elements; keep groups unflattened; and preserve connector attachment. Do not recommend a flattened screenshot as the default. Use one only when the user explicitly accepts the loss of editability or when the source cannot be represented natively, and state that limitation.

## 6. Return a compact handoff

Use this order so the user's existing workflow can implement the plan:

1. **Mode and evidence:** planning, reviewing, revising, or analyzing; list measurements versus assumptions.
2. **Archetype and message:** primary pattern, one-sentence takeaway, reading path.
3. **Canvas and grid:** size, safe area, zones, anchors, gutters, alignment, and layer order.
4. **Object plan:** native type and semantic role for each object, with bounds and connector relationships.
5. **Density and style:** text budget, hierarchy, typography roles, color semantics, and whitespace.
6. **Risks and QA:** unresolved content, accessibility, editability, and visual checks.

For source-specific conceptual guidance, read [references/open-source-reference-map.md](references/open-source-reference-map.md). Do not install or invoke any listed project unless the user's existing workflow separately requires it.

## 7. Run the visual QA gate

- **Overflow:** no text, object, label, or connector is clipped or outside the safe area.
- **Collisions:** no unintended overlaps, tangencies, hidden labels, or connector crossings.
- **Alignment:** shared edges, baselines, centers, gutters, and repeated sizes are intentional and consistent.
- **Contrast:** text and key distinctions remain legible in the theme; color is not the only semantic cue.
- **Typography:** hierarchy, line length, wrapping, font availability, and minimum readable size hold at presentation scale.
- **Narrative:** the title states the takeaway, the visual proves or clarifies it, the reading path is obvious, and the slide earns its place in the deck.
- **Editability:** requested native objects remain separate, attached, selectable, and understandable after ungrouping.

## 8. Respect license boundaries

Reading layout concepts is different from copying code or assets. Before reusing code, inspect the source repository's current `LICENSE`, `NOTICE`, and file headers; preserve applicable copyright, attribution, license-text, notice, and redistribution obligations. Do not copy assets when permission or terms are unclear.
