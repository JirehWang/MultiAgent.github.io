---
name: spiritual-slide-composer
description: Turn completed devotional-study analysis into slide-ready or note-ready outputs for Bible teaching, sermon prep, study handouts, or spiritual PPT decks. Use when exegesis, theology, and formation are already stable and the user now needs presentation structure, concise slide content, or visual prompting.
---

# Spiritual Slide Composer

Do formatting last.

## Preconditions

Before composing slides, confirm you already have:

- passage meaning
- theological movement
- pastoral application

If these are missing, ask the upstream stages to finish first.

If the requested slide is Bible-map driven, also confirm:

- the FHL source map is identified
- the viewport must stay FHL-locked
- the contour must stay FHL-locked
- the user wants the workflow to stop after NotebookLM upload unless they explicitly ask for generation

## Style goals

- high scannability
- minimal wording
- 16:9 slide awareness
- reverent, clean, non-busy tone
- concise Traditional Chinese phrasing when the user is working in Chinese

## Bible map extension

When the slide is geography-heavy, use this map-specific flow.

### Source rules

- FHL decides the viewport.
- FHL also decides the contour.
- If the FHL source crops a boundary, keep the same cropped extent.
- Do not infer or redraw missing edges from Bible text.

### Visual optimization scope

You may improve:

- terrain relief
- color harmony
- labels
- layout cleanliness
- slide readability

Do not improve by:

- inventing new contours
- extending clipped boundaries
- freehanding tribal shapes from interpretation

### Validation gate

Before accepting a refined map, compare the candidate contour against the FHL source contour.

Use:

- `work/presentations/bible-ppt-generator/validate_fhl_contour_overlap.py`

Target:

- `score >= 0.95`

If the score is below that threshold, keep correcting before calling the map ready.

### NotebookLM package flow

Use the existing local scripts when they fit:

- `work/presentations/bible-ppt-generator/prepare_notebooklm_atlas_package.py`
- `work/presentations/bible-ppt-generator/prepare_notebooklm_deck_package.py`
- `work/presentations/bible-ppt-generator/prepare_notebooklm_combined_package.py`
- `work/presentations/bible-ppt-generator/upload_slide_package_to_notebooklm.py`
- `work/presentations/bible-ppt-generator/upload_combined_package_to_notebooklm.py`
- `work/presentations/bible-ppt-generator/FHL_SOURCE_LOCK_WORKFLOW.md`

### NotebookLM stop rule

For this skill, the handoff endpoint is:

- the per-slide package is uploaded to NotebookLM, or
- the combined package is uploaded to NotebookLM

Stop there.

Do not continue into:

- waiting for generation
- pressing Generate
- pulling images back down
- rebuilding the PPT

unless the user explicitly asks for the next stage.

## Slide structure

Use this shape unless the user requests another:

`### Slide X: [short title] | [supporting subtitle]`

Then include:

- `Slide Content`
- `Visual Composition`

## Slide content rules

- 3 to 5 bullets max
- each bullet should carry one idea
- avoid paragraph blocks
- preserve theological precision even when compressing

## Visual composition rules

- define one clear concept only
- keep prompts visually specific
- prefer wide cinematic, symbolic, terrain, or minimalist spiritual compositions
- avoid generic stock-photo language
- for map slides, do not invent contours here; keep all geographic outlines locked to the FHL source

## Output contract

Use this order:

1. `Slide title`
2. `Slide Content`
3. `Visual Composition`
4. `Prompt for image system`

For map workflows, also report:

5. `FHL source used`
6. `Contour validation status`
7. `NotebookLM upload status`
8. `Next manual step`
