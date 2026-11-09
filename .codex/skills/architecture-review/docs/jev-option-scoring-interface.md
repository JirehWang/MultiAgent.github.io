# Jev Architecture Option Scoring Interface

Status: Draft v0.1  
Scope: Defines the interface contract. The local scorer at `.local-trials/jev-api/jev_architecture_scorer.py` is invoked automatically by the architecture-review workflow when option and data-policy conditions are met.

## 1. Purpose

Use Jev as an advisory evaluator when an architecture review has at least two evidence-backed, viable options. Jev rates how well each option fits the same confirmed requirements and constraints. A local reviewer remains responsible for repository inspection, evidence, explanation, and the final recommendation.

This interface supports the review question format. It does not replace the architecture impact score, user decisions, code review, or tests.

## 2. Separate the signals

Keep these values distinct:

- **Architecture impact score (0–10):** local review score used to choose grill depth.
- **Option fit score (0–4):** Jev's probability-weighted expected rating of one option against the shared rubric. It may be fractional.
- **Jev confidence (0–1):** Jev's stated confidence in that rating. It is not the probability that an option is correct, safe, or approved.
- **Local rationale and uncertainty:** explanation based on inspected repository evidence. This is produced locally and must not be attributed to Jev.

Do not combine these into one score or use them as an automatic approval gate.

## 3. Eligibility and privacy

Score only when all of the following hold:

- There are 2–3 concrete, mutually exclusive, evidence-backed, viable options.
- The options are described against the same user outcome and confirmed constraints.
- The local reviewer has checked each option against confirmed hard constraints. A known violation is a local veto and must not be presented as a viable Jev-scoring candidate; unresolved checks stay marked as unknown.
- The request can be sent under the project's data policy.
- The context has been sanitized.

Return **ineligible** if there are fewer than two comparable viable options or the context is too incomplete to make the options comparable. Return **blocked_by_policy** when external evaluation is not allowed.

Send concise summaries and opaque evidence IDs only. Do not send source code, raw diffs, full file contents, secrets, credentials, customer data, or the full conversation. Keep the mapping from evidence IDs to repository paths, symbols, and tests local.

## 4. Local request contract

Protocol identifier: **architecture-option-score.v1**

Required fields:

| Field | Meaning |
|---|---|
| protocol | Exact protocol identifier above. |
| review_id | Local opaque identifier for correlating this evaluation. |
| question | The unresolved architecture decision being evaluated. |
| outcome | User-visible intended result and explicit scope boundary. |
| constraints | Confirmed constraints, each with a stable ID, statement, and hard or soft strength. |
| facts | Sanitized, evidence-backed architecture facts, each with a stable ID and a verified or inferred evidence status. |
| unknowns | Material unresolved facts or assumptions, each with a stable ID. |
| options | Two or three candidate directions, each with a stable ID, label, concise approach, tradeoffs, a local hard-constraint check (pass or unknown), and references to relevant fact, constraint, or unknown IDs. |
| data_policy.external_evaluation_allowed | Boolean authorization from the applicable project data policy. Must be true to call Jev. |
| data_policy.sanitized | Boolean assertion by the local caller that the request has passed sanitization. Must be true to call Jev. |

IDs must be stable within the request and match this pattern: ^[a-z0-9][a-z0-9_-]{0,31}$. Option IDs must be unique. Evidence IDs may refer to local records; their local path mapping is not sent.

The local caller must first inspect relevant code, contracts, call sites, and tests. Jev evaluates only the supplied facts; it is not a substitute for repository search and must not be asked to invent repository facts.

## 5. Jev API mapping

Use the TypeSafe POST /v1/systemone endpoint through the existing generic Jev client. Keep this scoring adapter separate from the task-routing adapter.

- Put the sanitized outcome, question, constraints, facts, unknowns, and option summaries in state.
- Add one named score question for each option in questions. Use a deterministic local mapping from each option_id to its question name.
- Use the same ordered 0–4 criteria rubric for every option.
- Each question instruction must tell Jev to rate only the named option against the supplied outcome, constraints, facts, and rubric; not to invent repository facts or choose a winner; and to reflect unresolved material assumptions in the rating and confidence.
- Select model through existing configuration or an explicitly approved alias. Do not hard-code a model name into the protocol.
- Submit one batched request for the complete option set so every option receives the same context and rubric.

Rubric, in ascending order:

| Level | Rating guidance |
|---:|---|
| 0 | Violates a confirmed hard requirement or declared architecture rule. |
| 1 | Fails a core requirement or requires a major workaround. |
| 2 | Partially meets the requirements; a material gap, assumption, or tradeoff remains unresolved. |
| 3 | Meets the core requirements with manageable, explicit tradeoffs. |
| 4 | Strongly fits the confirmed needs, reuses an existing capability when its semantics match, respects declared boundaries, and avoids unnecessary structure. |

Apply the rubric to each option independently. Do not reward speculative future needs. A score of 4 means strong fit, not proof that the option is uniquely best.

TypeSafe's score question uses an ordered criteria array whose positions map to integer levels starting at zero. Its score answer contains score, confidence, probabilities, legend, and type; the response also identifies model and token usage. Treat score as the expected score, not as a selected integer class.

## 6. Normalized result contract

Required top-level fields:

| Field | Meaning |
|---|---|
| protocol | architecture-option-score.v1. |
| status | One of scored, ineligible, blocked_by_policy, unavailable, or invalid_response. |
| review_id | The matching local request ID. |
| model | Returned model name when available; otherwise null. |
| usage | Input/output token counts when available; otherwise null. |
| evaluations | One result per submitted option when status is scored; otherwise an empty array. |
| reason | Short local status explanation, when status is not scored. |

Each evaluation contains:

- option_id
- fit_score: finite number in the inclusive range 0–4; preserve fractional precision.
- confidence: finite number in the inclusive range 0–1.
- probabilities: probabilities keyed by all five rubric levels (0 through 4).
- legend: returned level descriptions, retained for audit and checked against the submitted rubric.

The adapter must map answer names back to the original option IDs. Do not expose raw request or response payloads in user-facing review output.

## 7. Validation and failure behavior

A response is invalid_response if any submitted option is missing, duplicated, or has the wrong answer type; a score or confidence is outside its allowed range; probability keys do not cover exactly levels 0–4; probabilities are non-finite, out of range, or fail validation; or the legend does not correspond to the submitted rubric. For v1, probability values must sum to 1 within 0.02, and the expected score must match the weighted mean of the returned distribution within 0.10. These are local adapter tolerances, not TypeSafe guarantees.

A partial option set is not a valid comparison: keep evaluations empty and return invalid_response. Preserve raw provider values only where the existing data policy permits; the user-facing result uses validated normalized values.

Map missing configuration, authentication failure, timeout, rate limit, or provider/network errors to unavailable. Do not silently substitute routing confidence, fabricated values, or a local guess for a Jev score. v1 makes one bounded request and does not retry automatically.

Log only protocol version, model, status, and token usage. Never log credentials, full context, or raw payloads.

## 8. Presentation rules

For each option, show the Jev fit score, Jev confidence, and score-level distribution separately. Show local rationale with evidence references and list material unknowns beside them, clearly labeled as local analysis.

Do not describe Jev confidence as the chance the design is correct. Do not mark an option as recommended solely because its fit score is higher. If the score signal conflicts with repository evidence or user constraints, surface the disagreement and ask the relevant architecture question.

No confidence bands, score thresholds, or automatic winner selection are defined in v1; those require calibration and a later workflow decision.

## 9. Interface example

Local normalized request shape (illustrative; summaries only):

- protocol: architecture-option-score.v1
- review_id: opaque local ID
- question, outcome
- constraints: stable IDs, statements, and hard/soft strength
- facts: stable IDs, sanitized summaries, and verified/inferred status
- unknowns: stable IDs and concise statements
- options: 2–3 stable IDs, labels, approaches, tradeoffs, local hard-constraint checks, and evidence references
- data_policy: external evaluation allowed and sanitized are both true

Normalized scored result shape (illustrative):

- protocol: architecture-option-score.v1
- status: scored
- review_id
- model, usage
- evaluations: option ID, fit score, confidence, probabilities for 0–4, and rubric legend

These are adapter-level normalized shapes. The API wire format remains governed by TypeSafe's schema.

## 10. Decisions reserved for workflow design

Invocation timing, workflow data handling, and presentation in the grill prompt are specified in [Architecture Review Workflow](architecture-review-workflow.md). This interface does not define how Jev scores are calibrated or which confidence levels trigger more questions.

## References

- [TypeSafe OpenAPI schema](https://api.typesafe.ai/openapi.json)
- [TypeSafe ReDoc](https://api.typesafe.ai/redoc)
