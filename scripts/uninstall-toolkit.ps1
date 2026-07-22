#Requires -Version 5.1
<#
.SYNOPSIS
  Uninstalls antigravity-dev-toolkit from the Antigravity IDE plugins directory.

.DESCRIPTION
  Removes the plugin folder, custom knowledge items, the managed AGENTS.md block,
  and removes the plugin registration from skills.json.
  Also cleans the legacy plugin id Local.raphadev.antigravity-dev-toolkit if present.

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
$script:PluginId = 'antigravity-dev-toolkit'
$script:LegacyPluginId = 'Local.raphadev.antigravity-dev-toolkit'
$script:AgentsManagedBegin = '<!-- antigravity-dev-toolkit:managed:begin -->'
$script:AgentsManagedEnd = '<!-- antigravity-dev-toolkit:managed:end -->'

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

function Remove-ManagedAgentsBlock {
    param([string] $ConfigAgentsPath)

    if (-not (Test-Path -LiteralPath $ConfigAgentsPath)) {
        return $false
    }

    $existing = Get-Content -LiteralPath $ConfigAgentsPath -Raw
    $begin = $script:AgentsManagedBegin
    $end = $script:AgentsManagedEnd
    $pattern = '(?s)' + [regex]::Escape($begin) + '.*?' + [regex]::Escape($end) + '\r?\n*'

    if ($existing -notmatch $pattern) {
        return $false
    }

    if ($DryRun) {
        Write-ToolkitMessage "Would remove managed AGENTS.md block: $ConfigAgentsPath" ([ConsoleColor]::Cyan)
        return $true
    }

    $newContent = [regex]::Replace($existing, $pattern, '').Trim()
    if ([string]::IsNullOrWhiteSpace($newContent)) {
        Remove-Item -LiteralPath $ConfigAgentsPath -Force
        Write-ToolkitMessage "Removed empty AGENTS.md: $ConfigAgentsPath" ([ConsoleColor]::DarkRed)
    }
    else {
        [System.IO.File]::WriteAllText($ConfigAgentsPath, $newContent + "`n", [System.Text.Encoding]::UTF8)
        Write-ToolkitMessage "Removed managed AGENTS.md block: $ConfigAgentsPath" ([ConsoleColor]::DarkRed)
    }
    return $true
}

$pluginsRoot = Get-AntigravityPluginsRoot
$pluginDest = Join-Path $pluginsRoot $script:PluginId
$legacyPluginDest = Join-Path $pluginsRoot $script:LegacyPluginId
$skillsDest = Join-Path $pluginDest 'skills'
$legacySkillsDest = Join-Path $legacyPluginDest 'skills'

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

# 2. Remove Plugin Directory (current + legacy)
foreach ($dest in @($pluginDest, $legacyPluginDest)) {
    if (Test-Path -LiteralPath $dest) {
        if ($DryRun) {
            Write-ToolkitMessage "Would remove plugin directory: $dest" ([ConsoleColor]::Cyan)
            $totalChanges++
        } else {
            Remove-Item -LiteralPath $dest -Recurse -Force
            Write-ToolkitMessage "Removed plugin directory: $dest" ([ConsoleColor]::DarkRed)
            $totalChanges++
        }
    }
}

# 3. Update skills.json
$globalConfigRoot = Join-Path $env:USERPROFILE '.gemini\config'
$skillsJsonPath = Join-Path $globalConfigRoot 'skills.json'
$configAgentsPath = Join-Path $globalConfigRoot 'AGENTS.md'

if (Test-Path -LiteralPath $skillsJsonPath) {
    $skillsJsonContent = $null
    try {
        $skillsJsonContent = Get-Content -LiteralPath $skillsJsonPath -Raw | ConvertFrom-Json
    } catch {}

    if ($null -ne $skillsJsonContent -and $null -ne $skillsJsonContent.entries) {
        $newEntries = @()
        $found = $false
        foreach ($entry in $skillsJsonContent.entries) {
            $entryPath = [string]$entry.path
            $isToolkit = ($entryPath -eq $skillsDest) -or
                ($entryPath -eq $legacySkillsDest) -or
                ($entryPath -like "*\$($script:LegacyPluginId)\skills") -or
                ($entryPath -like "*/$($script:LegacyPluginId)/skills") -or
                ($entryPath -like "*\$($script:PluginId)\skills") -or
                ($entryPath -like "*/$($script:PluginId)/skills")
            if ($isToolkit) {
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

# 4. Remove managed AGENTS.md block (preserve user /learn content outside markers)
if (Remove-ManagedAgentsBlock -ConfigAgentsPath $configAgentsPath) {
    $totalChanges++
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
