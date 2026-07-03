#Requires -Version 5.1
<#
.SYNOPSIS
  Validates blip_plugin_developer skill and blip_guidelines bundle.

.DESCRIPTION
  Called by validate-all.ps1. Checks SKILL.md structure, required guideline files,
  positive markers (create-blip-extension, config:plugin, handoffs), and forbidden legacy patterns.

.EXAMPLE
  .\scripts\validation\validate-blip-plugin-skill.ps1
#>
[CmdletBinding()]
param(
    [string] $RepoRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $scriptDir = $PSScriptRoot
    if ([string]::IsNullOrWhiteSpace($scriptDir)) {
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    $RepoRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
}

$failures = @()
$skillPath = Join-Path $RepoRoot 'plugin\skills\blip_plugin_developer\SKILL.md'
$guidelinesRoot = Join-Path $RepoRoot 'plugin\skills\_shared\blip_guidelines'

$requiredGuidelines = @(
    'plugin-architecture.md',
    'design-system.md',
    'blip-iframe-messages.md',
    'auth-and-permissions.md',
    'external-api-integration.md',
    'deploy-and-ci.md'
)

if (-not (Test-Path -LiteralPath $skillPath)) {
    Write-Host 'Blip plugin validation FAILED: plugin/skills/blip_plugin_developer/SKILL.md missing' -ForegroundColor Red
    exit 1
}

$content = Get-Content -LiteralPath $skillPath -Raw

if ($content.Length -lt 1500) {
    $failures += 'SKILL.md too small (likely incomplete)'
}

$requiredMarkers = @(
    'config:plugin',
    'create blip-extension',
    'react_developer',
    'sdd_spec',
    'speckit_spec',
    'impeccable shape',
    'blip_guidelines'
)
foreach ($m in $requiredMarkers) {
    if ($content -notmatch [regex]::Escape($m)) {
        $failures += "SKILL.md missing expected marker: $m"
    }
}

$forbiddenPatterns = @(
    @{ Pattern = 'use skill impeccable_developer'; Message = 'Removed impeccable_developer persona invocation' },
    @{ Pattern = 'use skill impeccable_ui'; Message = 'Removed impeccable_ui persona invocation' },
    @{ Pattern = 'impeccable_developer.*foco premium'; Message = 'Legacy persona handoff choice' },
    @{ Pattern = 'NEW_PACKAGE_NAME'; Message = 'Wrong placeholder NEW_PACKAGE_NAME' },
    @{ Pattern = 'git clone https://github.com/takenet/cra-template-blip-plugin'; Message = 'Wrong microbundle template clone URL as default' }
)
foreach ($item in $forbiddenPatterns) {
    if ($content -match $item.Pattern) {
        $failures += "SKILL.md contains forbidden pattern: $($item.Message)"
    }
}

foreach ($file in $requiredGuidelines) {
    $path = Join-Path $guidelinesRoot $file
    if (-not (Test-Path -LiteralPath $path)) {
        $failures += "Missing guideline: blip_guidelines/$file"
    }
    elseif ((Get-Item -LiteralPath $path).Length -lt 200) {
        $failures += "Guideline too small: blip_guidelines/$file"
    }
}

$forbiddenBlipFolders = @('blip-plugin-developer', 'blip_plugin', 'blip-plugin')
foreach ($folder in $forbiddenBlipFolders) {
    $path = Join-Path (Join-Path $RepoRoot 'plugin\skills') $folder
    if (Test-Path -LiteralPath $path) {
        $failures += "Duplicate/legacy Blip skill folder must not exist: plugin/skills/$folder/"
    }
}

$forbiddenImpeccableFolders = @(
    'impeccable_developer', 'impeccable_ui', 'impeccable_components', 'impeccable_state', 'impeccable_a11y'
)
foreach ($folder in $forbiddenImpeccableFolders) {
    $path = Join-Path (Join-Path $RepoRoot 'plugin\skills') $folder
    if (Test-Path -LiteralPath $path) {
        $failures += "Removed impeccable persona folder must not exist: plugin/skills/$folder/"
    }
}

$integrationDoc = Join-Path $RepoRoot 'docs\blip-plugin-integration.md'
if (-not (Test-Path -LiteralPath $integrationDoc)) {
    $failures += 'Missing docs/blip-plugin-integration.md'
}

if ($failures.Count -gt 0) {
    Write-Host 'Blip plugin validation FAILED:' -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    exit 1
}

Write-Host "Blip plugin validation passed ($($requiredGuidelines.Count) guideline files)." -ForegroundColor Green
exit 0
