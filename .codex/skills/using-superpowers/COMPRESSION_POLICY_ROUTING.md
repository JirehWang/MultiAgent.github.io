# Compression Policy Routing

Use this reference when the router must decide whether an agent should inherit `headroom`, `caveman`, both, or neither.

## Core Split

- `headroom` manages context pressure.
- `caveman` manages output style pressure.

Do not treat them as interchangeable.

## Decision Order

1. Choose the primary and support agents first.
2. Decide whether the run is tool-heavy, doc-heavy, MCP-heavy, or history-heavy.
3. Decide whether the output should be concise or fully expressive.
4. Return one structured compression policy with reasons.

## Output Schema

```yaml
compression_policy:
  profile:
  headroom:
  caveman:
  reasons: []
```

Allowed values:

- `profile`: `user-facing`, `planner`, `router`, `worker`, `reviewer`, `verifier`, `tool-heavy-worker`
- `headroom`: `on`, `off`
- `caveman`: `off`, `lite`, `full`

## Default Matrix

| Profile | headroom | caveman | Use when |
|---|---|---|---|
| `user-facing` | on | off | Main agent must explain tradeoffs clearly to the user |
| `planner` | on | full | Planning, dispatch, framing, task slicing, handoff setup |
| `router` | on | full | Fast routing notes, exact agent choice, exact next node |
| `worker` | on | off | Code generation, spec writing, deep debugging, artifact production |
| `tool-heavy-worker` | on | lite | Tool output summarization, log triage, doc extraction, MCP-heavy tasks |
| `reviewer` | on | lite | Review findings can be concise, but evidence must remain readable |
| `verifier` | on | lite | Status summary should be short, but raw evidence must not be over-compressed |

## Hard Rules

- Default `headroom` to `on` for all routed agents unless the task is tiny and context-light.
- Default `caveman` to `full` only for router and planner style outputs.
- Use `caveman: lite` for reviewer or verifier summaries, not for raw evidence blocks.
- Use `caveman: off` for final user-facing explanations, code generation, spec writing, PR text, or deep root-cause analysis.
- If the task is both tool-heavy and summary-friendly, prefer `headroom: on` plus `caveman: lite`.
- If the task needs complete artifacts, never let `caveman` override completeness requirements.

## Signal Rules

Turn `headroom` on when any of these are true:

- MCP-heavy
- tool-heavy
- document-heavy
- long session
- RAG or retrieval-heavy
- multi-step execution

Turn `caveman` on when any of these are true:

- routing
- planning
- dispatch
- triage summary
- verification summary
- review summary

Turn `caveman` off when any of these are true:

- final user-facing answer
- code artifact generation
- long-form documentation
- specification writing
- deep debugging narrative

## Examples

```yaml
compression_policy:
  profile: router
  headroom: on
  caveman: full
  reasons:
    - routing
    - summary-friendly
    - not user-facing final output
```

```yaml
compression_policy:
  profile: tool-heavy-worker
  headroom: on
  caveman: lite
  reasons:
    - mcp-heavy
    - tool-output-heavy
    - summary-friendly
```

```yaml
compression_policy:
  profile: worker
  headroom: on
  caveman: off
  reasons:
    - codegen
    - artifact-completeness
    - user-facing deliverable
```
