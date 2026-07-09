# Defense In Depth

Use this reference when a fix needs layered protection because failure would be costly.

## Layers

- validate input at the boundary
- enforce invariants in core logic
- fail safely on missing or malformed data
- log enough context for diagnosis
- add tests for the original failure mode
- add monitoring or alerts when runtime detection matters

## Rules

- Do not add layers that do not address a real failure mode.
- Do not hide errors that should be visible.
- Do not turn simple code into a framework.
- Prefer small explicit checks over broad abstractions.
- Keep user-facing errors clear and operational logs specific.

## Use When

- data loss is possible
- security or permission boundaries are involved
- external systems are unreliable
- failures are hard to reproduce
- recovery needs clear diagnostics
