#Requires -Version 5.1
<#
.SYNOPSIS
  Validates antigravity-dev-toolkit deployment and enforcement files.

.DESCRIPTION
  Called by validate-all.ps1.
  Checks the same primary install root used by sync-antigravity.ps1
  (~/.gemini/antigravity-ide/...), plus legacy APPDATA / LOCALAPPDATA fallbacks.

.EXAMPLE
  .\scripts\validation\validate-toolkit-deploy.ps1
#>
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($scriptDir)) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
}
$repoRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$pluginId = 'antigravity-dev-toolkit'
$agentsManagedBegin = '<!-- antigravity-dev-toolkit:managed:begin -->'
$agentsManagedEnd = '<!-- antigravity-dev-toolkit:managed:end -->'

# Order matches sync-antigravity.ps1 Get-AntigravityPluginsRoot (primary first)
$pluginsCandidates = @(
    (Join-Path $env:USERPROFILE ".gemini\antigravity-ide\plugins\$pluginId"),
    (Join-Path $env:APPDATA "antigravity-ide\plugins\$pluginId"),
    (Join-Path $env:LOCALAPPDATA "Google\antigravity-ide\plugins\$pluginId")
)

$pluginDest = $pluginsCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $pluginDest) {
    $pluginDest = $pluginsCandidates[0]
}

$checks = @(
    @{ Path = Join-Path $pluginDest 'GUARDRAILS.md'; Label = 'GUARDRAILS.md in plugin' },
    @{ Path = Join-Path $pluginDest 'skills\_shared\sdd_artifacts\SESSION.md'; Label = 'SESSION.md in plugin' },
    @{ Path = Join-Path $pluginDest 'skills\_shared\caveman\CAVEMAN.md'; Label = 'CAVEMAN.md in plugin' },
    @{ Path = Join-Path $env:USERPROFILE '.gemini\antigravity-ide\knowledge\global_guardrails\metadata.json'; Label = 'global_guardrails KI' },
    @{ Path = Join-Path $env:USERPROFILE '.gemini\antigravity-ide\knowledge\custom_skills\metadata.json'; Label = 'custom_skills KI' },
    @{ Path = Join-Path $env:USERPROFILE '.gemini\antigravity-ide\sdd\sessions'; Label = 'sessions directory' }
)

$failed = $false
foreach ($check in $checks) {
    if (Test-Path -LiteralPath $check.Path) {
        Write-Host "[OK] $($check.Label)" -ForegroundColor Green
    }
    else {
        Write-Host "[MISSING] $($check.Label) - $($check.Path)" -ForegroundColor Red
        $failed = $true
    }
}

# Repo source must always exist (CI-friendly invariant, independent of sync)
$repoChecks = @(
    @{ Path = Join-Path $repoRoot 'plugin\GUARDRAILS.md'; Label = 'repo GUARDRAILS.md' },
    @{ Path = Join-Path $repoRoot 'plugin\config\AGENTS.md'; Label = 'repo config AGENTS.md template' },
    @{ Path = Join-Path $repoRoot 'plugin\skills\_shared\sdd_artifacts\SESSION.md'; Label = 'repo SESSION.md' },
    @{ Path = Join-Path $repoRoot 'plugin\skills\_shared\caveman\CAVEMAN.md'; Label = 'repo CAVEMAN.md' },
    @{ Path = Join-Path $repoRoot 'plugin\skills\_shared\caveman\COMPACT.md'; Label = 'repo COMPACT.md' },
    @{ Path = Join-Path $repoRoot 'plugin\skills\_shared\agents\RECEIPT.md'; Label = 'repo RECEIPT.md' }
)
foreach ($check in $repoChecks) {
    if (Test-Path -LiteralPath $check.Path) {
        Write-Host "[OK] $($check.Label)" -ForegroundColor Green
    }
    else {
        Write-Host "[MISSING] $($check.Label) - $($check.Path)" -ForegroundColor Red
        $failed = $true
    }
}

# Deployed global config (skip soft-fail style only when plugin not installed — still report)
$skillsJsonPath = Join-Path $env:USERPROFILE '.gemini\config\skills.json'
$configAgentsPath = Join-Path $env:USERPROFILE '.gemini\config\AGENTS.md'
$expectedSkillsDest = Join-Path $pluginDest 'skills'

if (Test-Path -LiteralPath $skillsJsonPath) {
    try {
        $skillsJson = Get-Content -LiteralPath $skillsJsonPath -Raw | ConvertFrom-Json
        $hasEntry = $false
        foreach ($entry in @($skillsJson.entries)) {
            if ($null -ne $entry -and [string]$entry.path -eq $expectedSkillsDest) {
                $hasEntry = $true
                break
            }
        }
        if ($hasEntry) {
            Write-Host '[OK] skills.json registers plugin skills path' -ForegroundColor Green
        }
        else {
            Write-Host "[MISSING] skills.json entry for $expectedSkillsDest" -ForegroundColor Red
            $failed = $true
        }
    }
    catch {
        Write-Host "[MISSING] skills.json unreadable - $skillsJsonPath" -ForegroundColor Red
        $failed = $true
    }
}
else {
    Write-Host "[MISSING] skills.json - $skillsJsonPath" -ForegroundColor Red
    $failed = $true
}

if (Test-Path -LiteralPath $configAgentsPath) {
    $agentsRaw = Get-Content -LiteralPath $configAgentsPath -Raw
    if ($agentsRaw.Contains($agentsManagedBegin) -and $agentsRaw.Contains($agentsManagedEnd)) {
        Write-Host '[OK] config AGENTS.md has managed block' -ForegroundColor Green
    }
    else {
        Write-Host "[MISSING] config AGENTS.md managed markers - $configAgentsPath" -ForegroundColor Red
        $failed = $true
    }
}
else {
    Write-Host "[MISSING] config AGENTS.md - $configAgentsPath" -ForegroundColor Red
    $failed = $true
}

$skillCount = (Get-ChildItem -LiteralPath (Join-Path $repoRoot 'plugin\skills') -Directory |
    Where-Object { $_.Name -ne '_shared' }).Count
Write-Host "Skills in repo: $skillCount"
Write-Host "Plugin dest resolved: $pluginDest"

if ($failed) {
    Write-Host 'Deploy validation FAILED. Run: .\scripts\sync-antigravity.ps1' -ForegroundColor Red
    exit 1
}

Write-Host 'Deploy validation passed.' -ForegroundColor Green
exit 0
