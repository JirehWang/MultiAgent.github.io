---
name: personal-tool-evaluator
description: Evaluate a proposed tool, skill, plugin, agent, MCP server, or extension for one person's global Codex environment. Use when deciding whether it belongs in the global environment and a lightweight, evidence-based YES, TRY LOCALLY FIRST, or NO recommendation is needed.
---

# Personal Tool Evaluator

Assess the proposal; do not install it or modify any environment settings unless the user separately asks for installation.

## Gather Minimum Evidence

- Identify the intended use, expected frequency, source, requested permissions, integration points, and practical uninstall or rollback path.
- Compare only the nearest one or two existing tools. Do not inventory the whole global environment.
- Distinguish documented or observed facts from vendor claims and unknowns. Do not assume that missing evidence is safe.

## Check Hard Red Flags

Return `NO` immediately if the proposal:

- Collects or sends credentials, secrets, or personal data unnecessarily.
- Requires unjustified destructive, administrator, or full-disk access.
- Creates an irrecoverable global command, configuration, or routing conflict.
- Has no practical uninstall or rollback path.

## Score the Proposal

Assign 0, 1, or 2 points for each category, for a maximum of 10.

| Category | 0 | 1 | 2 |
| --- | --- | --- | --- |
| Use and frequency | Has no clear personal use or is only exploratory. | Has a specific but occasional or single-project use. | Has frequent or cross-project use. |
| Improvement over existing tools | Existing tools fully cover the need with no meaningful gain. | Adds modest convenience or quality. | Clearly saves steps, improves quality, or fills a real gap. |
| Integration and conflicts | Causes a global command, configuration, routing, or workflow conflict. | Coexists after a documented adjustment. | Coexists with negligible impact. |
| Source and permissions | Has an unverifiable source or requests excessive permissions. | Has partly verified provenance or necessary permissions with some uncertainty. | Has a trustworthy source and proportionate, least-privilege permissions. |
| Reversibility and maintenance | Has no safe practical removal or recovery path. | Can be removed with manual cleanup or upkeep. | Can be disabled, removed, and restored easily. |

## Decide

Apply these rules in order:

1. Return `NO` for any hard red flag, a Use and frequency score of 0, or a total of 0-4.
2. Return `YES` only for a total of 8-10 when every category is at least 1.
3. Return `TRY LOCALLY FIRST` for a total of 5-7, or for a total of 8-10 with a zero in Integration and conflicts, Source and permissions, or Reversibility and maintenance, provided no hard red flag applies.
4. Return `NO` when Improvement over existing tools is 0 even if the total is higher: keep the existing tool instead of adding a redundant global tool.

## State Evidence and Confidence

List the evidence used and label material gaps as unknown. Set confidence to `High` only when source, permissions, closest-tool comparison, and rollback are verified; use `Medium` for bounded uncertainty and `Low` for missing or conflicting information. Never upgrade a decision because of assumptions.

## Use This Report Format

```text
Decision: YES / TRY LOCALLY FIRST / NO
Total: __/10
Confidence: High / Medium / Low

1. Use and frequency: __/2
2. Improvement over existing tools: __/2
3. Integration and conflicts: __/2
4. Source and permissions: __/2
5. Reversibility and maintenance: __/2

Closest comparisons (one or two):
- Tool: overlap and material difference

Evidence:
- Verified:
- Claimed or unknown:

Hard red flags: None / list
Recommendation scope: Add globally / Try in one project first / Do not add
Conditions and rollback:
No installation or configuration changes performed.
```
