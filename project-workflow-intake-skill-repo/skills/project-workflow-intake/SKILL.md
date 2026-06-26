---
name: project-workflow-intake
description: Use when starting work on any local project or repository, including inspecting structure, modifying code, fixing bugs, adding features, verifying outputs, packaging with PyInstaller or other release tools, or preparing handoff commands. This skill ensures the project has a project_contract.yml and standard development scripts, creates minimal versions when missing, then treats them as the workflow source of truth.
---

# Project Workflow Intake

Use this as the first project-local step before meaningful code, verification, packaging, or release work.

## Core Rule

Do not let missing project workflow files stay invisible. When a local project lacks `project_contract.yml` or standard scripts, create a minimal version before making substantive project changes, unless the user explicitly asks not to create files.

## Workflow

1. Identify the project root.
   - Prefer the user-specified path.
   - If the user points to a file, use its containing project directory.
   - If unclear, use the current workspace root only after checking nearby files.

2. Check for `project_contract.yml` in the project root.
   - If present, read it before planning or editing.
   - If missing, create a minimal contract using `references/contract-template.yml`.
   - Fill known facts from the project: entry points, specs, scripts, input/output folders, risk notes.
   - Use `TODO:` placeholders when a value is not safely knowable.

3. Check for standard scripts.
   - Required for active code projects: `scripts/verify.ps1`
   - Required when packaging or release is relevant: `scripts/package.ps1`
   - Optional when fixtures exist or outputs need comparison: `scripts/smoke_test.py`, `scripts/compare_golden.py`
   - If missing and the project has enough information, create minimal scripts from `references/script-templates.md`.
   - If details are unclear, create scripts with safe TODO comments and non-destructive checks only.

4. Continue the requested task using the contract.
   - Verification commands should come from `project_contract.yml` when available.
   - Packaging commands should come from `project_contract.yml` or the project spec file.
   - Risk notes in the contract should shape the plan, tests, and final answer.

5. Update the contract when discovering durable project facts.
   - Add newly confirmed entry points, spec paths, verify commands, package commands, data directories, and known risks.
   - Do not add guesses as facts; mark uncertain items as `TODO:`.

## Minimal Contract Fields

Every new contract should include:

- `project`
- `root`
- `entrypoints`
- `data_dirs`
- `verify_commands`
- `package_commands`
- `standard_scripts`
- `risk_notes`
- `last_reviewed`

Read `references/contract-template.yml` when creating or repairing a contract.

## Standard Scripts

Use PowerShell for Windows project scripts unless the project already uses another runner.

- `scripts/verify.ps1`: compile, smoke test, or inspect representative outputs.
- `scripts/package.ps1`: run packaging only after verification, or clearly state the manual command.

Read `references/script-templates.md` when creating scripts.

## When To Keep It Lightweight

For tiny read-only questions, do not create files unless the user asks to continue into implementation, verification, packaging, or release work.

For mature projects with existing reliable scripts, do not replace them. Add missing contract references to the existing scripts instead.

## Final Response Expectations

When this skill creates or updates workflow files, mention:

- which contract or scripts were created or updated
- what facts were filled in
- what remains marked as `TODO:`
- how future Codex tasks should use them

