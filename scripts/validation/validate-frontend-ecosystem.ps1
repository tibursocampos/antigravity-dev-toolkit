#Requires -Version 5.1
<#
.SYNOPSIS
  Validates frontend ecosystem skills, guidelines, and Impeccable alignment.

.DESCRIPTION
  Called by validate-all.ps1. Checks new stack skills exist, guideline bundles are present,
  frontend-practices.md has no Impeccable-conflicting markers, and stack skills reference DESIGN-BRIEF.

.EXAMPLE
  .\scripts\validation\validate-frontend-ecosystem.ps1
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
$skillsRoot = Join-Path $RepoRoot 'plugin\skills'
$sharedRoot = Join-Path $skillsRoot '_shared'

$forbiddenImpeccableFolders = @(
    'impeccable_developer',
    'impeccable_ui',
    'impeccable_components',
    'impeccable_state',
    'impeccable_a11y'
)
foreach ($folder in $forbiddenImpeccableFolders) {
    $path = Join-Path $skillsRoot $folder
    if (Test-Path -LiteralPath $path) {
        $failures += "Removed impeccable persona folder must not exist: plugin/skills/$folder/"
    }
}

$allowedBlipSkillFolders = @('blip_plugin_developer')
$blipSkillDirs = @(Get-ChildItem -LiteralPath $skillsRoot -Directory |
    Where-Object { $_.Name -match '^blip' })
foreach ($dir in $blipSkillDirs) {
    if ($allowedBlipSkillFolders -notcontains $dir.Name) {
        $failures += "Unexpected Blip skill folder (only blip_plugin_developer allowed): plugin/skills/$($dir.Name)/"
    }
}
if ($blipSkillDirs.Count -gt 1) {
    $failures += "Multiple Blip skill folders found: $($blipSkillDirs.Name -join ', ')"
}

$newStackSkills = @('vue_developer', 'blazor_developer', 'electron_developer', 'blip_plugin_developer')
foreach ($skill in $newStackSkills) {
    $skillPath = Join-Path $skillsRoot "$skill\SKILL.md"
    if (-not (Test-Path -LiteralPath $skillPath)) {
        $failures += "Missing skill: plugin/skills/$skill/SKILL.md"
    }
    elseif ((Get-Item -LiteralPath $skillPath).Length -lt 500) {
        $failures += "Skill too small: plugin/skills/$skill/SKILL.md"
    }
}

$guidelineSets = @{
    'html_css_guidelines' = @('semantic-html.md', 'css-foundations.md', 'scss-guidelines.md')
    'vue_guidelines'      = @('vue-composition.md', 'vue-routing-state.md', 'vue-testing.md')
    'blazor_guidelines'   = @('blazor-components.md', 'blazor-state.md', 'blazor-testing.md')
    'electron_guidelines' = @('electron-main-renderer.md', 'electron-security.md', 'electron-packaging.md')
    'blip_guidelines'     = @('plugin-architecture.md', 'design-system.md', 'blip-iframe-messages.md', 'auth-and-permissions.md', 'external-api-integration.md', 'deploy-and-ci.md')
}

foreach ($folder in $guidelineSets.Keys) {
    $dir = Join-Path $sharedRoot $folder
    if (-not (Test-Path -LiteralPath $dir)) {
        $failures += "Missing guidelines folder: plugin/skills/_shared/$folder/"
        continue
    }
    foreach ($file in $guidelineSets[$folder]) {
        $path = Join-Path $dir $file
        if (-not (Test-Path -LiteralPath $path)) {
            $failures += "Missing guideline: plugin/skills/_shared/$folder/$file"
        }
        elseif ((Get-Item -LiteralPath $path).Length -lt 200) {
            $failures += "Guideline too small: plugin/skills/_shared/$folder/$file"
        }
    }
}

$jsGuidelines = @('typescript-strict.md', 'dom-patterns.md')
foreach ($file in $jsGuidelines) {
    $path = Join-Path $sharedRoot "javascript_guidelines\$file"
    if (-not (Test-Path -LiteralPath $path)) {
        $failures += "Missing guideline: plugin/skills/_shared/javascript_guidelines/$file"
    }
}

$feTesting = Join-Path $sharedRoot 'frontend_guidelines\frontend-testing.md'
if (-not (Test-Path -LiteralPath $feTesting)) {
    $failures += 'Missing: plugin/skills/_shared/frontend_guidelines/frontend-testing.md'
}

$reactPerf = Join-Path $sharedRoot 'react_guidelines\react-performance.md'
if (-not (Test-Path -LiteralPath $reactPerf)) {
    $failures += 'Missing: plugin/skills/_shared/react_guidelines/react-performance.md'
}

$frontendPractices = Join-Path $sharedRoot 'frontend_guidelines\frontend-practices.md'
if (-not (Test-Path -LiteralPath $frontendPractices)) {
    $failures += 'Missing: plugin/skills/_shared/frontend_guidelines/frontend-practices.md'
}
else {
    $fpContent = Get-Content -LiteralPath $frontendPractices -Raw
    $forbiddenMarkers = @('glassmorphism', 'Use web fonts (like Inter')
    foreach ($marker in $forbiddenMarkers) {
        if ($fpContent -match [regex]::Escape($marker)) {
            $failures += "frontend-practices.md contains forbidden marker: $marker"
        }
    }
    if ($fpContent -notmatch 'DESIGN-BRIEF') {
        $failures += 'frontend-practices.md should reference DESIGN-BRIEF'
    }
}

$stackSkillsWithBrief = @(
    'react_developer', 'angular_developer', 'javascript_developer',
    'vue_developer', 'blazor_developer', 'electron_developer', 'blip_plugin_developer'
)
foreach ($skill in $stackSkillsWithBrief) {
    $skillPath = Join-Path $skillsRoot "$skill\SKILL.md"
    if (Test-Path -LiteralPath $skillPath) {
        $content = Get-Content -LiteralPath $skillPath -Raw
        if ($content -notmatch 'DESIGN-BRIEF') {
            $failures += "plugin/skills/$skill/SKILL.md missing DESIGN-BRIEF marker"
        }
    }
}

$developerPath = Join-Path $skillsRoot 'developer\SKILL.md'
if (Test-Path -LiteralPath $developerPath) {
    $devContent = Get-Content -LiteralPath $developerPath -Raw
    foreach ($skill in @('vue_developer', 'blazor_developer', 'electron_developer', 'blip_plugin_developer')) {
        if ($devContent -notmatch [regex]::Escape($skill)) {
            $failures += "developer/SKILL.md missing router entry for: $skill"
        }
    }
}

$impeccablePath = Join-Path $skillsRoot 'impeccable\SKILL.md'
if (Test-Path -LiteralPath $impeccablePath) {
    $impContent = Get-Content -LiteralPath $impeccablePath -Raw
    foreach ($skill in @('vue_developer', 'blazor_developer', 'electron_developer')) {
        if ($impContent -notmatch [regex]::Escape($skill)) {
            $failures += "impeccable/SKILL.md missing handoff for: $skill"
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host 'Frontend ecosystem validation FAILED:' -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    exit 1
}

Write-Host 'Frontend ecosystem validation passed.' -ForegroundColor Green
exit 0
