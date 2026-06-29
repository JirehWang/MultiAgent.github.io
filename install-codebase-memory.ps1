param(
  [string]$CodexHome = (Join-Path $HOME ".codex"),
  [string]$McpSnippet = "",
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if ([string]::IsNullOrWhiteSpace($McpSnippet)) {
  $McpSnippet = Join-Path $PackageRoot "codex\mcp\codebase-memory.toml"
}

if (-not (Test-Path -LiteralPath $McpSnippet)) {
  throw "Missing MCP snippet: $McpSnippet"
}

$CodexConfig = Join-Path $CodexHome "config.toml"
$BeginMarker = "# BEGIN CODEBASE_MEMORY_MCP"
$EndMarker = "# END CODEBASE_MEMORY_MCP"
$Block = Get-Content -LiteralPath $McpSnippet -Raw
$ManagedBlock = "$BeginMarker`r`n$Block`r`n$EndMarker"

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
  Copy-Item -LiteralPath $CodexConfig -Destination "$CodexConfig.bak-codebase-memory-$Timestamp" -Force
}

[System.IO.File]::WriteAllText($CodexConfig, $Updated, $Utf8NoBom)

Write-Output "Updated Codex MCP config:"
Write-Output "  $CodexConfig"
Write-Output "Restart Codex or open a new conversation to load codebase_memory."
