# Operating Cycle

## Purpose

Use this reference when running the governor as the top-level project delivery owner.

## Cycle

1. refresh project objective
2. refresh architecture SSOT
3. refresh task wall
4. scan blocker parking
5. choose next ready task
6. route or execute
7. verify
8. apply state gate
9. update governance artifacts
10. loop or escalate

## Artifact Meanings

- architecture SSOT: the current project boundary, subsystem map, entry points, delivery objective, and assumptions the workflow is allowed to trust
- task wall: the active board of executable units
- blocker parking: blocked units with evidence, unblock condition, and re-entry rule
- state gate: the proof threshold required before status promotion

## Delegation Rule

Delegate local work freely, but do not delegate the responsibility for:

- choosing the next task
- determining blocker parking state
- deciding whether a state transition is allowed
- maintaining the SSOT

## Promotion Rule

Promote task or milestone state only when:

- the target artifact exists
- required checks were actually run
- blockers were updated
- task wall status is synchronized
- architecture impact was recorded if relevant
