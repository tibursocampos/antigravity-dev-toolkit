#Requires -Version 5.1
<#
.SYNOPSIS
  Deploys antigravity-dev-toolkit to the Antigravity IDE plugins directory.

.DESCRIPTION
  Copies plugin.json, GUARDRAILS.md, and skills/ to the Antigravity plugins folder.
  Syncs custom_skills and global_guardrails Knowledge Items.
  Creates ~/.gemini/antigravity-ide/sdd/sessions/ for session-state gates.

.PARAMETER DryRun
  Report planned changes without writing files.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-antigravity.ps1
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

function Get-AntigravityPluginsRoot {
    $candidates = @(
        # Primary: actual Antigravity IDE install location (must be first)
        (Join-Path $env:USERPROFILE '.gemini\antigravity-ide\plugins'),
        # Fallbacks for alternate installs
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
    # Default to primary if none found (will be created on sync)
    return $candidates[0]
}

function Write-KnowledgeItem {
    param(
        [string] $KnowledgeRoot,
        [string] $SubFolder,
        [string] $SummaryJson
    )
    $targetDir = Join-Path $KnowledgeRoot $SubFolder
    if (-not $DryRun) {
        if (-not (Test-Path -LiteralPath $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
    }

    $metadataPath = Join-Path $targetDir 'metadata.json'
    $metadataJson = @"
{
  "summary": $SummaryJson,
  "createdAt": "$([datetime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'))",
  "updatedAt": "$([datetime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'))",
  "references": []
}
"@

    if ($DryRun) {
        Write-ToolkitMessage "Would sync KI: $metadataPath" ([ConsoleColor]::Cyan)
        return 1
    }

    try {
        [System.IO.File]::WriteAllText($metadataPath, $metadataJson, [System.Text.Encoding]::UTF8)
        Write-ToolkitMessage "Synced KI: $metadataPath" ([ConsoleColor]::Green)
        return 1
    }
    catch {
        Write-ToolkitMessage "Warning: Could not sync KI to $metadataPath. $($_.Exception.Message)" ([ConsoleColor]::Yellow)
        return 0
    }
}

$repoRoot = Get-RepoRoot
$pluginsRoot = Get-AntigravityPluginsRoot
$pluginDest = Join-Path $pluginsRoot $script:PluginId
$escapedPluginDest = $pluginDest.Replace('\', '\\')

Write-ToolkitMessage "Repo  : $repoRoot"
Write-ToolkitMessage "Target: $pluginDest"
if ($DryRun) {
    Write-ToolkitMessage 'Dry run - no files will be written.' ([ConsoleColor]::Yellow)
}

if (-not $DryRun) {
    if (-not (Test-Path -LiteralPath $pluginDest)) {
        New-Item -ItemType Directory -Path $pluginDest -Force | Out-Null
    }

    $sessionsDir = Join-Path $env:USERPROFILE '.gemini\antigravity-ide\sdd\sessions'
    if (-not (Test-Path -LiteralPath $sessionsDir)) {
        New-Item -ItemType Directory -Path $sessionsDir -Force | Out-Null
        Write-ToolkitMessage "Created sessions dir: $sessionsDir" ([ConsoleColor]::Green)
    }
}

$totalChanges = 0

$pluginJsonSrc = Join-Path $repoRoot 'plugin\plugin.json'
$pluginJsonDest = Join-Path $pluginDest 'plugin.json'
if (Test-Path -LiteralPath $pluginJsonSrc) {
    if (Copy-FileIfChanged -SourcePath $pluginJsonSrc -DestPath $pluginJsonDest) {
        $totalChanges++
    }
}

$guardrailsSrc = Join-Path $repoRoot 'plugin\GUARDRAILS.md'
$guardrailsDest = Join-Path $pluginDest 'GUARDRAILS.md'
if (Test-Path -LiteralPath $guardrailsSrc) {
    if (Copy-FileIfChanged -SourcePath $guardrailsSrc -DestPath $guardrailsDest) {
        $totalChanges++
    }
}

$totalChanges += Sync-DirectoryTree `
    -SourceRoot (Join-Path $repoRoot 'plugin\skills') `
    -DestRoot   (Join-Path $pluginDest 'skills')

$kiTargets = @(
    (Join-Path $env:USERPROFILE '.gemini\antigravity-ide\knowledge'),
    (Join-Path $env:USERPROFILE '.gemini\antigravity\knowledge')
)

$customSkillsSummary = @"
\"Custom Skills Toolkit: When the user mentions 'use skill [name]', '/[name]', or similar, read the SKILL.md at: $($escapedPluginDest)\\\\skills\\\\[name]\\\\SKILL.md BEFORE any action. Skill folder names use underscores (e.g. sdd_spec, speckit_init, refine_backlog_item). This directory is the source of truth for execution rules.\"
"@

$globalGuardrailsSummary = @"
\"MANDATORY — EVERY conversation, turn 1, BEFORE any tool call: Read $($escapedPluginDest)\\\\GUARDRAILS.md and $($escapedPluginDest)\\\\skills\\\\dev_persona\\\\SKILL.md (Git Mutating Commands + Language sections). Read $($escapedPluginDest)\\\\skills\\\\_shared\\\\sdd_artifacts\\\\SESSION.md and load session-state for the active workspace. If the user has NOT said sim to the current action, do NOT run mutating git commands or Write/Delete. STOP after one SDD develop step or one Spec Kit task per session. Chat replies: pt-BR. Code: English.\"
"@

foreach ($knowledgeRoot in $kiTargets) {
    if (-not (Test-Path -LiteralPath $knowledgeRoot)) {
        if (-not $DryRun) {
            New-Item -ItemType Directory -Path $knowledgeRoot -Force | Out-Null
        }
    }

    $totalChanges += Write-KnowledgeItem -KnowledgeRoot $knowledgeRoot -SubFolder 'custom_skills' -SummaryJson $customSkillsSummary
    $totalChanges += Write-KnowledgeItem -KnowledgeRoot $knowledgeRoot -SubFolder 'global_guardrails' -SummaryJson $globalGuardrailsSummary
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
        Write-ToolkitMessage 'Restart Antigravity IDE to pick up new/updated skills and KIs.' ([ConsoleColor]::DarkGray)
        Write-ToolkitMessage 'Run: .\scripts\validate-all.ps1' ([ConsoleColor]::DarkGray)
    }
}

exit 0
