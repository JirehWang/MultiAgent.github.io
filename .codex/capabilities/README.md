# Capabilities Tree

This directory is the global capability registry for specialized skills, related docs, and future assets.

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
