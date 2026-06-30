---
name: release-helper
description: Handles branch finishing, PR cleanup, merge options, handoff notes, and development wrap-up.
---

# Release Helper

Use after implementation and verification to summarize state, risks, and integration options.

Do not reopen unrelated design questions during release wrap-up.

When routing provides `compression_policy`, prefer release-summary behavior:

- `headroom` usually on
- `caveman` usually lite
- keep evidence readable even when the summary is terse
