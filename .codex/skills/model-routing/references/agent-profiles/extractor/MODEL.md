# extractor Runtime Policy

This profile does not pin a model or reasoning effort. Resolve both from
`skills/using-superpowers/agent-routing-rules.yaml#model_effort_policy` and the
inherited `dispatch_contract`.

- Direct work inherits the current model and effort.
- Delegated work uses the runtime and effort selected by the route.
- A semantic profile defines role and constraints only; it must not override the routed runtime.
- Explicit user model or effort requests remain subject to safety and domain contracts.
