param(
    [Parameter(Mandatory = $true)]
    [string]$OutputDir,

    [Parameter(Mandatory = $true)]
    [datetime]$StartDate,

    [Parameter(Mandatory = $true)]
    [datetime]$EndDate,

    [string]$StoreName,

    [string[]]$Folders = @("Inbox", "Sent")
)

$ErrorActionPreference = "Stop"

function Get-SafeFileName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $invalid = [System.IO.Path]::GetInvalidFileNameChars()
    $safe = $Name
    foreach ($char in $invalid) {
        $safe = $safe.Replace($char, "_")
    }
    $safe = $safe.Trim()
    if (-not $safe) {
        $safe = "untitled"
    }
    if ($safe.Length -gt 100) {
        $safe = $safe.Substring(0, 100)
    }
    return $safe
}

function Export-MailFolder {
    param(
        [Parameter(Mandatory = $true)]
        $Folder,

        [Parameter(Mandatory = $true)]
        [string]$FolderLabel,

        [Parameter(Mandatory = $true)]
        [string]$DateProperty,

        [Parameter(Mandatory = $true)]
        [string]$TargetDir
    )

    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

    $startText = $StartDate.ToString("MM/dd/yyyy hh:mm tt")
    $endText = $EndDate.ToString("MM/dd/yyyy hh:mm tt")
    $filter = "[$DateProperty] >= '$startText' AND [$DateProperty] < '$endText'"
    $items = $Folder.Items.Restrict($filter)
    $items.Sort("[$DateProperty]", $true)

    $exported = 0
    for ($i = 1; $i -le $items.Count; $i++) {
        $item = $items.Item($i)
        if (-not $item -or $item.Class -ne 43) {
            continue
        }

        $timestamp = $item.$DateProperty.ToString("yyyyMMdd_HHmmss")
        $subject = Get-SafeFileName -Name $item.Subject
        $fileName = "{0}_{1}_{2:D4}.msg" -f $FolderLabel, $timestamp, $i
        if ($subject) {
            $fileName = "{0}_{1}_{2:D4}_{3}.msg" -f $FolderLabel, $timestamp, $i, $subject
        }
        $targetPath = Join-Path $TargetDir $fileName
        $item.SaveAs($targetPath, 3)
        $exported++
    }

    return $exported
}

$outlook = New-Object -ComObject Outlook.Application
$namespace = $outlook.GetNamespace("MAPI")
$storeRoot = $null
if ($StoreName) {
    $storeRoot = $namespace.Folders.Item($StoreName)
    if (-not $storeRoot) {
        throw "Store not found: $StoreName"
    }
}

function Resolve-OutlookFolder {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Key
    )

    if ($storeRoot) {
        switch ($Key) {
            "Inbox" { return $storeRoot.Folders.Item(2) }
            "Sent" { return $storeRoot.Folders.Item(4) }
            default { throw "Unsupported folder key: $Key" }
        }
    }

    switch ($Key) {
        "Inbox" { return $namespace.GetDefaultFolder(6) }
        "Sent" { return $namespace.GetDefaultFolder(5) }
        default { throw "Unsupported folder key: $Key" }
    }
}

$folderMap = @{
    "Inbox" = @{
        Folder = Resolve-OutlookFolder -Key "Inbox"
        Label = "Inbox"
        DateProperty = "ReceivedTime"
    }
    "Sent" = @{
        Folder = Resolve-OutlookFolder -Key "Sent"
        Label = "Sent"
        DateProperty = "SentOn"
    }
}

$resolvedOutput = (Resolve-Path -LiteralPath (New-Item -ItemType Directory -Force -Path $OutputDir)).Path
$results = @()

foreach ($folderKey in $Folders) {
    if (-not $folderMap.ContainsKey($folderKey)) {
        throw "Unsupported folder key: $folderKey"
    }

    $config = $folderMap[$folderKey]
    $targetDir = Join-Path $resolvedOutput $config.Label
    $count = Export-MailFolder -Folder $config.Folder -FolderLabel $config.Label -DateProperty $config.DateProperty -TargetDir $targetDir
    $results += [PSCustomObject]@{
        Folder = $config.Folder.Name
        Exported = $count
        OutputDir = $targetDir
    }
}

$results | ConvertTo-Json -Compress
