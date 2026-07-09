---
name: systematic-debugging
description: Use when a bug, test failure, regression, or unexplained behavior appears. Find the root cause before proposing or applying a fix.
---

# Systematic Debugging

Use this skill when behavior is broken or unclear.

Core rule: reproduce, isolate, explain, then fix.

Apply the anti-overengineering ladder from
`C:\Users\105221\.codex\skills\using-superpowers\ANTI_OVERENGINEERING_POLICY.md`
after the root cause is known. Fix the cause with the smallest safe change.

## Workflow

1. State the observed symptom.
2. Reproduce it with the smallest reliable command or action.
3. Capture exact evidence: command, output, stack trace, affected file, route, input, or data case.
4. Form one concrete hypothesis at a time.
5. Test the hypothesis with the smallest inspection or experiment.
6. Identify the root cause before editing.
7. Check whether the root cause can be corrected through reuse, stdlib, native platform features, or a local edit before adding new structure.
8. Apply the smallest fix that addresses the cause.
9. Verify the original symptom and relevant regression surface.

## Rules

- Do not guess and patch first.
- Do not treat silence, partial logs, or old output as proof.
- Do not widen the fix before the root cause is known.
- Do not respond to a local bug by introducing a new subsystem unless the evidence shows the local path is insufficient.
- Do not add wrappers or indirection to hide the bug instead of fixing the cause.
- Prefer exact file paths, function names, routes, inputs, and commands.
- If the bug is intermittent, record frequency and triggering conditions.
- If the evidence contradicts the hypothesis, discard the hypothesis.
- Keep debug notes compact, but preserve facts.

## Caveman Compression

For debug notes, use caveman style: symptom, evidence, hypothesis, test, result, root cause, fix, verification. Short labels are enough. Do not compress stack traces, error output, code, or final user-facing explanation that needs context.
