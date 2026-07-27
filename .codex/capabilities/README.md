# Capabilities Tree

This directory is the global capability registry for specialized skills, related docs, and future assets.

## Classification and sync policy

Capabilities are classified in `sync-policy.json`:

- `company`: company-use material; cloud sync is blocked unless the user explicitly approves that sync.
- `daily`: daily-use material; cloud sync is allowed by default.

This GitHub snapshot contains only capabilities classified as `daily`.
Company capability definitions and their directly owned specialist skills are intentionally absent.

Cloud-sync operations must run `scripts\Test-CapabilitySync.ps1` before pushing capability content. Company capabilities, company repository/data context, and unknown context require explicit approval for that specific sync. A capability categorized as `daily` does not override company context.

This directory currently has no Git repository or GitHub remote, so no cloud sync is performed automatically here.

Goals:
- group specialized skills by domain
- keep a stable tree structure for future expansion
- make capability discovery faster than scanning all skills flat

Core idea:
- each first-level folder is a capability domain
- each capability domain can contain its own skill links, docs, and assets
- the root registry and schema define the shared structure

Dispatch idea:
- the top-level router should discover this tree through a shared registry contract, not by hardcoding personal domains
- a capability may expose either a direct skill entrypoint or its own delegated router/orchestrator
- capability-local routing logic stays inside the capability, while the top-level router only follows the shared dispatch contract
