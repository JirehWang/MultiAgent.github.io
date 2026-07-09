param(
    [Parameter(Mandatory = $true)]
    [string]$InputDir,

    [Parameter(Mandatory = $true)]
    [string]$OutputDir
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillRoot = Split-Path -Parent $scriptDir
$workspaceRoot = Split-Path -Parent (Split-Path -Parent $skillRoot)
$pipelineMain = Join-Path $workspaceRoot "mail_analysis_poc\src\main.py"

if (-not (Test-Path -LiteralPath $pipelineMain)) {
    throw "Pipeline entrypoint not found: $pipelineMain"
}

python $pipelineMain --input $InputDir --output $OutputDir
