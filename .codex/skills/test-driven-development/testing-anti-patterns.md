# Testing Anti Patterns

Use this reference when a test looks green but does not prove the behavior.

## Anti Patterns

Mocking the unit under test:
- The test passes because the real behavior never ran.
- Fix: mock only external boundaries.

Asserting implementation details:
- The test breaks on harmless refactors and misses user-visible behavior.
- Fix: assert inputs, outputs, state changes, side effects, or contracts.

Testing only the happy path:
- Edge cases and failures remain unprotected.
- Fix: include invalid input, empty state, permission failure, network failure, and boundary values when relevant.

Snapshot-only testing:
- The snapshot changes, but the test does not explain correctness.
- Fix: add explicit assertions for the important behavior.

Green without red:
- The test may be wrong or already covered.
- Fix: prove the test fails for the original bug or missing behavior.

Too-broad integration test:
- Slow feedback hides the failing cause.
- Fix: add the smallest focused test first, then broader checks.

Flaky waiting:
- Sleeps hide race conditions and slow the suite.
- Fix: wait on observable conditions.

Overfitting to current data:
- The test passes only for one fixture shape.
- Fix: include representative variations.

No regression assertion:
- The bug can return without a failing test.
- Fix: encode the original symptom.

## Quick Check

Before trusting a new test, ask:

- Did it fail before the fix?
- Did it fail for the right reason?
- Does it run the real behavior?
- Would it catch the bug returning?
- Is it narrow enough to diagnose failure?
