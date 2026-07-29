---
name: security-scan-contract
description: "Apply a scoped security-scan contract to repositories and changes: choose scan depth, record evidence and coverage, gate remediation, and require re-scan verification. Use for security audits, Codex Security scans, CI security checks, or changes involving auth, secrets, permissions, network access, parsing, or trust boundaries."
---

# Security Scan Contract

Use this contract with `security-auditor`. Treat Codex Security as an optional evidence-producing scanner, not as a replacement for human adjudication.

## 1. Define scope first

Record the repository/worktree root, authorized target, revision or paths, scan mode, output directory, and cost/time budget. Default to the smallest useful scope:

- `--working-tree --base HEAD` for local changes
- `--diff <base> --head HEAD` for committed changes
- path or repository scans for an explicit audit
- `--mode deep` only when broad coverage is required

Do not scan repositories without authorization. Keep results outside the repository in a private directory; results may contain source excerpts and vulnerability details.

## 2. Require evidence and coverage

For every finding, record:

- stable finding ID, title, severity, and confidence
- exact file/line location and root-cause evidence
- reachable attack path, impact, and remediation
- validation status: confirmed, unconfirmed, suppressed, or fixed

Also record coverage as `complete`, `partial`, or `unknown`, including exclusions, deferred work, and open questions. Never claim a repository is ?lean??when coverage is incomplete or unresolved questions remain.

Prefer confirmed or well-supported vulnerabilities. Keep hypotheses separate from findings.

## 3. Close the remediation loop

Use this handoff:

`security-auditor ??code-worker ??tests ??security-auditor re-scan ??verification-before-completion`

Do not claim a vulnerability is fixed until the original finding is revalidated and relevant tests pass. Preserve the finding identity so later scans can classify it as new, persistent, reopened, resolved, or unknown.

## 4. Control cost and CI behavior

Use diff-first scans by default. Limit paths and provide only relevant architecture or threat-model context. Set the scanner? `--max-cost` when available. Local scans may be report-only; CI should fail on scanner errors and findings at or above the explicitly chosen severity threshold, and should preserve JSON/SARIF results.

If the scanner is unavailable, continue with `security-auditor`, state the coverage limitation, and do not imply equivalent scanner evidence.
