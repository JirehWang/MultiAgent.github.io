---
name: sol-luna-orchestration
description: Use for substantive work requiring Astra planning, eligible Luna or Sol execution, and a separate acceptance process. The sol-luna-orchestration path is retained for compatibility.
---

# Astra–Luna Orchestration and Independent Acceptance

This skill keeps the compatibility identifier `sol-luna-orchestration`; its effective
controller and evaluator are Astra.

Use this overlay for explicit delegation or review, high-risk or ambiguous work,
material cross-boundary changes, and stronger domain contracts. Clear low-risk work may
stay in the current model under the direct path in `agent-routing-rules.yaml`.

The three layers are:

1. **Astra — control:** frame the architecture, ownership, executor, and observable
   acceptance standards.
2. **Luna, GPT-6.1-Sol, or the selected semantic executor — execution:** perform the
   bounded packet and return artifacts plus evidence. Luna handles eligible repeatable
   work; GPT-6.1-Sol handles bounded complex engineering after scope and standards are set.
3. **Independent acceptance:** the acceptance process runs on GPT-6.1-Sol or uses a qualified domain reviewer. It applies the standards and returns `pass`, `retry`, or `rollback`.

Astra does not implement delegated work, interpret execution evidence, or make the final
acceptance decision. Luna never self-accepts. GPT-6.1-Sol must not execute and accept the same
packet; when Sol executes, use a qualified independent reviewer if review is required.
Workers do not restart routing or create unsolicited subdelegation. If the user forbids
subagents, keep the work in the current model, retain applicable safeguards, and record the
unavailable independent check.

## Required flow

```text
Astra: frame → select executor → define standards
Executor: execute bounded packet → return artifact + evidence
Acceptance process (GPT-6.1-Sol): apply standards → pass / retry / rollback
Astra: retry only from the review findings
```

For GPT-6.1-Sol execution, require bounded scope, explicit output, resolved architecture
and acceptance standards, and no same-packet GPT-6.1-Sol acceptance. Otherwise use Luna
when its aggregate-workload guard passes or retain the selected semantic executor. An
explicit user model request is preserved unless a stronger domain or safety contract prevents it.

## Luna runtime

Use Luna when scope and owner are bounded, output is explicit, ambiguity is low, work is
repeatable or batch-like, and aggregate volume materially improves cost, latency, or
throughput. Keep small one-off work on the direct route when dispatch overhead outweighs
the benefit.

```yaml
agent_type: worker
model: gpt-6-luna
reasoning_effort: medium
fork_context: false
```

## Acceptance process runtime

When policy requires independent acceptance, use GPT-6.1-Sol as the acceptance process runtime. The reviewer receives the original standards, execution output, verification
evidence, changed-artifact list, and risk gates; it never implements the fix.

```yaml
agent_type: worker
model: gpt-6.1-sol
reasoning_effort: high
fork_context: false
```

## Packet contract

Use [references/task-packet.md](references/task-packet.md). Astra completes
`architecture`, `executor_selection`, and `acceptance_standards` before delegated
dispatch. A packet must include objective, ownership, constraints, evidence, and return
contract; direct work can use the lighter evidence record in the canonical YAML.

## Completion gate

Delegated work is accepted only when:

- Astra has stated observable acceptance standards before execution;
- the selected executor returned concrete evidence;
- the independent acceptance process applied those standards and returned `pass`; and
- Astra only communicates or dispatches the next bounded task, without replacing the
  independent reviewer's judgment.

Run the contract check after modifying this stack:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/Test-SolLunaRouting.ps1 -SkipCapabilities
```
