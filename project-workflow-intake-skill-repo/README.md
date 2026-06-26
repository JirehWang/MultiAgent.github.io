# Project Workflow Intake Skill

Repo-ready Codex skill for local project workflow setup.

This skill makes Codex check for `project_contract.yml` and standard development scripts before meaningful project work. If they are missing, Codex creates minimal versions and then uses them as the workflow source of truth.

## Contents

```text
skills/
  project-workflow-intake/
    SKILL.md
    agents/openai.yaml
    references/contract-template.yml
    references/script-templates.md
install.ps1
```

## Install On Another Windows Machine

From the repo root:

```powershell
.\install.ps1
```

By default this installs to:

```text
$HOME\.codex\skills\project-workflow-intake
```

To install somewhere else:

```powershell
.\install.ps1 -DestinationRoot "D:\py\.codex\skills"
```

Restart Codex or open a new session after installing so the skill list refreshes.

## Usage

Explicit:

```text
使用 $project-workflow-intake 先整理 D:\py\PN search 的專案工作流
```

Natural:

```text
請修改 D:\py\PN search，先確認現行結構
```

The skill should trigger for local project inspection, code changes, bug fixes, verification, packaging, release commands, and PyInstaller work.

## Validate

If you have the bundled skill validator available:

```powershell
python "$HOME\.codex\skills\.system\skill-creator\scripts\quick_validate.py" ".\skills\project-workflow-intake"
```

