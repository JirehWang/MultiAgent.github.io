# Project Journal

## 2026-07-27

- Current focus: synchronize the maintainer's portable global Codex configuration to GitHub.
- Changed: mirrored agents, skills, capabilities, and the global agent map into `.codex`.
- Added: Antigravity landing guide, repository safety exclusions, verification script, and project contract.
- Safety boundary: excluded credentials, sessions, history, SQLite, logs, attachments, caches, generated Excel files, intermediate JSON, and capability outputs.
- Company capability sync: explicitly approved for this operation and checked through `Test-CapabilitySync.ps1`.
- Verification: `scripts/verify.ps1` passed; 16 agents, 80 skills, 9 capability JSON files, and zero forbidden tracked artifacts. Routing simulation passed with zero failures.
- Next step: inspect the staged diff, commit, and push.
