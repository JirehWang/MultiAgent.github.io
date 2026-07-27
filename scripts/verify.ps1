[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$failures = New-Object System.Collections.Generic.List[string]

$required = @(
    '.codex\agents',
    '.codex\skills\using-superpowers\SKILL.md',
    '.codex\skills\using-superpowers\agent-routing-rules.yaml',
    '.codex\capabilities\registry.json',
    '.codex\capabilities\sync-policy.json',
    '.codex\global-agent-map\global-agent-skill-relationship-map.json',
    'docs\ANTIGRAVITY-LANDING.md'
)

foreach ($relative in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $relative))) {
        $failures.Add("Missing required path: $relative")
    }
}

$jsonFiles = Get-ChildItem -LiteralPath (Join-Path $repoRoot '.codex\capabilities') `
    -Filter '*.json' -File -Recurse
foreach ($file in $jsonFiles) {
    try {
        $null = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    }
    catch {
        $failures.Add("Invalid JSON: $($file.FullName): $($_.Exception.Message)")
    }
}

$forbiddenPatterns = @(
    '(^|/)(auth\.json|history\.jsonl)$',
    '\.sqlite(-shm|-wal)?$',
    '(^|/)(sessions|logs?|attachments|cache|tmp)/',
    '(^|/)(scratch|outputs|intermediate_json)/',
    '\.(xlsx|xls|pyc)$',
    '(^|/)\.env($|\.)',
    '\.bak-'
)

$tracked = git -C $repoRoot ls-files
foreach ($path in $tracked) {
    $normalized = $path -replace '\\', '/'
    foreach ($pattern in $forbiddenPatterns) {
        if ($normalized -match $pattern) {
            $failures.Add("Forbidden tracked artifact: $path")
            break
        }
    }
}

$skillCount = (
    Get-ChildItem -LiteralPath (Join-Path $repoRoot '.codex\skills') `
        -Filter 'SKILL.md' -File -Recurse
).Count
$agentCount = (
    Get-ChildItem -LiteralPath (Join-Path $repoRoot '.codex\agents') `
        -Filter '*.toml' -File
).Count

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "VERIFY_OK"
Write-Output "agents=$agentCount"
Write-Output "skills=$skillCount"
Write-Output "capability_json=$($jsonFiles.Count)"
Write-Output "forbidden_tracked_artifacts=0"
