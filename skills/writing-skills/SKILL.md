---
name: writing-skills
description: Use when creating, editing, simplifying, or verifying Codex/agent skills and other technical documentation such as README files, guides, and developer-facing instructions
---

# Writing Skills

Write documentation that helps the next person act correctly and quickly.

Use for skill editing, README work, developer guides, onboarding docs, API-facing instructions, and other technical writing where clarity and correctness matter.

## Core Principles

- Trigger precisely: the description says when to use the skill, not the whole workflow.
- Keep the loaded file short; move heavy reference material into separate files.
- Prefer judgment over ritual. Heavy gates belong only where skipping them has caused real failures.
- Optimize for day-to-day use: a frequently triggered skill must stay lightweight.
- Write for action: a future reader should know what to do next, not just what you meant.
- Make audience and task obvious when the right level of detail is not self-evident.
- Prefer structure that survives skimming: short sections, concrete bullets, one good example over many abstract notes.
- Treat bad docs as a product bug: missing prerequisites, stale examples, and ambiguous steps are correctness issues, not polish issues.

## Structure

A good writing artifact usually has:
- Purpose / core principle.
- Audience or usage boundary when that is easy to misuse.
- When to use and when not to use.
- Short workflow, checklist, or quick start.
- Common mistakes, prerequisites, or red flags.
- Links to supporting files only when needed.
- If examples matter, prefer one runnable or realistic example over decorative snippets.

Avoid:
- Long stories about past sessions.
- Multiple redundant examples.
- Flowcharts for linear steps.
- Rules that make tiny tasks feel like large projects.
- Hiding prerequisites, constraints, or maintenance caveats near the end.
- Reference-style prose when a checklist or example would teach faster.
- Mixing setup, configuration, usage, and troubleshooting into one undifferentiated wall of text.

## Verification

Before calling the writing done:
- Confirm the title, frontmatter, or opening sentence matches the real purpose.
- Re-read the document as a future reader and remove ambiguity.
- Check that the wording does not force unnecessary workflow on small tasks.
- Check that headings and bullets are scannable under time pressure.
- If misuse is likely, include one concrete example or counterexample.
- If the document contains examples, verify that they are plausible, current, and consistent with the instructions around them.
