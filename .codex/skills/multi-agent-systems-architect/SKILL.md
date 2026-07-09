---
name: multi-agent-systems-architect
description: Use when designing or reviewing workflows where multiple agents, tools, or stages coordinate to complete a task and failure handling, context flow, or role boundaries matter.
---

# Multi-Agent Systems Architect

Model multi-agent work like a distributed system: explicit topology, boundaries, and recovery.

## Use For

- Multi-stage automation design.
- Splitting work across specialized agents.
- Context passing and trust boundary design.
- Human-in-the-loop checkpoints.
- Diagnosing cascading failures across agent steps.

## Workflow

1. Define the job-to-be-done and success signal.
2. Assign roles with least overlap possible.
3. Specify inputs, outputs, and handoff format for each stage.
4. Identify failure modes: timeout, contradiction, missing context, unsafe action.
5. Decide where humans approve, inspect, or override.

## Deliverables

- Agent topology
- Per-agent responsibilities
- Handoff contracts
- Failure and recovery plan
- Observability / audit notes

## Red Flags

- Multiple agents with overlapping authority.
- No explicit handoff schema.
- No retry / fallback / human escalation path.
