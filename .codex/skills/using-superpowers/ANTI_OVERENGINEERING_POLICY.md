# Anti-Overengineering Policy

This file adds a global anti-overengineering guardrail to top-level routing and workflow selection.

It is inspired by Ponytail:
- repository: `DietrichGebert/ponytail`
- idea: reduce over-building by choosing the smallest safe solution that already exists

The global goal is not code golf.
The goal is:
- less unnecessary architecture
- less unnecessary dependency churn
- less unnecessary abstraction
- fewer speculative features
- no reduction in safety, validation, accessibility, or trust-boundary discipline

## Core Rule

Be lazy about the solution, not lazy about understanding.

Read the touched code and real flow first.
Only then bias toward the smallest valid change.

## Decision Ladder

Before introducing code, components, dependencies, or workflow stages, stop at the first rung that holds:

1. Does this need to exist?
   - If no, skip it.
2. Is it already in this codebase?
   - Reuse it.
3. Can the standard library do it?
   - Use that first.
4. Can the native platform do it?
   - Prefer built-in browser, framework, shell, or OS behavior over custom layers.
5. Is there already an installed dependency that safely does it?
   - Reuse it before adding a new one.
6. Can the change stay one line or one tiny local edit?
   - Keep it local.
7. Only then build the minimum new code that works.

## Non-Negotiables

Never cut these just to make the diff smaller:
- trust-boundary validation
- data-loss prevention
- authentication or authorization correctness
- security controls
- required accessibility behavior
- essential error handling
- essential verification

## Routing Effects

At the global routing layer:
- prefer fast-track over heavy workflow when risk is low
- prefer single-agent execution over decomposition when context is still manageable
- prefer narrowing scope over introducing new abstraction
- prefer editing existing code paths over creating new frameworks or helper layers
- prefer native platform features over third-party packages when the native path is sufficient
- do not create a plan, subsystem, or capability hop unless it materially improves correctness

## Smells To Resist

Treat these as overengineering warnings:
- adding a new dependency for a built-in platform feature
- wrapping a native control without a real need
- creating a helper or abstraction used only once
- adding configuration for a one-off case
- introducing a multi-stage workflow for a tiny obvious task
- solving imagined future needs not present in the request
- replacing a local edit with a new subsystem

## Output Style

When a simpler valid path wins, say so plainly.

Examples:
- "Native browser input is enough here."
- "Existing helper already covers this flow."
- "This does not need a new dependency."
- "We can keep this as a local edit instead of adding a new layer."
