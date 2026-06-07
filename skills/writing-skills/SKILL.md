---
name: writing-skills
description: Use when creating, editing, simplifying, or verifying Codex/agent skills and their trigger descriptions
---

# Writing Skills

Skills are reusable operating instructions. They should make future agents more effective with the fewest tokens and the least ceremony that still protects quality.

## Core Principles

- Trigger precisely: the description says when to use the skill, not the whole workflow.
- Keep the loaded file short; move heavy reference material into separate files.
- Prefer judgment over ritual. Heavy gates belong only where skipping them has caused real failures.
- Optimize for day-to-day use: a skill that fires often must be especially lightweight.

## Editing Modes

### Light Edit

Use for wording, trigger cleanup, token reduction, examples, or reducing friction.

Flow:

```text
read current skill -> identify behavior change -> edit -> verify frontmatter and readability
```

No failing pressure test is required for obvious documentation cleanup.

### Full Skill Design

Use for new skills or discipline-enforcing skills that change agent behavior under pressure.

Flow:

```text
define failure mode -> create pressure scenario -> observe likely failure if practical -> write minimal skill -> test scenario -> refine
```

For discipline skills such as TDD, debugging, safety, verification, or review, explicitly close common rationalizations.

## Frontmatter

Required:

```yaml
---
name: skill-name
description: Use when ...
---
```

Guidelines:

- `name`: lowercase letters, numbers, and hyphens.
- `description`: trigger conditions only.
- Start with “Use when...” for English skills, or the equivalent concise trigger in another language.
- Include concrete symptoms, contexts, or user intents.
- Do not summarize step-by-step workflow in the description.

## Structure

A good `SKILL.md` usually has:

- Purpose / core principle.
- When to use and when not to use.
- Short workflow or checklist.
- Common mistakes or red flags.
- Links to supporting files only when needed.

Avoid:

- Long stories about past sessions.
- Multiple redundant examples.
- Flowcharts for linear steps.
- Mandatory commits, subagents, or approvals unless the skill truly needs them.
- Rules that make tiny tasks feel like large projects.

## Token Budget

Frequently triggered skills should usually stay under 500 words. Rare reference skills can be longer, but should split heavy details into supporting files.

When shortening, preserve:

- Trigger accuracy.
- Non-obvious constraints.
- Safety or correctness gates.
- The smallest example that teaches the pattern.

## Verification

Before calling the edit done:

- Confirm YAML frontmatter parses visually.
- Confirm the description matches the intended trigger.
- Re-read the skill as a future agent and remove ambiguity.
- Check that the new wording does not force unnecessary workflow on small tasks.
