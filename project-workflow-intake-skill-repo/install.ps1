param(
    [string]$DestinationRoot = "$HOME\.codex\skills"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $repoRoot "skills\project-workflow-intake"
$destination = Join-Path $DestinationRoot "project-workflow-intake"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Cannot find skill source: $source"
}

New-Item -ItemType Directory -Force -Path $DestinationRoot | Out-Null

if (Test-Path -LiteralPath $destination) {
    $backup = "$destination.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Move-Item -LiteralPath $destination -Destination $backup
    Write-Host "Existing skill backed up to: $backup"
}

Copy-Item -LiteralPath $source -Destination $DestinationRoot -Recurse -Force

Write-Host "Installed project-workflow-intake to: $destination"
Write-Host "Restart Codex or open a new session to refresh available skills."

