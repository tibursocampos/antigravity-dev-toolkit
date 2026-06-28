#Requires -Version 5.1
<#
.SYNOPSIS
  Uninstalls antigravity-dev-toolkit from the Antigravity IDE plugins directory.

.DESCRIPTION
  Removes the plugin folder, custom knowledge items, and removes the plugin registration from skills.json.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/uninstall-toolkit.ps1
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

function Get-AntigravityPluginsRoot {
    $candidates = @(
        (Join-Path $env:USERPROFILE '.gemini\antigravity-ide\plugins'),
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
    return $candidates[0]
}

$pluginsRoot = Get-AntigravityPluginsRoot
$pluginDest = Join-Path $pluginsRoot $script:PluginId
$skillsDest = Join-Path $pluginDest 'skills'

$kiTargets = @(
    (Join-Path $env:USERPROFILE '.gemini\antigravity-ide\knowledge'),
    (Join-Path $env:USERPROFILE '.gemini\antigravity\knowledge')
)

$totalChanges = 0

# 1. Remove Knowledge Items
foreach ($knowledgeRoot in $kiTargets) {
    foreach ($folder in @('custom_skills', 'global_guardrails')) {
        $targetDir = Join-Path $knowledgeRoot $folder
        if (Test-Path -LiteralPath $targetDir) {
            if ($DryRun) {
                Write-ToolkitMessage "Would remove KI directory: $targetDir" ([ConsoleColor]::Cyan)
                $totalChanges++
            } else {
                Remove-Item -LiteralPath $targetDir -Recurse -Force
                Write-ToolkitMessage "Removed KI directory: $targetDir" ([ConsoleColor]::DarkRed)
                $totalChanges++
            }
        }
    }
}

# 2. Remove Plugin Directory
if (Test-Path -LiteralPath $pluginDest) {
    if ($DryRun) {
        Write-ToolkitMessage "Would remove plugin directory: $pluginDest" ([ConsoleColor]::Cyan)
        $totalChanges++
    } else {
        Remove-Item -LiteralPath $pluginDest -Recurse -Force
        Write-ToolkitMessage "Removed plugin directory: $pluginDest" ([ConsoleColor]::DarkRed)
        $totalChanges++
    }
}

# 3. Update skills.json
$globalConfigRoot = Join-Path $env:USERPROFILE '.gemini\config'
$skillsJsonPath = Join-Path $globalConfigRoot 'skills.json'

if (Test-Path -LiteralPath $skillsJsonPath) {
    $skillsJsonContent = $null
    try {
        $skillsJsonContent = Get-Content -LiteralPath $skillsJsonPath -Raw | ConvertFrom-Json
    } catch {}

    if ($null -ne $skillsJsonContent -and $null -ne $skillsJsonContent.entries) {
        $newEntries = @()
        $found = $false
        foreach ($entry in $skillsJsonContent.entries) {
            if ($entry.path -eq $skillsDest) {
                $found = $true
            } else {
                $newEntries += $entry
            }
        }

        if ($found) {
            if ($DryRun) {
                Write-ToolkitMessage "Would remove entry from skills.json: $skillsJsonPath" ([ConsoleColor]::Cyan)
                $totalChanges++
            } else {
                $skillsJsonContent.entries = $newEntries
                $jsonString = $skillsJsonContent | ConvertTo-Json -Depth 5
                [System.IO.File]::WriteAllText($skillsJsonPath, $jsonString, [System.Text.Encoding]::UTF8)
                Write-ToolkitMessage "Removed toolkit skills from: $skillsJsonPath" ([ConsoleColor]::Green)
                $totalChanges++
            }
        }
    }
}

Write-Host ''
if ($totalChanges -eq 0) {
    Write-ToolkitMessage 'Uninstall complete - nothing to remove.' ([ConsoleColor]::Green)
} else {
    if ($DryRun) {
        Write-ToolkitMessage "Dry run complete - $totalChanges item(s) would be removed." ([ConsoleColor]::Cyan)
    } else {
        Write-ToolkitMessage "Uninstall complete - $totalChanges item(s) removed." ([ConsoleColor]::Green)
    }
}
exit 0
