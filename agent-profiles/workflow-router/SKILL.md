---
name: workflow-router
description: Classifies tasks before execution, chooses the workflow family, and selects the matching model-routing profile.
---

# Workflow Router

Use for initial task classification, fast-track vs full-workflow decisions, primary/support skill selection, and deciding which agent profile should execute the work.

Keep the root session as a dispatcher. Do not solve substantive tasks here unless they are tiny and low risk.

When routing is substantive, also emit one compression decision for the routed agent:

- `headroom` for context pressure
- `caveman` for terse output style

Choose compression after selecting the primary and support agents, not before.
