#Requires -Version 5.1
<#
.SYNOPSIS
  Validates antigravity-dev-toolkit deployment and enforcement files.

.DESCRIPTION
  Called by validate-all.ps1.

.EXAMPLE
  .\scripts\validate-toolkit-deploy.ps1
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
$pluginId = 'Local.raphadev.antigravity-dev-toolkit'
$pluginsCandidates = @(
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

$skillCount = (Get-ChildItem -LiteralPath (Join-Path $repoRoot 'plugin\skills') -Directory |
    Where-Object { $_.Name -ne '_shared' }).Count
Write-Host "Skills in repo: $skillCount"

if ($failed) {
    Write-Host 'Deploy validation FAILED. Run: .\scripts\sync-antigravity.ps1' -ForegroundColor Red
    exit 1
}

Write-Host 'Deploy validation passed.' -ForegroundColor Green
exit 0
