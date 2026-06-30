param(
  [string]$CodexHome = (Join-Path $HOME ".codex"),
  [switch]$IncludeCodebaseMemory,
  [switch]$SkipGitHubDownload,
  [string]$GitHubInstallRoot = "D:\py\tools\github-mcp-server",
  [string]$GitHubVersion = "v1.5.0",
  [string]$NpxCmd = "C:\Program Files\nodejs\npx.cmd"
)

$ErrorActionPreference = "Stop"

$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

& (Join-Path $PackageRoot "install-context7-mcp.ps1") -CodexHome $CodexHome -NpxCmd $NpxCmd
& (Join-Path $PackageRoot "install-github-mcp.ps1") -CodexHome $CodexHome -InstallRoot $GitHubInstallRoot -Version $GitHubVersion -SkipDownload:$SkipGitHubDownload

if ($IncludeCodebaseMemory) {
  & (Join-Path $PackageRoot "install-codebase-memory.ps1") -CodexHome $CodexHome
}

Write-Output "Codex MCP suite install complete."
Write-Output "Restart Codex and trigger one GitHub task plus one Context7 task to verify routing."
