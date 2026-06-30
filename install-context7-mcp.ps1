param(
  [string]$CodexHome = (Join-Path $HOME ".codex"),
  [string]$NpxCmd = "C:\Program Files\nodejs\npx.cmd",
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$SnippetPath = Join-Path $PackageRoot "codex\mcp\context7.toml"
$CodexConfig = Join-Path $CodexHome "config.toml"
$BeginMarker = "# BEGIN CONTEXT7_MCP"
$EndMarker = "# END CONTEXT7_MCP"

if (-not (Test-Path -LiteralPath $SnippetPath)) {
  throw "Missing MCP snippet: $SnippetPath"
}

if (-not (Test-Path -LiteralPath $NpxCmd)) {
  throw "npx not found: $NpxCmd"
}

$Snippet = (Get-Content -LiteralPath $SnippetPath -Raw).Replace('__NPX_CMD__', $NpxCmd)
$ManagedBlock = "$BeginMarker`r`n$Snippet`r`n$EndMarker"

if (Test-Path -LiteralPath $CodexConfig) {
  $Existing = Get-Content -LiteralPath $CodexConfig -Raw
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

if ($DryRun) {
  Write-Output "Would update: $CodexConfig"
  Write-Output ""
  Write-Output $ManagedBlock
  exit 0
}

New-Item -ItemType Directory -Force -Path $CodexHome | Out-Null

if (Test-Path -LiteralPath $CodexConfig) {
  $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  Copy-Item -LiteralPath $CodexConfig -Destination "$CodexConfig.bak-context7-mcp-$Timestamp" -Force
}

[System.IO.File]::WriteAllText($CodexConfig, $Updated, $Utf8NoBom)

Write-Output "Updated Codex MCP config:"
Write-Output "  $CodexConfig"
Write-Output "Restart Codex or open a new conversation to load context7."
