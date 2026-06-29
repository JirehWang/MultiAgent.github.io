param(
  [ValidateSet("codex", "antigravity", "both")]
  [string]$Target = "both",
  [string]$CodexHome = (Join-Path $HOME ".codex"),
  [string]$GeminiHome = (Join-Path $HOME ".gemini")
)

$ErrorActionPreference = "Stop"

$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Copy-CleanDirectory {
  param(
    [string]$Source,
    [string]$Destination
  )

  if (-not (Test-Path -LiteralPath $Source)) {
    throw "Missing source directory: $Source"
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
  if (Test-Path -LiteralPath $Destination) {
    Remove-Item -LiteralPath $Destination -Recurse -Force
  }
  Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force
}

function Upsert-ManagedBlock {
  param(
    [string]$Path,
    [string]$BlockPath,
    [string]$BeginMarker,
    [string]$EndMarker
  )

  if (-not (Test-Path -LiteralPath $BlockPath)) {
    throw "Missing block source: $BlockPath"
  }

  $Parent = Split-Path -Parent $Path
  New-Item -ItemType Directory -Force -Path $Parent | Out-Null

  $Block = Get-Content -LiteralPath $BlockPath -Raw
  $ManagedBlock = "$BeginMarker`r`n$Block`r`n$EndMarker"

  if (Test-Path -LiteralPath $Path) {
    $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    Copy-Item -LiteralPath $Path -Destination "$Path.bak-$Timestamp" -Force
    $Existing = Get-Content -LiteralPath $Path -Raw
  } else {
    $Existing = ""
  }

  $Pattern = [regex]::Escape($BeginMarker) + "[\s\S]*?" + [regex]::Escape($EndMarker)
  if ($Existing -match $Pattern) {
    $Updated = [regex]::Replace($Existing, $Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $ManagedBlock })
  } elseif ([string]::IsNullOrWhiteSpace($Existing)) {
    $Updated = $ManagedBlock + "`r`n"
  } else {
    $Updated = $Existing.TrimEnd() + "`r`n`r`n" + $ManagedBlock + "`r`n"
  }

  [System.IO.File]::WriteAllText($Path, $Updated, $Utf8NoBom)
}

function Install-CodexRouting {
  $CodexAgentsSource = Join-Path $PackageRoot "codex\agents"
  $CodexSkillSource = Join-Path $PackageRoot "codex\skills\model-routing"
  $ProfileSource = Join-Path $PackageRoot "agent-profiles"
  $CodexAgentsTarget = Join-Path $CodexHome "agents"
  $CodexSkillTarget = Join-Path $CodexHome "skills\model-routing"

  if (-not (Test-Path -LiteralPath $CodexAgentsSource)) {
    throw "Missing Codex agents source: $CodexAgentsSource"
  }

  New-Item -ItemType Directory -Force -Path $CodexAgentsTarget | Out-Null
  Get-ChildItem -LiteralPath $CodexAgentsSource -Filter "*.toml" -File | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $CodexAgentsTarget $_.Name) -Force
  }

  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $CodexSkillTarget) | Out-Null
  Copy-CleanDirectory -Source $CodexSkillSource -Destination $CodexSkillTarget
  Copy-CleanDirectory -Source $ProfileSource -Destination (Join-Path $CodexSkillTarget "references\agent-profiles")

  Write-Output "Installed Codex routing agents:"
  Write-Output "  $CodexAgentsTarget"
  Write-Output "Installed Codex model-routing skill:"
  Write-Output "  $CodexSkillTarget"
}

function Install-AntigravityRouting {
  $SkillSource = Join-Path $PackageRoot "skills\antigravity-model-routing"
  $ProfileSource = Join-Path $PackageRoot "agent-profiles"
  $RuleSource = Join-Path $PackageRoot "global-rules\GEMINI.antigravity-model-routing.md"
  $GlobalSkillsDir = Join-Path $GeminiHome "config\skills"
  $TargetSkillDir = Join-Path $GlobalSkillsDir "antigravity-model-routing"
  $GeminiMd = Join-Path $GeminiHome "GEMINI.md"

  New-Item -ItemType Directory -Force -Path $GlobalSkillsDir | Out-Null
  Copy-CleanDirectory -Source $SkillSource -Destination $TargetSkillDir
  Copy-CleanDirectory -Source $ProfileSource -Destination (Join-Path $TargetSkillDir "resources\agent-profiles")

  Upsert-ManagedBlock `
    -Path $GeminiMd `
    -BlockPath $RuleSource `
    -BeginMarker "<!-- BEGIN ANTIGRAVITY_MODEL_ROUTING -->" `
    -EndMarker "<!-- END ANTIGRAVITY_MODEL_ROUTING -->"

  Write-Output "Installed Antigravity model routing skill:"
  Write-Output "  $TargetSkillDir"
  Write-Output "Updated global Antigravity rule:"
  Write-Output "  $GeminiMd"
}

if ($Target -eq "codex" -or $Target -eq "both") {
  Install-CodexRouting
}

if ($Target -eq "antigravity" -or $Target -eq "both") {
  Install-AntigravityRouting
}

Write-Output "Install complete. Restart Codex/Antigravity or open a new conversation to reload global skills and agents."
