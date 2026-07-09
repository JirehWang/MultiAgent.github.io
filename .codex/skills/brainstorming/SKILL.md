---
name: brainstorming
description: Use when creative features, UX, components, workflows, or behavior design need intent and tradeoff exploration before implementation. Tiny obvious changes may use a lightweight path.
---

# Brainstorming

Use this skill when the right direction is not yet obvious.

Before expanding options, apply the anti-overengineering ladder from
`C:\Users\105221\.codex\skills\using-superpowers\ANTI_OVERENGINEERING_POLICY.md`.
Bias toward the smallest safe solution that satisfies the actual request.

## Workflow

1. Clarify the goal, audience, constraints, and success criteria.
2. Identify what is fixed and what is open.
3. Check whether the problem can be solved by reuse, stdlib, native platform features, or a small local change before proposing larger structures.
4. Offer a small set of meaningfully different options.
5. Compare tradeoffs in practical terms.
6. Recommend one direction when enough context exists.
7. Convert the choice into implementation-ready notes.

## Rules

- Do not brainstorm when the user asked for a direct small edit.
- Do not produce many shallow options.
- Do not ask broad questions when local context can answer them.
- Do not invent new layers, dependencies, or workflows before testing whether a simpler path already works.
- Do not reward speculative extensibility when the current request is narrow.
- Prefer concrete examples, flows, states, and constraints.
- For visual choices, use the visual companion only when seeing options helps more than reading them.
- Prefer options that remove moving parts without reducing safety, accessibility, validation, or essential error handling.

## Caveman Compression

For option notes, use caveman style: option, use when, tradeoff, risk, pick. Do not compress user-facing design copy or final rationale that needs nuance.
