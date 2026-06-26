# Standard Script Templates

Use these as minimal, safe starting points. Replace TODO values with project-specific commands from `project_contract.yml`.

## scripts/verify.ps1

```powershell
$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot\..

Write-Host "Running project verification..."

# TODO: Replace with project-specific verification from project_contract.yml.
# Examples:
# python -m py_compile .\main.py
# python .\scripts\smoke_test.py

Write-Host "Verification script is a placeholder. Fill verify_commands in project_contract.yml."
```

## scripts/package.ps1

```powershell
$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot\..

Write-Host "Run verification before packaging."
& "$PSScriptRoot\verify.ps1"

# TODO: Replace with project-specific package command from project_contract.yml.
# Example:
# pyinstaller ".\app.spec" --noconfirm

Write-Host "Packaging script is a placeholder. Fill package_commands in project_contract.yml."
```

## Notes

- Keep scripts non-destructive by default.
- Do not delete `build/` or `dist/` unless the user explicitly approves cleanup.
- Preserve project-specific recursion limits, startup timeouts, hidden imports, and environment variables in `project_contract.yml`.

