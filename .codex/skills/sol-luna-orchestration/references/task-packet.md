# Astra–Luna Task Packet and Acceptance Contract

The path remains `sol-luna-orchestration` for compatibility; Astra is the effective
control/planning/evaluation role.

Use this packet only for delegated or independently reviewed work. Clear, bounded,
low-risk direct work uses the lighter evidence record in
`using-superpowers/agent-routing-rules.yaml`. Astra completes the packet before dispatch;
the executor cannot change its architecture or standards.

```yaml
architecture:
  objective: <observable outcome>
  decomposition: [<bounded slice>]
  dependencies: []

executor_selection:
  selected_executor_role: <luna | sol_complex | selected semantic role>
  selected_runtime_model: <inherit-global | gpt-6-luna | gpt-6.1-sol | explicit user model>
  selection_reason: <why this executor fits>
  sol_eligibility:
    bounded_scope: <true|false>
    explicit_output: <true|false>
    complex_coding_or_agentic_workflow: <true|false>
    architecture_and_acceptance_standards_resolved: <true|false>
    luna_not_fit_or_not_preferred: <true|false>
    gpt_6_1_sol_not_assigned_as_acceptance_runtime_for_same_packet: <true|false>
  luna_eligibility:
    bounded_scope: <true|false>
    explicit_output: <true|false>
    low_ambiguity: <true|false>
    repeatable_or_batch_like: <true|false>
    material_aggregate_workload_benefit: <true|false>

dispatch_contract:
  execution_required: <true|false>
  exemption: <none | control-only>
  runtime_overlay:
    mode: <luna-only | sol-complex | inherit-global>
    controller: astra
    executor:
      agent_type: worker
      model: <inherit-global | gpt-6-luna | gpt-6.1-sol | explicit user model>
      reasoning_effort: <inherit-global | low | medium | high | max>
    acceptance_owner: <acceptance_process | qualified_domain_reviewer>
    acceptance_runtime:
      agent_type: worker
      model: <gpt-6.1-sol when owner is acceptance_process | qualified reviewer model when assigned>
      reasoning_effort: high
    alternate_executor: <none | selected_sol_complex_or_semantic_executor_when_luna_ineligible>
  global_contract:
    validation_tier: <inherit-global | basic | standard | multi_stage | high_risk>
    required_gates: [<inherit-global | normalized gate>]
    required_artifacts: [<inherit-global | normalized artifact>]
    normalizer_source: global.validation_tier_normalization
    normalized: <true|false>

ownership:
  allowed_paths: []
  forbidden_paths: []
  responsibility: <bounded responsibility>

constraints: []

acceptance_standards: # written by Astra before execution
  - id: <standard-id>
    requirement: <observable pass condition>
    required_evidence: <command output, artifact inspection, or test>

execution_return:
  changed_files: []
  produced_artifacts: []
  verification_evidence: []
  gaps: []

acceptance:
  owner: <acceptance_process | qualified_domain_reviewer>
  runtime: { agent_type: worker, model: <gpt-6.1-sol | qualified reviewer model>, reasoning_effort: high }
  decision: <pass|retry|rollback>
  standard_results: []
  reasons: []
```

Dispatch rules:

- Astra completes global tier normalization after route selection and before delegated dispatch. The normalized `validation_tier`, `required_gates`, and `required_artifacts` are part of the dispatch contract.
- The worker must not modify the dispatch contract, its normalized tier, its required gates, or its required artifacts.
- When a delegated packet has `execution_required: true`, dispatch is rejected if any required dispatch-contract field is missing, including any required nested runtime or global-contract field.
- The independent acceptance process runs on GPT-6.1-Sol or uses a qualified domain reviewer to return the `pass`, `retry`, or `rollback` decision for the packet. Astra may dispatch a retry only from review findings; implementers never self-accept.
- GPT-6.1-Sol may execute a bounded complex engineering packet only when GPT-6.1-Sol is not also its acceptance runtime. If independent review is required after Sol execution, assign a qualified reviewer distinct from GPT-6.1-Sol.
- A control-only request may explicitly declare `execution_required: false` with `exemption: control-only`; that exemption does not authorize production execution and must be recorded in the packet.

Luna and GPT-6.1-Sol implementers may report facts and gaps, never acceptance on their own
work. The independent reviewer applies each standard and owns the decision. Direct work must still record source or input inspection,
relevant behavior/output verification, current artifact or answer identity, environment
and dependency fingerprint, and verification scope.

## Child Packet Handoff

SDD uses this packet schema for every child; it does not introduce a child schema or
dependency.

- Before delegated dispatch, Astra validates the parent contract and completes global validation
  normalization. The child receives the normalized contract with no silent downgrade.
- The child clones the parent's complete `dispatch_contract` exactly:
  `execution_required`, `runtime_overlay`, and `global_contract`. The child may narrow
  only `objective`, `decomposition`, `ownership`, `constraints`, and
  `acceptance_standards`; it cannot rewrite runtime, `validation_tier`, gates,
  artifacts, or `acceptance_owner`.
- A missing or invalid parent or child contract is `contract-invalid`; escalate and do
  not apply defaults.
- Implementer returns execution evidence only. The independent acceptance process or qualified domain reviewer
  returns the `pass`/`retry`/`rollback` decision.
- Keep child decomposition bounded. Dispatch children serially when they share a file.
