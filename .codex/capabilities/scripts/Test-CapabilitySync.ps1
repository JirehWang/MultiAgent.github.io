[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]]$Capability,

    [switch]$CompanyContext,

    [switch]$Approved
)

$policyPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'sync-policy.json'
if (-not (Test-Path -LiteralPath $policyPath)) {
    Write-Error "Capability sync policy not found: $policyPath"
    exit 3
}

$policy = Get-Content -LiteralPath $policyPath -Raw -Encoding UTF8 | ConvertFrom-Json
$blocked = @()

foreach ($capabilityId in $Capability) {
    $property = $policy.capabilities.PSObject.Properties[$capabilityId]
    if ($null -eq $property) {
        $blocked += "$capabilityId (unknown capability)"
        continue
    }

    $category = [string]$property.Value
    if ($category -eq 'company' -or $CompanyContext) {
        $blocked += "$capabilityId ($category)"
    }
}

if ($blocked.Count -gt 0 -and -not $Approved) {
    Write-Error ("Cloud sync blocked. Explicit user approval is required for: " + ($blocked -join ', '))
    exit 2
}

if ($blocked.Count -gt 0) {
    Write-Output ("ALLOW_WITH_APPROVAL: " + ($blocked -join ', '))
    exit 0
}

Write-Output ("ALLOW_DEFAULT: " + ($Capability -join ', '))
exit 0
