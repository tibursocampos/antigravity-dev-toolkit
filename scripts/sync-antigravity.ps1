#Requires -Version 5.1
<#
.SYNOPSIS
  Deploys antigravity-dev-toolkit to the Antigravity IDE plugins directory.

.DESCRIPTION
  Copies plugin.json and skills/ to:
    %LOCALAPPDATA%\Google\antigravity-ide\plugins\Local.raphadev.antigravity-dev-toolkit\
  Uses SHA-256 comparison — idempotent, non-destructive (does not delete other plugins).

.PARAMETER DryRun
  Report planned changes without writing files.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-antigravity.ps1

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-antigravity.ps1 -DryRun
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch] $DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:ToolkitTag = '[antigravity-dev-toolkit]'
$script:PluginId = 'Local.raphadev.antigravity-dev-toolkit'

function Write-ToolkitMessage {
    param(
        [string] $Message,
        [ConsoleColor] $Color = [ConsoleColor]::Gray
    )
    Write-Host "$script:ToolkitTag $Message" -ForegroundColor $Color
}

function Get-RepoRoot {
    $scriptDir = $PSScriptRoot
    if ([string]::IsNullOrWhiteSpace($scriptDir)) {
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    return (Resolve-Path (Join-Path $scriptDir '..')).Path
}

function Get-FileSha256([string] $Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Copy-FileIfChanged {
    param(
        [string] $SourcePath,
        [string] $DestPath
    )
    $destDir = Split-Path -Parent $DestPath
    if (-not (Test-Path -LiteralPath $destDir)) {
        if ($DryRun) {
            Write-ToolkitMessage "Would create directory: $destDir" ([ConsoleColor]::Cyan)
        }
        else {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
    }

    $sourceHash = Get-FileSha256 $SourcePath
    $destHash = Get-FileSha256 $DestPath
    if ($sourceHash -eq $destHash) {
        return $false
    }

    if ($DryRun) {
        Write-ToolkitMessage "Would sync: $DestPath" ([ConsoleColor]::Cyan)
        return $true
    }

    Copy-Item -LiteralPath $SourcePath -Destination $DestPath -Force
    Write-ToolkitMessage "Synced: $DestPath" ([ConsoleColor]::Green)
    return $true
}

function Sync-DirectoryTree {
    param(
        [string]   $SourceRoot,
        [string]   $DestRoot,
        [string[]] $ExcludeFileNames = @()
    )
    if (-not (Test-Path -LiteralPath $SourceRoot)) {
        return 0
    }

    $changed = 0
    Get-ChildItem -LiteralPath $SourceRoot -Recurse -File |
    Where-Object {
        $ExcludeFileNames -notcontains $_.Name -and
        $_.Name -ne '.gitkeep'
    } |
    ForEach-Object {
        $relative = $_.FullName.Substring($SourceRoot.Length).TrimStart('\', '/')
        $destPath = Join-Path $DestRoot $relative
        if (Copy-FileIfChanged -SourcePath $_.FullName -DestPath $destPath) {
            $changed++
        }
    }
    return $changed
}

# ── Resolve Antigravity IDE plugins root ─────────────────────────────────────
#
# Primary location: %APPDATA%\antigravity-ide\plugins\  (confirmed on this machine)
# Fallback:        %LOCALAPPDATA%\Google\antigravity-ide\plugins\
#
function Get-AntigravityPluginsRoot {
    $candidates = @(
        (Join-Path $env:APPDATA 'antigravity-ide\plugins'),
        (Join-Path $env:LOCALAPPDATA 'Google\antigravity-ide\plugins'),
        (Join-Path $env:APPDATA 'antigravity\plugins'),
        (Join-Path $env:LOCALAPPDATA 'Google\antigravity\plugins')
    )
    foreach ($c in $candidates) {
        if (Test-Path -LiteralPath $c) {
            return $c
        }
    }
    # Default to the primary candidate even if it doesn't exist yet
    return $candidates[0]
}

# ── Main ──────────────────────────────────────────────────────────────────────

$repoRoot = Get-RepoRoot
$pluginsRoot = Get-AntigravityPluginsRoot
$pluginDest = Join-Path $pluginsRoot $script:PluginId

Write-ToolkitMessage "Repo  : $repoRoot"
Write-ToolkitMessage "Target: $pluginDest"
if ($DryRun) {
    Write-ToolkitMessage 'Dry run - no files will be written.' ([ConsoleColor]::Yellow)
}

if (-not $DryRun) {
    if (-not (Test-Path -LiteralPath $pluginDest)) {
        New-Item -ItemType Directory -Path $pluginDest -Force | Out-Null
    }
}

$totalChanges = 0

# Deploy plugin.json
$pluginJsonSrc = Join-Path $repoRoot 'plugin\plugin.json'
$pluginJsonDest = Join-Path $pluginDest 'plugin.json'
if (Test-Path -LiteralPath $pluginJsonSrc) {
    if (Copy-FileIfChanged -SourcePath $pluginJsonSrc -DestPath $pluginJsonDest) {
        $totalChanges++
    }
}
else {
    Write-ToolkitMessage 'plugin/plugin.json not found in repo; skipped.' ([ConsoleColor]::Yellow)
}

# Deploy skills/
$totalChanges += Sync-DirectoryTree `
    -SourceRoot (Join-Path $repoRoot 'plugin\skills') `
    -DestRoot   (Join-Path $pluginDest 'skills')

# Deploy Knowledge Item (KI)
$kiTargets = @(
    (Join-Path $env:USERPROFILE '.gemini\antigravity-ide\knowledge\custom_skills'),
    (Join-Path $env:USERPROFILE '.gemini\antigravity\knowledge\custom_skills')
)

foreach ($knowledgeRoot in $kiTargets) {
    if (-not $DryRun) {
        if (-not (Test-Path -LiteralPath $knowledgeRoot)) {
            New-Item -ItemType Directory -Path $knowledgeRoot -Force | Out-Null
        }
    }

    $metadataPath = Join-Path $knowledgeRoot 'metadata.json'
    $escapedPluginDest = $pluginDest.Replace('\', '\\')
    $metadataJson = @"
{
  "summary": "Custom Skills Toolkit: The user has a custom skills toolkit. Whenever the user mentions 'use skill [name]', 'use a skill [name]', or uses the '/[name]' command, you MUST read the corresponding SKILL.md file at: $($escapedPluginDest)\\skills\\[name]\\SKILL.md BEFORE executing any action. Consider this directory as the source of truth for user execution rules.",
  "createdAt": "$([datetime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'))",
  "updatedAt": "$([datetime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'))",
  "references": []
}
"@

    if ($DryRun) {
        Write-ToolkitMessage "Would sync Knowledge Item: $metadataPath" ([ConsoleColor]::Cyan)
    }
    else {
        try {
            [System.IO.File]::WriteAllText($metadataPath, $metadataJson, [System.Text.Encoding]::UTF8)
            Write-ToolkitMessage "Synced KI: $metadataPath" ([ConsoleColor]::Green)
            $totalChanges++
        }
        catch {
            Write-ToolkitMessage "Warning: Could not sync KI to $metadataPath. It may be locked: $($_.Exception.Message)" ([ConsoleColor]::Yellow)
        }
    }
}

Write-Host ''
if ($totalChanges -eq 0) {
    Write-ToolkitMessage 'Deploy complete - already up to date (idempotent).' ([ConsoleColor]::Green)
}
else {
    if ($DryRun) {
        Write-ToolkitMessage "Dry run complete - $totalChanges item(s) would change." ([ConsoleColor]::Cyan)
    }
    else {
        Write-ToolkitMessage "Deploy complete - $totalChanges item(s) updated." ([ConsoleColor]::Green)
        Write-ToolkitMessage 'Restart Antigravity IDE to pick up new/updated skills.' ([ConsoleColor]::DarkGray)
    }
}

exit 0
