---
name: verification-before-completion
description: Use before claiming work is complete, fixed, or tested, and before commits or PRs. Run verification, read the output, and support every status claim with evidence.
---

# Verification Before Completion

Use this skill before any positive status claim about completed work.

Core rule: evidence first, claim second.

## Caveman Compression

For verification evidence summaries, use caveman style: command, exit code, key result, gap, next step. Short phrases are enough. Do not compress test output, error messages, code, or final user explanations that need full context.

## Hard Gate

```
No fresh verification evidence, no claim of completion.
```

If you did not run verification in this message, do not claim tests passed.

## Gate Function

Before claiming any status or satisfaction:

1. Decide what command proves the claim.
2. Run the full command again.
3. Read the full output, exit code, and failure count.
4. Check whether the output supports the claim.
5. If not, report the actual status with evidence.
6. If yes, state the result with evidence.

Skipping a step is not verification.

## Verification Scope Selection

Choose the strongest practical verification that covers the changed behavior. Record any
intentional gap before making a completion claim.

| Change surface | Minimum evidence |
|---|---|
| Isolated logic or data transformation | Focused unit or regression test |
| Service, API, persistence, or external integration | Integration test that exercises the boundary |
| User-visible flow, navigation, form submission, authorization, or data surviving a refresh | Automated end-to-end test of the affected user journey |
| UI layout or responsive behavior | Browser evidence and visual QA in addition to behavior checks |

Do not require E2E for internal-only changes that cannot alter a user journey. State that
boundary explicitly; do not infer it from a passing unit test.

### E2E Evidence

For a changed user journey, use the project's repeatable browser test runner. Default to
Playwright Test/CLI: keep the test in the repository, run it non-interactively, and make the
same command available through the project's verification script or contract. Exercise the
user outcome across the actual frontend, service, and test data boundary. Use isolated test
state and test accounts; do not make production data or a personal browser profile part of
the completion gate.

Playwright MCP is exploratory support, not the baseline completion gate. Use it to inspect a
live page, diagnose a failing flow, or develop selectors. Convert any behavior required for
completion into a repeatable Playwright Test/CLI assertion. An MCP walkthrough alone is not
enough evidence for an E2E completion claim.

E2E evidence must include the command, exit code, scenario result, and any failure artifact
location such as a trace, screenshot, or video. If E2E cannot run, report the exact blocker
and the remaining risk; do not substitute a static check for the missing user-journey proof.

## Common Failure Modes

| Claim | Required Evidence | Not Enough |
|------|------|--------|
| Tests pass | Test command output with 0 failures | Earlier run, guess, or "should pass" |
| Linter clean | Linter output with 0 errors | Partial check or inference |
| Build succeeds | Build command exits 0 | Linter pass or good-looking logs |
| Bug fixed | Original symptom test passes | Code changed, therefore assumed fixed |
| Regression test works | Red-green cycle verified | Test only passed once |
| User journey changed | Repeatable E2E scenario passes | Static UI check or one-off MCP walkthrough |
| Agent completed work | VCS diff and verification confirm change | Agent success report |
| Requirement satisfied | Requirement checklist verified item by item | Tests passed |

## Stop Lines

Stop before positive claims when any of these are true:

- using "should", "probably", "seems", or similar wording
- about to commit, push, create a PR, or mark done without verification
- trusting an agent success report
- relying on partial verification
- tired and tempted to finish fast
- using any wording that implies success without fresh evidence

## Anti-Rationalization

| Excuse | Reality |
|------|------|
| "It should work now" | Run verification. |
| "I am confident" | Confidence is not evidence. |
| "Just this once" | No exception. |
| "Linter passed" | Linter is not the compiler. |
| "The agent said it succeeded" | Verify independently. |
| "I am tired" | Fatigue is not evidence. |
| "Partial check is enough" | Partial check proves only the checked part. |
| "Different wording avoids the rule" | The rule covers implied success too. |

## Evidence Patterns

Tests:

```
PASS: ran test command, saw 34/34 pass.
FAIL: "should pass" or "looks right".
```

Regression test:

```
PASS: add test, run pass, revert fix, run fail, restore fix, run pass.
FAIL: test added without red-green proof.
```

Build:

```
PASS: ran build command, saw exit 0.
FAIL: linter passed, so build must pass.
```

Requirements:

```
PASS: reread plan, make checklist, verify each item, report gaps or completion.
FAIL: tests passed, so phase complete.
```

Delegated work:

```
PASS: agent reports success, inspect VCS diff, verify change, report actual status.
FAIL: trust agent report.
```

## When To Use

Use before:

- any completion or success claim
- any satisfied status statement
- any claim that work is fixed, tested, or ready
- commit, PR, or done marker
- moving to the next task
- accepting delegated work

## Bottom Line

Run the command. Read the output. Then state only what the evidence supports.
