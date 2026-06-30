param(
  [string]$CodexHome = (Join-Path $HOME ".codex"),
  [string]$InstallRoot = "D:\py\tools\github-mcp-server",
  [string]$Version = "v1.5.0",
  [switch]$SkipDownload,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$SnippetPath = Join-Path $PackageRoot "codex\mcp\github-oauth-local.toml"
$CodexConfig = Join-Path $CodexHome "config.toml"
$BeginMarker = "# BEGIN GITHUB_MCP"
$EndMarker = "# END GITHUB_MCP"
$ZipPath = Join-Path ([System.IO.Path]::GetTempPath()) "github-mcp-server_Windows_x86_64.zip"
$ExePath = Join-Path $InstallRoot "github-mcp-server.exe"

if (-not (Test-Path -LiteralPath $SnippetPath)) {
  throw "Missing MCP snippet: $SnippetPath"
}

if (-not $SkipDownload) {
  New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null
  $DownloadUrl = "https://github.com/github/github-mcp-server/releases/download/$Version/github-mcp-server_Windows_x86_64.zip"
  Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath
  Expand-Archive -LiteralPath $ZipPath -DestinationPath $InstallRoot -Force
}

if (-not (Test-Path -LiteralPath $ExePath)) {
  throw "GitHub MCP server executable not found: $ExePath"
}

$Snippet = (Get-Content -LiteralPath $SnippetPath -Raw).Replace('__GITHUB_MCP_SERVER_EXE__', $ExePath)
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
  Copy-Item -LiteralPath $CodexConfig -Destination "$CodexConfig.bak-github-mcp-$Timestamp" -Force
}

[System.IO.File]::WriteAllText($CodexConfig, $Updated, $Utf8NoBom)

Write-Output "Updated Codex MCP config:"
Write-Output "  $CodexConfig"
Write-Output "Installed GitHub MCP server:"
Write-Output "  $ExePath"
Write-Output "Restart Codex and trigger a GitHub task to complete the browser OAuth flow."
