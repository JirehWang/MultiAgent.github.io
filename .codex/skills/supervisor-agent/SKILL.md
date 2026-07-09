---
name: supervisor-agent
description: Use when the task is QA-first agent oversight such as AWU review, plan-vs-actual comparison, trajectory inspection, completion gating, or retry/escalation judgment.
---

# Supervisor Agent

Use this skill when the main job is to judge agent work rather than perform the work.

## Core Role

This skill is for a QA and governance layer:

- inspect whether the intended plan was followed
- assess whether completion claims are actually supported
- evaluate whether cost, retries, and tool usage were reasonable
- classify variance between plan and actual behavior
- decide whether the result should be accepted, reviewed, retried, escalated, or redesigned

## Use When

Prefer this skill for:

- AWU supervision
- plan-vs-actual review
- agent trajectory QA
- completion gate checks
- acceptance review after execution
- retry or escalation decisions after an agent run

## Do Not Use When

Do not use this skill as the primary execution path for normal implementation, document work, extraction, or architecture design.

If the main need is to produce the work artifact, route to the appropriate execution skill first. Use this skill after an execution artifact, trace, trajectory, or review surface exists.

## Review Lens

Focus on:

- explicit goal completion
- trajectory reasonableness
- cost efficiency
- unnecessary loops or retries
- tool misuse or unexplained detours
- hidden human rescue
- clear variance reasons

## Output Expectations

A good supervision result should usually include:

- the reviewed unit or scope
- observed facts
- variance summary
- governance outcome
- next action

Keep facts and inference separate.
