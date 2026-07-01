#Requires -Version 5.1
<#
.SYNOPSIS
  Validates the presence and structure of the Impeccable Ecosystem skills.

.DESCRIPTION
  Ensures that impeccable_developer, impeccable_ui, impeccable_components,
  impeccable_state, and impeccable_a11y exist and have SKILL.md with correct YAML frontmatter.

.EXAMPLE
  .\scripts\validation\validate-impeccable-skills.ps1
#>
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = $PSScriptRoot
$repoRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$skillsDir = Join-Path $repoRoot "plugin\skills"

$expectedSkills = @(
    "impeccable_developer",
    "impeccable_ui",
    "impeccable_components",
    "impeccable_state",
    "impeccable_a11y"
)

$hasErrors = $false

foreach ($skill in $expectedSkills) {
    $skillDir = Join-Path $skillsDir $skill
    $skillMd = Join-Path $skillDir "SKILL.md"

    if (-not (Test-Path $skillMd -PathType Leaf)) {
        Write-Host "[ERROR] Missing SKILL.md for $skill in $skillDir" -ForegroundColor Red
        $hasErrors = $true
        continue
    }

    $content = Get-Content $skillMd -Raw
    
    # Simple check for frontmatter
    if ($content -notmatch '(?s)^---\r?\n.*?\r?\n---') {
        Write-Host "[ERROR] Missing or invalid YAML frontmatter in $skillMd" -ForegroundColor Red
        $hasErrors = $true
    }
}

if ($hasErrors) {
    Write-Host "Validation failed for Impeccable skills." -ForegroundColor Red
    exit 1
}

Write-Host "Impeccable skills validation passed." -ForegroundColor Green
exit 0
