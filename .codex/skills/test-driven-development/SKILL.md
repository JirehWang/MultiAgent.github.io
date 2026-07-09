---
name: test-driven-development
description: Use before implementing practical behavior changes or bug fixes. Write or identify the failing check first, then implement the smallest change.
---

# Test Driven Development

Use when changing behavior, fixing bugs, or adding logic that can regress.

Apply the anti-overengineering ladder from
`C:\Users\105221\.codex\skills\using-superpowers\ANTI_OVERENGINEERING_POLICY.md`
before choosing the implementation shape. Keep the fix as small and local as safely possible.

Core loop: red, green, refactor.

## Workflow

1. Define the behavior or bug symptom.
2. Find the narrowest test surface.
3. Add or update a test that proves the desired behavior.
4. Run the test and confirm it fails for the right reason.
5. Check whether reuse, stdlib, native platform features, or a local edit can solve the problem before adding new structure.
6. Implement the smallest fix.
7. Run the focused test until it passes.
8. Run the relevant broader verification.
9. Refactor only after behavior is protected.

## Rules

- Do not write implementation first when a reasonable test is possible.
- Do not accept a test that fails for the wrong reason.
- Do not skip the red step for bug fixes unless the system cannot be tested locally.
- Do not add helpers, abstractions, or dependencies when a smaller safe fix already satisfies the failing test.
- Prefer changing the touched path over introducing a new layer to avoid a local edit.
- Keep test scope proportional to risk.
- Prefer behavior assertions over implementation-detail assertions.
- If a test is impractical, state why and use the next strongest verification.

## Caveman Compression

For TDD notes, use caveman style: target behavior, test file, red result, fix, green result, broader check. Do not compress test output, errors, or final explanation.
