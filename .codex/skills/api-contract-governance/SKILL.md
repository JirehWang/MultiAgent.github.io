---
name: api-contract-governance
description: Use when API endpoints, payload formats, or integration boundaries shared by multiple applications, services, or platforms are changing or need a conformance review.
---

# API Contract Governance

Use this workflow to map the affected code relationships, compare them with the project's intended architecture, and verify endpoint contracts after a cross-system change.

## Workflow

1. Identify the project boundary, affected applications/services, endpoint specifications, and architecture rules already in the repository. Prefer existing contracts, ADRs, architecture docs, and native architecture tests.
2. If the `codebase_memory` MCP is available, check that its project index is current and sufficiently complete, then use its graph for the system-level map. Use `codegraph` for symbol/call paths only when that MCP is available. Otherwise inspect the source and project-native dependency tools; state the coverage limitation.
3. Produce a small Mermaid graph of the affected consumers, providers, modules, adapters, contracts, and observed dependency edges. Cite source paths or symbols for important edges. Avoid dumping a whole-repository file graph when a bounded slice answers the question.
4. Compare the observed graph with the declared architecture. Compare each changed API against its source-of-truth contract, including path, method, version, request/response schemas, headers/auth, errors, and platform-specific serialization where applicable.
5. After edits, refresh the graph if available and inspect the changed edges. Run existing project checks that apply: contract lint (for example Spectral), breaking-change comparison (for example oasdiff), consumer/provider contract verification (for example Pact), schema-driven runtime checks (for example Schemathesis), and native architecture tests. Do not install tools or call an unapproved live endpoint.
6. Report the diagram, affected consumers/providers, check results, evidence, graph/spec coverage, and remaining gaps.

## Conformance rules

- Treat an extracted code graph as evidence of the current implementation, not as the intended architecture.
- If no architecture contract or rule says which dependency edges are allowed, mark architectural conformance UNKNOWN. Offer a short proposed rule set for review instead of silently treating the current graph as the standard.
- Keep the canonical internal model separate from platform wire formats. Put required format conversions in explicit adapters and verify both sides of the adapter.
- A passing schema lint does not prove the running service matches the schema; a passing architecture test does not prove business behavior. Report each evidence layer separately.
- Use only MCP servers already available in the current environment. Do not upload repository source to remote services. If an expected MCP is unavailable, continue with source inspection and disclose that fact.
- Do not persist generated diagrams or rewrite architecture docs unless the user requests it or the repository convention requires it.

## Verdict format

For each applicable contract or boundary rule, return `PASS`, `FAIL`, or `UNKNOWN`, followed by the evidence and any coverage limitation. Include a Mermaid diagram when relationships materially affect the change.
