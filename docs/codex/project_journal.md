# Project Journal

## 2026-07-27

- Current focus: synchronize the maintainer's portable global Codex configuration to GitHub.
- Changed: mirrored agents, skills, capabilities, and the global agent map into `.codex`.
- Added: Antigravity landing guide, repository safety exclusions, verification script, and project contract.
- Safety boundary: excluded credentials, sessions, history, SQLite, logs, attachments, caches, generated Excel files, intermediate JSON, and capability outputs.
- Company capability sync: explicitly approved for this operation and checked through `Test-CapabilitySync.ps1`.
- Verification: `scripts/verify.ps1` passed; 16 agents, 80 skills, 9 capability JSON files, and zero forbidden tracked artifacts. Routing simulation passed with zero failures.
- Next step: inspect the staged diff, commit, and push.

## 2026-07-27 — cloud capability cleanup

- Removed all capability entries classified as `company` from the GitHub snapshot.
- Removed their directly owned specialist skills: RoHS PDF analysis, regulatory comparison, Outlook mail analysis, and mail-requirement workflow.
- Kept only `bible-devotional` and `git-github` in the cloud capability registry.
- Retained the company/unknown-context sync blocking policy to prevent future accidental uploads.
- Verification: passed. Seven company targets are absent; cloud registry contains exactly two daily capabilities; removed-company requests fall back to the global skill pool; 16 agents and 77 remaining skills are intact.
