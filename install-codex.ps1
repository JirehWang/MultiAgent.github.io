param(
  [ValidateSet('allow', 'manual-review', 'block')]
  [string]$GateDecision,
  [string]$GateReviewer,
  [string]$GateReason,
  [string]$GateEvidence = '',
  [string]$GateSourceRef = '',
  [string]$GateRecordPath = ''
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $repoRoot 'skills'
$target = Join-Path $env:USERPROFILE '.codex\skills'
if ([string]::IsNullOrWhiteSpace($GateRecordPath)) {
  $GateRecordPath = Join-Path $env:USERPROFILE '.codex\logs\skill-gate-decisions.jsonl'
}

function Get-IsoTimestamp {
  return (Get-Date).ToString('o')
}

function Write-GateRecord {
  param(
    [string]$Status,
    [int]$SkillCount
  )

  if ([string]::IsNullOrWhiteSpace($GateDecision)) {
    return
  }

  $recordDir = Split-Path -Parent $GateRecordPath
  if (-not [string]::IsNullOrWhiteSpace($recordDir)) {
    New-Item -ItemType Directory -Force -Path $recordDir | Out-Null
  }

  $revision = 'unknown'
  if (Test-Path -LiteralPath (Join-Path $repoRoot '.git')) {
    try {
      $revision = (git -C $repoRoot rev-parse HEAD).Trim()
    }
    catch {
    }
  }

  $record = [ordered]@{
    timestamp = Get-IsoTimestamp
    status = $Status
    decision = $GateDecision
    reviewer = $GateReviewer
    reason = $GateReason
    evidence = $GateEvidence
    source_ref = $GateSourceRef
    repo_root = $repoRoot
    repo_revision = $revision
    skills_root = $source
    codex_skills_root = $target
    skill_count = $SkillCount
    host = $env:COMPUTERNAME
    user = $env:USERNAME
  }

  Add-Content -LiteralPath $GateRecordPath -Value ($record | ConvertTo-Json -Compress) -Encoding UTF8
}

if (-not (Test-Path -LiteralPath $source)) {
  throw "Missing skills directory: $source"
}

if ([string]::IsNullOrWhiteSpace($GateDecision) -or [string]::IsNullOrWhiteSpace($GateReviewer) -or [string]::IsNullOrWhiteSpace($GateReason)) {
  throw "GateDecision, GateReviewer, and GateReason are required."
}

$skillCount = (Get-ChildItem -LiteralPath $source -Directory | Measure-Object).Count
if ($GateDecision -ne 'allow') {
  Write-GateRecord -Status 'rejected_before_install' -SkillCount $skillCount
  throw "GateDecision '$GateDecision' does not permit install. Only 'allow' can proceed."
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
Write-GateRecord -Status 'installed' -SkillCount $skillCount
