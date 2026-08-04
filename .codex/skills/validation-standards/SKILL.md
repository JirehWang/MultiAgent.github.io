---
name: validation-standards
description: Apply the approved SDD, DDD, and BDD validation contracts without installing unreviewed third-party skills or forcing every task through every stage.
---

# Validation Standards Adapter

Use this adapter for multi-stage and high-risk work, or when the user explicitly asks for SDD, DDD, or BDD validation.

The adapter adopts stable concepts from approved open-source projects while keeping the global workflow tool-neutral:

- SDD: Spec Kit core artifact model — specification, plan, tasks, checklist, and review points.
- DDD: Context Mapper concepts — ubiquitous language, bounded contexts, ownership, invariants, aggregates, and service contracts.
- Executable DDD boundaries: ArchUnit or ArchUnitNET when the project already uses Java or .NET architecture tests; otherwise use a documented architecture checklist.
- BDD: Gherkin syntax and Cucumber-style executable scenarios, executed by the project's native runner when available.

Do not install or copy community extensions, presets, schemas, or third-party `SKILL.md` files as part of this adapter.

## SDD contract

Produce or update a living specification containing:

- goal, scope, non-goals, constraints, assumptions, and dependencies
- observable acceptance criteria
- implementation plan and task decomposition appropriate to the risk tier
- unresolved questions and explicit decisions

Pass only when every in-scope requirement has an observable acceptance condition, non-goals are stated, and no unresolved ambiguity can change the implementation or verification scope. A short checklist is sufficient for standard work.

## DDD contract

Apply DDD only when domain rules, invariants, ownership boundaries, or service decomposition are material.

Record:

- glossary / ubiquitous language
- bounded contexts and ownership
- aggregates or transactional boundaries where relevant
- invariants and domain policies
- integration relationships, published language, and service/API contracts

Pass only when each material domain rule has an owner and an enforcement point, context boundaries are explicit, and cross-context contracts are testable or independently reviewed. Architecture tests prove structural boundaries; they do not prove business correctness.

## BDD contract

Use Gherkin-style scenarios for externally observable behavior, user journeys, or service contracts. Scenarios must be understandable by a non-implementer and executable by the project runner when practical.

Cover the relevant combination of:

- happy path
- validation or negative path
- boundary or edge case
- authorization / unauthenticated behavior when applicable
- failure, retry, idempotency, or rollback behavior when applicable

Pass only when critical acceptance criteria map to observable scenarios and every scenario has a clear result. A static `.feature` file without an executable or reviewable verification path is not sufficient for a required BDD gate.

## Evidence and recovery

Every applied stage records:

```yaml
stage: sdd | ddd | bdd
status: passed | exempted | blocked
artifact: path-or-inline-reference
evidence: command-review-or-test-reference
known_gaps: []
remaining_risk: none-or-description
```

If a stage is not applicable, record an explicit exemption and its reason. If BDD, integration, E2E, or architecture verification finds a contradiction, reopen SDD or DDD rather than patching around the evidence.

## Risk-tier normalization

Normalize the tier after route selection so a narrow implementation route cannot hide wider risk:

- `high_risk` wins for payment, authorization, compliance, regulated data, security-sensitive, or high-consequence changes.
- `multi_stage` wins for multiple subsystems, APIs, persistence, databases, user journeys, cross-service work, or unresolved domain rules.
- `standard` covers narrow code or behavior changes.
- `basic` covers simple questions, documentation, and mechanical edits.

Normalization changes required gates and artifacts. It preserves the selected workflow owner and node.

## Supply-chain controls

- Prefer the official core repositories and pinned releases or commits.
- Do not use `latest` in enterprise workflows.
- Keep OpenSpec telemetry disabled if OpenSpec is ever introduced: `OPENSPEC_TELEMETRY=0` and/or `DO_NOT_TRACK=1`.
- Review every Spec Kit shell workflow before execution; shell steps run with the user's privileges and are not sandboxed.
- Treat community extensions, presets, workflows, schemas, and agent skills as untrusted until separately screened by `skill-gatekeeper`.
- Preserve MIT or Apache-2.0 notices when redistributing any bundled tool or generated package.

## Self-check

Run `python scripts/validate_global_workflow.py`. A passing run must report zero failed checks and zero route-to-node allowlist mismatches. A structural TOML fallback is permitted only when no TOML parser is available, and the output must state that limitation.
