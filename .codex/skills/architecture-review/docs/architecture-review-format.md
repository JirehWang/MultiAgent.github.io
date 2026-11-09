# Architecture Review Format

Status: Draft v0.1

This format classifies a proposed change by its architecture impact, decides how much design discussion is needed, and records the review evidence. The end-to-end orchestration is described in [Architecture Review Workflow](architecture-review-workflow.md).

## Review principles

- Classify the change by its actual impact, not only by whether it constructs, modifies, adds, or deletes something.
- Inspect the repository, existing contracts, architecture notes, call sites, and tests before asking the user questions.
- Grill only on unresolved decisions that could change module ownership, contracts, dependency direction, compatibility, migration, or risk.
- Treat source-code and code-graph observations as evidence of the current implementation. Treat architecture conformance as unknown when the project has not declared the intended rule.
- Prefer reusing an existing capability when its business semantics, side effects, error behavior, and ownership match. Explain why a new implementation is needed when they do not.

## 1. Intake

- Request / intended outcome:
- Operation: Construct / Modify / Add / Delete
- Project and affected area:
- Known consumers or dependents:
- Relevant architecture documents or contracts:
- Existing implementation / reusable candidates:
- Constraints supplied by the user:

## 2. Architecture impact score

Score each dimension from 0 to 2 using repository evidence where possible.

| Dimension | 0 | 1 | 2 |
|---|---|---|---|
| Scope and boundaries | Private implementation within one module | Multiple modules in one application | Public API, service, platform, or external-system boundary |
| Contract and data | No interface or data-shape change | Internal interface or behavior changes | Public API, shared schema, database, or event contract changes |
| Ownership and dependencies | Owner and dependency direction remain clear | Existing module responsibility expands or is uncertain | New shared capability, module/service boundary, or dependency direction |
| Compatibility and lifecycle | Reversible; no consumer or stored-data impact | Existing behavior or consumers may be affected | Breaking change, deletion of shared behavior, or data migration required |
| Risk and uncertainty | Low impact; assumptions verified | Material assumptions remain or impact is moderate | Security, privacy, critical business/data risk, or a critical design choice is unresolved |

Total: __ / 10

| Total | Review depth | Action |
|---:|---|---|
| 0–2 | No formal grill | Inspect reuse candidates and tests, then proceed within established boundaries. Record material assumptions. |
| 3–5 | Focused grill | Ask only the unresolved questions that could change this design. |
| 6–10 | Full architecture grill | Clarify module responsibilities, contracts, dependencies, lifecycle, risks, and acceptance checks before implementation. |

### Override triggers

At minimum, perform a focused grill regardless of the total when a change:

- Adds, changes, versions, or removes a public or cross-service contract.
- Changes a shared data model, persisted schema, or event format.
- Adds a service or shared capability, or changes permitted dependency direction.
- Deletes a shared/public function, interface, endpoint, event, or data field with consumers.
- Changes authentication, authorization, privacy, tenant boundaries, or another high-impact business rule.

Escalate to a full grill when ownership, compatibility, migration, or rollback is unresolved, or the change crosses multiple independently owned systems.

### Goldfish reviewer matrix

Goldfish runs only for a focused/full architecture grill or when the user explicitly requests an independent design review. Existing impact score and override triggers continue to choose review depth; this matrix selects the lenses that inspect each concern and adds no separate severity score. An explicit independent-review request triggers at least a focused Goldfish review; run the full review when the user asks for it or impact conditions require a full grill. Every triggered review includes `Zoom Out`, `Comprehension`, and `Design Critic`; add only the minimum conditional roles selected by non-zero dimensions and artifact requirements, deduplicating roles that cover multiple dimensions.

| Dimension / condition | Triggered role | Review scope and boundary |
|---|---|---|
| Every Goldfish review | `Zoom Out`, `Comprehension`, `Design Critic` | `Zoom Out` checks scope, YAGNI, simplicity, visible reuse opportunities, and whether the design stays at the right architectural level; it does not claim a complete source search. `Comprehension` checks that the packet is self-contained and understandable without prior conversation. `Design Critic` stress-tests design logic, assumptions, tradeoffs, failure modes, and material risks; for greenfield work it assesses proposed boundaries from the proposal. None chooses for the user. |
| Scope/boundaries > 0, ownership/dependencies > 0, or the decision depends on current-code behavior/consumer/reuse claims; existing code is available | `Codebase Details` | Verify affected modules, callers, current owners, dependency direction, code behavior, consumers, and reusable implementation against source evidence. Do not run this persona for greenfield work without code; `Zoom Out` / `Design Critic` still assess the proposal, while repository-only facts are `UNKNOWN`. |
| Contract/data > 0, or an implementation-readiness review / actual implementer handoff is explicitly requested | `Implementation Readiness` | Check interface/data semantics, errors and side effects, required implementation boundaries, migration steps where applicable, tests, and acceptance criteria. Do not infer a handoff just because a design may eventually be implemented. |
| Compatibility/lifecycle > 0 and existing consumers, persisted data, or code are involved | `Codebase Details`; add `Implementation Readiness` when concrete migration, rollout, rollback, or handoff steps must be actionable | Check backward compatibility, migration, deprecation, rollback, and dual-run plans. A breaking change is at least focused; unresolved migration/rollback ownership requires a full grill. |
| Risk/uncertainty > 0 | `Design Critic` (baseline role, scoped to risk) | Make assumptions, failure impact, mitigations, and human risk decisions explicit. For security, authorization, privacy, or tenant boundaries, also run the existing `security-auditor`; for regulatory/compliance concerns, run `compliance-deep`. Goldfish does not replace these domain reviews. |
| Public/cross-service API, event, or shared schema | `Implementation Readiness` when contract/data semantics are in scope; `Codebase Details` when current consumers or code must be checked | Ensure the spec includes contract and consumer context. Also run existing `api-contract-guardian` / API contract governance for compatibility and provider/consumer impact; Goldfish alone cannot establish a contract pass. |
| A required template, required sections, or machine-readable schema applies | `Structural Validator` | Check only the required format, structure, and fields; do not elevate style preferences into design defects. |
| Document clarity is an acceptance condition, or `Comprehension` finds ambiguity that could change meaning | `Style Editor` | Check wording, references, and consistency that affect understanding. Do not trigger Goldfish for proofreading alone. |

Full review follows the ordered Goldfish stages: initial `Zoom Out`, `Comprehension`, `Design Critic` (plus conditional structure/style checks), then an intermediate `Zoom Out` only if selected reviewer feedback was applied to revise the decision packet, followed by `Implementation Readiness` and `Codebase Details` only when their matrix conditions apply. The intermediate pass checks the revised packet and that change set; record it as `NOT_APPLICABLE` if no revision occurred. `Synthesizer` is an aggregation step, not a design decision-maker. It deduplicates findings while preserving evidence-backed disagreement, `UNKNOWN` items, and open questions; it must not silently discard reviewer findings or choose for the user. A `standard`, `multi_stage`, or `high_risk` validation tier alone does not add Goldfish roles; use the architecture score, overrides, and actual design artifact.

## 3. Operation-specific signals

| Operation | Usually no full grill | Focused or full grill signals |
|---|---|---|
| Construct | Throwaway prototype or isolated utility with no lasting integration | Long-lived product, multiple modules, shared data, deployment boundary, or external integration |
| Modify | Internal implementation changes while owner, interface, invariants, and dependencies stay stable | Contract semantics, data ownership, shared behavior, or dependency direction changes |
| Add | Local capability in an existing owner module after checking for reusable code | New endpoint, shared capability, module/service, persistent model, or external dependency |
| Delete | Private code proven unused by search, references, and tests | Shared/public behavior, active consumers, stored data, migrations, deprecation, or compatibility risk |

## 4. Grill question bank and option design

Ask only questions that repository evidence cannot answer and whose answers could affect the design. Before asking, inspect the repository and turn the plausible design directions into clear options.

### Ask with options

- Offer 2–3 plausible, mutually exclusive options for each unresolved decision. Derive them from repository evidence, user constraints, and actual tradeoffs; do not invent choices just to fill a list.
- Put the recommended option first and mark it **(Recommended)** when evidence supports a recommendation. If evidence does not distinguish the options, say so and leave them unranked.
- State each option's expected behavior, architecture impact, and main tradeoff in a short sentence. Include a free-text **Other / specify** path.
- Ask one architecture decision at a time, or group only decisions that are tightly coupled.
- If only one viable direction remains, explain why and ask only for the user decision that is still needed.

Typical decision dimensions are outcome and scope; existing owner versus a new owner; reuse as-is versus extend versus a separate implementation; backward-compatible versus versioned contract changes; permitted dependency edges; deprecation/migration strategy; risk and quality tradeoffs; and acceptance checks. Tailor the actual choices to the project.

### Jev confidence reference

- Keep the architecture impact score in Section 2 separate from confidence in a design option. The impact score selects grill depth; an option-confidence signal is supporting evidence for choosing among directions.
- The draft option-scoring interface is documented in [jev-option-scoring-interface.md](jev-option-scoring-interface.md). It defines a 0–4 option-fit score, 0–1 confidence in that score, and the distribution across score levels. Preserve these as separate signals.
- A dedicated local scorer exists at `.local-trials/jev-api/jev_architecture_scorer.py` and is automatically invoked by the workflow when eligible options and data-policy conditions are met. If it is ineligible, blocked, unavailable, or returns an invalid response, record option scoring as **Unavailable**. The separate routing adapter's confidence is not a design score; never relabel it or invent a Jev score.
- Jev does not return repository-grounded rationale in this interface. The local reviewer supplies rationale and uncertainties from inspected evidence, labeled as local analysis. Jev results remain advisory and do not approve a design or replace the user's choice.

### Option template

**Decision needed:** [unresolved question]

Repository evidence: [paths, symbols, contracts, call sites, or tests]

- **A. [Direction] (Recommended)** — [expected behavior and tradeoff]. Jev fit: [0–4 or Unavailable]; Jev confidence: [0–1 or Unavailable]; local rationale: [brief evidence].
- **B. [Direction]** — [expected behavior and tradeoff]. Jev fit: [0–4 or Unavailable]; Jev confidence: [0–1 or Unavailable]; local rationale: [brief evidence].
- **Other / specify:** [free-text choice]

1. **Outcome:** What user-visible behavior must change, and what is explicitly out of scope?
2. **Ownership:** Which module owns this business capability? Is there an existing function or service with matching semantics?
3. **Reuse:** Which candidate functions, call sites, and tests were inspected? If none will be reused, what semantic or lifecycle difference justifies a new implementation?
4. **Contract:** What are the input/output shapes and meanings, errors, authorization, side effects, and version-compatibility requirements?
5. **Dependencies:** Which modules may call this capability? Does the proposal add a dependency or reverse an existing dependency direction?
6. **Lifecycle:** What happens to existing consumers and stored data? Is migration, deprecation, rollback, or dual support needed?
7. **Risk and quality:** What security, privacy, performance, availability, and failure behavior must hold?
8. **Acceptance:** Which unit, integration, contract, architecture, and duplication checks demonstrate success?

The grill is complete when the owning module, intended reuse/new implementation decision, affected contracts, allowed dependency changes, compatibility plan, and measurable acceptance checks are clear. Record unresolved items as assumptions or risks rather than silently choosing a design.

## 5. Review result

### Decision

- Review depth: No formal grill / Focused grill / Full architecture grill
- Architecture conformance: PASS / FAIL / UNKNOWN
- Score: __ / 10
- Summary:

### Evidence

- Existing architecture rules/contracts:
- Affected modules, consumers, providers, and dependency edges:
- Relevant paths, symbols, call sites, and tests:
- Reusable candidates and decision:

### Contract and lifecycle impact

- Input/output and semantic behavior:
- Error, authorization, and side-effect behavior:
- Compatibility, migration, deprecation, and rollback:

### Required checks

- [ ] Existing implementation and call sites searched
- [ ] Reuse decision supported by file/symbol evidence
- [ ] Contract/schema checks
- [ ] Consumer/provider or integration checks
- [ ] Architecture dependency/cycle checks
- [ ] Duplicate-code check on newly introduced clones
- [ ] Relevant behavior, security, and failure-path tests

### Open questions / assumptions

- User questions that materially affect the design:
- Assumptions and how they will be verified:
- Risks accepted or requiring follow-up:

### Outcome

- [ ] Proceed within current architecture
- [ ] Revise the design and review again
- [ ] Defer pending a named decision or dependency
- Follow-up owner / item:
