$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $repoRoot 'skills'
$target = Join-Path $env:USERPROFILE '.codex\skills'

if (-not (Test-Path -LiteralPath $source)) {
  throw "Missing skills directory: $source"
}

New-Item -ItemType Directory -Force -Path $target | Out-Null

Get-ChildItem -LiteralPath $source -Directory | ForEach-Object {
  $destination = Join-Path $target $_.Name
  New-Item -ItemType Directory -Force -Path $destination | Out-Null
  Get-ChildItem -LiteralPath $_.FullName -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $destination -Recurse -Force
  }
}

Write-Host "Installed skills into $target"
