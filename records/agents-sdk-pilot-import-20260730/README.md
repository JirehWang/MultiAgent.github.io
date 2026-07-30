# Agents SDK pilot import record

這是供另一台電腦落地使用的可攜式導入紀錄，不代表本公司電腦已完成全域 workflow 導入。

## Files

- `agents-sdk-pilot-import-record-20260730.zip` — portable package containing the pilot source, tests, configuration examples, evidence, and before/after records.
- `agents-sdk-pilot-import-record-20260730.zip.sha256` — SHA256 checksum for the ZIP.
- `global-workflow-rollback-completion-20260730.md` — record of the rollback completed on the original machine.

## Use on another computer

1. Download the ZIP and verify it against the SHA256 sidecar.
2. Extract it outside the global Codex configuration directory first.
3. Read the bundled `README.md`, `ROLLBACK-RECORD.md`, and `TEST-RESULTS.md` before enabling anything.
4. Re-run the verification and real end-to-end tests on the destination computer; the original company-managed machine was blocked by its Windows app-server sandbox policy.

The package excludes credentials, the original machine's global configuration, and its virtual environment.
