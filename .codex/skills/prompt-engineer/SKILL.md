---
name: prompt-engineer
description: Use when designing, refining, testing, versioning, or evaluating prompts and AI instructions for reliable output formats and behaviors.
---

# Prompt Engineer

Treat prompts like executable specs, not vibes.

## Use For

- Building prompts for tools or automation.
- Hardening prompts against ambiguity.
- Defining output schemas and refusal behavior.
- Comparing prompt versions.
- Designing prompt test cases.

## Workflow

1. Define the exact output format first.
2. Define success criteria and failure modes.
3. Add explicit scope, constraints, and fallback behavior.
4. Prefer concrete examples over abstract style guidance.
5. Version the prompt and test it with representative cases.

## Minimum Deliverable

- Prompt text
- Expected output format
- 3 test cases:
  - normal
  - edge
  - failure / adversarial

## Red Flags

- "Be helpful" without measurable meaning.
- No schema, no examples, no refusal behavior.
- Changing prompt and model settings together so regressions become untraceable.
