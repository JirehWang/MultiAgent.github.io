# Architecture Change Result Review Criteria

Status: Draft v0.1  
Scope: Defines how to establish change-specific review conditions before implementation and how to review the delivered change against them afterward. This is a review contract, not an implementation or CI configuration.

## 1. Review purpose

The result review answers: **Does the delivered change implement the agreed outcome, reuse the right capabilities, preserve declared boundaries and contracts, and provide enough evidence to accept it?**

Use this after implementation and before closing the architecture review. Apply only relevant checks, but record why a check is not applicable. Do not treat the impact score, Jev score, clean build, or code author's statement as a substitute for review evidence.

## 2. Required review packet

The reviewer needs:

- Review ID and reviewed commit/diff or exact changed-file set.
- Approved outcome, explicit non-goals, constraints, and acceptance criteria.
- The frozen, change-specific review-criteria baseline created before implementation, including its version and applicability decisions.
- Architecture impact score, review depth, and override triggers.
- Decision baseline; for a no-grill route, the recorded implementation boundary and assumptions.
- Affected modules, ownership, allowed dependency changes, contracts, consumers/providers, and reusable candidates.
- Required verification list and available results/log references.
- Known risks, exceptions, and any checks not run.

If the decision baseline or change under review cannot be identified, return **BLOCKED** and request the missing evidence. Do not infer acceptance criteria after seeing the implementation.

## 3. Pre-implementation review-criteria baseline

The general criteria in this document are a rubric, not a substitute for conditions tailored to the current change. After requirements and architecture decisions are settled, instantiate the applicable criteria before implementation begins.

For every in-scope requirement or material decision, define:

| Baseline field | Required content |
|---|---|
| Criterion ID | Stable identifier, such as AC-01, REUSE-01, CONTRACT-01, or ARCH-01. |
| Source | Requirement, constraint, architecture decision, risk, or non-goal this criterion verifies. |
| Applicability | Applicable, or exempted with a reason. Do not omit an R1–R8 area silently. |
| Pass/fail condition | Observable result or invariant that makes the criterion pass or fail. Avoid terms like clean, good, or works without a defined observation. |
| Evidence method | Specific test, contract diff, architecture check, symbol/call-site inspection, manual scenario, or other reviewable evidence. |
| Owner | Person/role responsible for producing or reviewing that evidence. |
| Failure disposition | Whether failure blocks implementation acceptance, and what correction or decision is needed. |

Before implementation, the baseline is ready only when:

- Each in-scope user outcome and material architecture decision maps to one or more stable criteria.
- Every applicable R1–R8 area has a concrete pass condition and identified evidence method; every exemption has a reason.
- Required tests/checks are identified at the risk tier appropriate to the change. A required check cannot be deferred silently.
- No unresolved ambiguity could change behavior, ownership, contracts, dependency direction, migration/lifecycle, or the verification scope.
- The user or designated owner has seen and confirmed criteria that encode product behavior, quality thresholds, or accepted risk.

Use one of these baseline states:

- **READY_FOR_IMPLEMENTATION:** criteria are observable, evidence and owners are identified, and material decisions are resolved.
- **NEEDS_CLARIFICATION:** a criterion encodes an unresolved product/architecture choice or cannot yet be stated objectively; return to the grill or ask the owner.
- **BLOCKED:** required project context, access, dependency information, or evidence is unavailable; do not claim readiness.

The baseline state is a pre-implementation readiness decision. It is separate from the post-implementation review result (PASS/FAIL/BLOCKED).

Freeze/version the baseline before implementation. If scope or requirements change, create a revised baseline and record why. Do not weaken a criterion after seeing a failing result merely to obtain PASS.

Example baseline rows:

| ID | Pass condition | Evidence |
|---|---|---|
| AC-01 | A request missing a required field returns the declared validation error. | Contract test and reviewed error schema. |
| REUSE-01 | The existing capability is called, or a material semantic/lifecycle difference justifying separate code is recorded. | Candidate symbol, call-site, test search, and diff review. |
| ARCH-01 | New calls follow the approved dependency direction and introduce no forbidden cycle. | Architecture check or documented dependency inspection. |

Reusable per-change template:

- Review ID / baseline version:
- Criterion ID:
- Source requirement or architecture decision:
- Applicability / exemption reason:
- Observable pass condition:
- Fail condition and disposition:
- Required evidence/check and owner:
- User/owner confirmation, when the criterion encodes a product or risk decision:

## 4. Per-check outcomes and overall decision

Each applicable criterion receives one status:

| Status | Meaning |
|---|---|
| PASS | The criterion is met and the reviewer has traceable evidence. |
| FAIL | Evidence shows the change violates the criterion or approved decision. |
| NOT_RUN | A required command, test, specialist review, or inspection was not performed. |
| BLOCKED | The criterion cannot be assessed because required context, access, or evidence is missing. |
| EXEMPTED | The criterion is genuinely not applicable; record the reason and have the reviewer confirm the exemption. |

Overall result:

- **PASS** only when every mandatory criterion is PASS or has a confirmed EXEMPTED disposition, with no unresolved blocking finding.
- **FAIL** when any criterion fails or the implementation contradicts the approved outcome, architecture decision, or a mandatory acceptance condition.
- **BLOCKED** when there is no known FAIL, but a required criterion is NOT_RUN/BLOCKED or its evidence is missing. BLOCKED is not approval.
- A known FAIL takes precedence over missing evidence: report FAIL and list additional blocked checks separately.

Accepted residual risks must be recorded with an owner and disposition allowed by project policy. Risk acceptance does not turn a known contract, security, correctness, or hard-constraint failure into PASS.

## 5. Must-pass review criteria

| ID | Criterion | PASS evidence | FAIL examples |
|---|---|---|---|
| R1 Scope and outcome | The diff stays within the approved scope; each in-scope observable acceptance criterion maps to changed behavior and reviewable evidence. | Decision/acceptance ID → changed symbol or contract → test, inspection, or check result. | Silent scope expansion; a required outcome has no implementation; behavior contradicts an explicit non-goal or decision. |
| R2 Ownership and boundaries | New or changed behavior lives in the agreed owner; calls and imports follow permitted dependency direction; no unapproved cross-boundary access or cycle is introduced. | Module ownership note, dependency/call evidence, architecture check or documented inspection. | Logic added to an unrelated module; provider internals bypassed; forbidden dependency/cycle or boundary crossing. |
| R3 Reuse and duplication | Existing capabilities with matching business semantics are reused or extended. Any new implementation has an evidence-backed semantic, ownership, error, side-effect, or lifecycle reason. | Search terms/scope, candidate symbols and call sites checked, relevant tests, and a short reuse decision. | A second function/block implements the same capability without a documented material difference; copy-paste clone is left in place without justification. |
| R4 Contract and compatibility | Every affected public/shared contract matches its declared input/output semantics, errors, authorization, side effects, and version policy; impacted consumers/providers remain compatible or follow the approved migration plan. | Schema/diff review, contract test or provider-consumer evidence, API-contract review when required. | Undocumented schema drift; incompatible change without version/deprecation plan; auth or error semantics regress; a required contract review is missing. |
| R5 Behavior and acceptance | Critical behavior is covered by appropriate evidence. User-visible behavior and service contracts have clear happy-path and relevant negative, edge, authorization, and failure coverage. | Passing relevant test results or an explicit, reviewable manual check tied to acceptance criteria. | Critical acceptance criteria lack verification; relevant failure/authorization path regresses; a required test was not run but is represented as passed. |
| R6 Data and lifecycle | Persistence, migrations, old consumers, deprecation, rollback, dual support, and data invariants are handled as agreed. | Migration/rollback evidence, compatibility plan, data invariant check, or confirmed exemption for unchanged persistence. | Destructive or incompatible data change without approved migration/rollback; old consumers or stored data are silently broken. |
| R7 Risk and operational behavior | Applicable security, privacy, performance, availability, and failure requirements are met, including validation, timeout/retry/idempotency, and safe logging where relevant. | Relevant security/privacy review, resource/failure tests, declared budget checks, or documented evidence-based exemption. | Sensitive data exposure; auth bypass; unbounded resource use; unsafe retry/duplicate side effect; required risk check not performed. |
| R8 Change quality and maintainability | New abstractions have a present use and clear owner; names reflect semantics; changed code follows project conventions; unrelated or dead code is not included. | Diff inspection, lint/static-analysis result where required, ownership and usage evidence. | Speculative framework added without a current need; unexplained dead/commented code or unrelated changes; code obscures ownership or duplicates business policy. |

Do not require every test type for every change. Choose applicable checks from risk and touched boundaries. For externally observable behavior, use reviewable or executable behavior scenarios. For material domain rules, verify ownership, invariants, and enforcement points. Structural architecture checks do not prove business correctness.

## 6. Reuse and duplicate-code decision rule

Search for candidates by behavior and domain meaning, not only by function name. Inspect likely definitions, call sites, tests, and relevant contracts.

| Finding | Review decision |
|---|---|
| Same business meaning, owner, inputs/outputs, errors, side effects, and lifecycle | Reuse the existing capability or extend it in its owner. An unexplained second implementation fails R3. |
| Similar shape, but materially different semantics, authorization, side effects, lifecycle, or owner | Separate implementations may be valid. Record the specific difference and why a shared abstraction would be misleading. |
| Existing helper is close but missing a required behavior | Prefer extending it when the extension belongs to the same owner and preserves existing callers; verify compatibility. |
| Search finds no candidate | Record search scope and evidence. Do not claim a global absence from a narrow search. |
| Automated duplication tool flags a block | Inspect semantics before disposition. A metric is evidence to review, not by itself proof that two capabilities should share an abstraction. |

A reviewer may reject a proposed reuse when sharing would couple unrelated domain policies or lifecycles. Explain that decision with evidence.

## 7. Risk normalization and check selection

Impact score determines architecture discussion depth. Review risk is assessed separately so a low-scoring narrow change cannot hide high consequence.

- **High risk:** payment, authorization, compliance, regulated data, security-sensitive, or other high-consequence behavior. Security/privacy and failure-path evidence are mandatory when applicable.
- **Multi-stage:** multiple subsystems, APIs, persistence/database changes, user journeys, cross-service work, or unresolved domain rules. Contract, lifecycle, and integration evidence are mandatory when applicable.
- **Standard:** bounded code or behavior change in an established owner.
- **Basic:** documentation or mechanical change with no behavior/contract effect.

Use the higher applicable risk tier. Mark genuinely irrelevant criteria EXEMPTED with a reason; do not lower the tier because the patch is small.

## 8. Finding format and severity

Each finding includes:

- Finding ID and severity.
- Criterion ID (R1–R8).
- File/symbol/line or contract reference.
- Observed evidence and the expected decision/requirement.
- User or system impact.
- Required correction or verification to close it.

Severity:

- **Blocker:** material correctness, security, privacy, data integrity, hard constraint, or contract failure. Must be resolved before acceptance.
- **Major:** architecture boundary/ownership violation, unexplained duplicate capability, or unmet mandatory acceptance condition. Must be resolved before acceptance.
- **Minor:** localized maintainability issue that does not violate a mandatory criterion. May be accepted or tracked under project policy.
- **Observation:** informational, no corrective action required.

Do not file style preferences as blockers when the code follows declared project conventions and all behavior/architecture criteria pass.

## 9. Review result record

Record the result in this shape:

| Field | Value |
|---|---|
| Review ID / reviewed revision | |
| Outcome and scope match | PASS / FAIL / BLOCKED, with evidence |
| Architecture decision match | PASS / FAIL / BLOCKED, with evidence |
| Overall result | PASS / FAIL / BLOCKED |
| Criteria | R1–R8 category status plus every change-specific criterion ID, evidence reference, or exemption reason |
| Findings | ID, severity, criterion, location, impact, required closure evidence |
| Required checks | PASS / FAIL / NOT_RUN / BLOCKED / EXEMPTED with references |
| Residual risk | Description, owner, disposition |
| Closure condition | Required fixes, evidence, or approval still needed |

## 10. Re-review and closure

- After a FAIL, review the correction against the failed criterion and inspect nearby behavior for regressions.
- If the implementation changes an approved boundary, contract, owner, or lifecycle decision, reopen architecture triage and the decision gate before accepting the new design.
- If the change is behavior-only and stays within the approved decision, rerun only the relevant required checks plus regression checks.
- Close only with overall PASS, or leave the review explicitly BLOCKED/FAIL with the missing evidence or corrective owner. Never report a blocked review as completed.

## 11. Relationship to the workflow

The result-review gate is Stage 10 in [Architecture Review Workflow](architecture-review-workflow.md). The workflow owns orchestration and user pauses; this document owns the acceptance criteria and review result statuses.
