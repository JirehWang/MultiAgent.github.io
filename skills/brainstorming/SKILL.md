---
name: brainstorming
description: 在創造性功能、UX、元件、流程或行為設計需要先釐清意圖與取捨時使用；小型明確修改可走輕量模式
---

# Brainstorming

Use this skill to turn an idea into a clear design before implementation. Keep the process proportional to the risk.

## Mode Selection

### Light Mode

Use for small or clear requests:

- Small UI/CSS/content changes.
- A single component tweak.
- A narrow behavior change with obvious intent.
- The user already gave clear requirements.

Light flow:

```text
inspect context -> state the intended approach briefly -> ask at most one blocking question if needed -> implement when clear
```

No required spec file, commit, visual companion, or formal approval gate.

### Full Design Mode

Use for high-impact or ambiguous creative work:

- New page, feature, app flow, component system, or major UX behavior.
- Multiple plausible approaches with meaningful tradeoffs.
- Requirements are fuzzy or success criteria are unclear.
- Implementation will affect architecture, data flow, or user workflows.

Full flow:

```text
inspect context -> ask focused questions -> propose 2-3 options -> recommend one -> present design -> get approval -> write plan/spec if useful
```

Only create a design document when the design is substantial enough to be reused during implementation, or when the user asks for one.

## Conversation Rules

- Ask one focused question at a time when blocked.
- Prefer concrete choices over broad open questions.
- Offer 2-3 options only when there are real tradeoffs.
- Recommend a path once enough context exists.
- Keep YAGNI pressure on: remove nice-to-have features that do not serve the goal.

## Design Coverage

For substantial work, cover only the relevant parts:

- User goal and success criteria.
- Scope and non-goals.
- UX / workflow behavior.
- Data, state, API, or integration impact.
- Error handling and edge cases.
- Test or verification strategy.

## Visual Work

For visual design questions, inspect the existing UI first. Use browser screenshots, quick prototypes, or visual comparisons only when seeing the result would materially improve the decision.

Do not force a separate visual-companion offer for every UI discussion. Use it when it helps.

## Handoff

After brainstorming:

- For small work, proceed directly with the agreed approach.
- For multi-step work, use `writing-plans`.
- For risky implementation, include the verification strategy before coding.
