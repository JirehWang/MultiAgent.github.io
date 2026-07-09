param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [string]$Remote = "origin",

    [string]$Branch,

    [switch]$Fetch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Args,

        [switch]$AllowFailure
    )

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $output = & git -C $RepoPath @Args 2>&1 | ForEach-Object { $_.ToString() }
    $ErrorActionPreference = $previousErrorActionPreference
    $exitCode = $LASTEXITCODE
    if (-not $AllowFailure -and $exitCode -ne 0) {
        throw "git $($Args -join ' ') failed: $output"
    }

    return [pscustomobject]@{
        Output   = ($output | Out-String).Trim()
        ExitCode = $exitCode
    }
}

if (-not (Test-Path -LiteralPath $RepoPath)) {
    throw "Repository path not found: $RepoPath"
}

$root = Invoke-Git -Args @("rev-parse", "--show-toplevel")
$currentBranch = Invoke-Git -Args @("branch", "--show-current")

if (-not $Branch) {
    $Branch = $currentBranch.Output
}

$upstream = Invoke-Git -Args @("rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}") -AllowFailure
$head = Invoke-Git -Args @("rev-parse", "--short", "HEAD")
$status = Invoke-Git -Args @("status", "--short", "--branch")
$stagedStat = Invoke-Git -Args @("diff", "--cached", "--stat") -AllowFailure
$unstagedStat = Invoke-Git -Args @("diff", "--stat") -AllowFailure

$fetchNote = "No fetch requested. Remote comparison uses locally cached refs."
if ($Fetch) {
    $fetchResult = Invoke-Git -Args @("fetch", "--prune", $Remote) -AllowFailure
    if ($fetchResult.ExitCode -eq 0) {
        $fetchNote = "Fetch succeeded."
    }
    else {
        $fetchNote = "Fetch failed. Remote comparison still uses locally cached refs. Error: $($fetchResult.Output)"
    }
}

$aheadBehindLine = "No upstream configured."
$aheadCommits = ""
$behindCommits = ""
$pushHint = "Set an upstream branch before deciding what to push."

if ($upstream.ExitCode -eq 0 -and $upstream.Output) {
    $counts = Invoke-Git -Args @("rev-list", "--left-right", "--count", "$($upstream.Output)...HEAD")
    $parts = $counts.Output -split "\s+"
    $behindCount = [int]$parts[0]
    $aheadCount = [int]$parts[1]
    $aheadBehindLine = "Ahead $aheadCount / Behind $behindCount relative to $($upstream.Output)"

    $aheadLog = Invoke-Git -Args @("log", "--oneline", "$($upstream.Output)..HEAD") -AllowFailure
    $behindLog = Invoke-Git -Args @("log", "--oneline", "HEAD..$($upstream.Output)") -AllowFailure

    $aheadCommits = if ($aheadLog.Output) { $aheadLog.Output } else { "(none)" }
    $behindCommits = if ($behindLog.Output) { $behindLog.Output } else { "(none)" }

    if ($aheadCount -gt 0 -and $behindCount -eq 0) {
        $pushHint = "Local branch has commits ready to push."
    }
    elseif ($aheadCount -gt 0 -and $behindCount -gt 0) {
        $pushHint = "Branch diverged. Pull or rebase before push."
    }
    elseif ($aheadCount -eq 0 -and $behindCount -gt 0) {
        $pushHint = "Remote is ahead. Sync before pushing."
    }
    else {
        $pushHint = "No committed changes to push."
    }
}

@(
    "# Git Version Report"
    ""
    "Repo: $($root.Output)"
    "Branch: $Branch"
    "HEAD: $($head.Output)"
    "Upstream: $(if ($upstream.Output) { $upstream.Output } else { '(none)' })"
    "Fetch: $fetchNote"
    ""
    "## Working Tree"
    $(if ($status.Output) { $status.Output } else { "(clean)" })
    ""
    "## Diff Summary"
    "Staged:"
    $(if ($stagedStat.Output) { $stagedStat.Output } else { "(none)" })
    ""
    "Unstaged:"
    $(if ($unstagedStat.Output) { $unstagedStat.Output } else { "(none)" })
    ""
    "## Remote Comparison"
    $aheadBehindLine
    ""
    "Commits to push:"
    $(if ($aheadCommits) { $aheadCommits } else { "(unknown)" })
    ""
    "Commits only on upstream:"
    $(if ($behindCommits) { $behindCommits } else { "(unknown)" })
    ""
    "## Next Push Decision"
    $pushHint
) -join [Environment]::NewLine
