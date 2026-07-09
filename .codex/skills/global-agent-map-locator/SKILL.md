---
name: global-agent-map-locator
description: Use when a session needs the workspace-local map of the global agents and global skills, including routing topology and storage location.
---

# Global Agent Map Locator

This is a locator skill for the workspace-local global relationship map.

Primary location:
- `C:\Users\105221\.codex\global-agent-map\global-agent-skill-relationship-map.md`

Machine-readable manifest:
- `C:\Users\105221\.codex\global-agent-map\global-agent-skill-relationship-map.json`

Purpose:
- tell future sessions where the global relationship map lives
- make it explicit that the map is for global agent and skill topology
- provide a stable local reference even if there is no codebase-memory index

Suggested read order:
1. read the markdown map
2. read the JSON manifest
3. if deeper verification is needed, read the global routing files listed in the manifest
