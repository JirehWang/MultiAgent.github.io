# Specialized Capability Discovery

This file defines the portability contract between the top-level `using-superpowers` router and any user- or org-specific specialized capability pack.

## Goal

Keep `using-superpowers` portable.

The global router should know:
- how to discover specialized capabilities
- how to decide whether a capability is relevant
- how to enter that capability safely

The global router should not hardcode:
- one person's specialist domains
- one person's private agent names
- one person's capability folder layout beyond the shared registry contract

## Discovery Contract

When specialized capability routing is needed, read:

1. this file
2. the capability registry declared by the environment or install
3. the capability tree schema that validates the registry shape

Preferred registry source:
- the installed capability registry referenced by the local environment

Fallback behavior:
- if no capability registry is present, unreadable, or validly structured, continue with the normal global skill pool
- absence of a capability registry is not an error

## Registry Contract

The registry must describe capabilities as discoverable overlays, not as global-router edits.

Each capability should declare:
- stable `id`
- human-readable `title`
- `purpose`
- matching hints such as `domain_signals` and optional artifact hints
- a `dispatch` block describing how the router should enter the capability

## Dispatch Modes

Supported dispatch modes:

### `direct-skill`

Use when the capability can be entered by selecting a normal skill as the primary agent.

Expected fields:
- `dispatch.mode`
- `dispatch.primary_owner`
- optional `dispatch.support_agents`
- optional `dispatch.entry_skills`

### `delegate-router`

Use when the capability has its own local router or orchestrator and the top-level router should hand off instead of embedding that logic globally.

Expected fields:
- `dispatch.mode`
- `dispatch.primary_owner`
- at least one of:
  - `dispatch.router_asset`
  - `dispatch.router_doc`
  - `dispatch.entry_skills`
- optional `dispatch.support_agents`
- optional `dispatch.handoff_notes`

In `delegate-router` mode, the top-level router should:
1. select the capability's declared `primary_owner`
2. treat the capability as the chosen specialist path
3. carry forward the capability router asset or router doc as the next routing reference
4. avoid re-implementing that capability's private dispatch logic in `using-superpowers`

## Matching Rules

Capability hits are:
- preferred when the fit is clear
- not exclusive
- allowed to lose to a narrower non-capability specialist if the artifact fit is better

The top-level router should use the registry as an overlay layer:

1. infer artifact
2. infer domain signals
3. check capability registry for matches
4. if a clear capability match exists, follow its `dispatch` contract
5. otherwise fall back to the normal global skill pool

## Portability Rule

Portable global routing logic belongs in `using-superpowers`.

User- or org-specific specialist definitions belong in:
- the capability registry
- capability-local docs
- capability-local router assets

Do not copy private specialist-domain details back into the portable top-level router unless they become true global defaults.
