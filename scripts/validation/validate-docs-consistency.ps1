#Requires -Version 5.1
<#
.SYNOPSIS
  Checks docs for obsolete skill names and orphan skill references.

.DESCRIPTION
  Called by validate-all.ps1.
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

$docsRoot = Join-Path $RepoRoot 'docs'
$skillsRoot = Join-Path $RepoRoot 'plugin\skills'
$readmePath = Join-Path $RepoRoot 'README.md'

$obsoletePatterns = @(
    'use skill spec\b',
    'use skill plan\b',
    'use skill implement\b',
    'spec to plan to implement',
    'dev_persona always active',
    'loaded automatically'
)

$failures = @()
$files = @($readmePath) + (Get-ChildItem -LiteralPath $docsRoot -Recurse -Filter '*.md' | ForEach-Object { $_.FullName })

foreach ($file in $files) {
    if ($file -like '*ENFORCEMENT.md*') { continue }
    $content = Get-Content -LiteralPath $file -Raw
    foreach ($pattern in $obsoletePatterns) {
        if ($content -match $pattern) {
            $rel = $file.Substring($RepoRoot.Length).TrimStart('\', '/')
            $failures += "$rel : obsolete pattern '$pattern'"
        }
    }
}

$skillDirs = Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object { $_.Name -ne '_shared' }
$skillsMd = Join-Path $docsRoot 'SKILLS.md'
if (Test-Path -LiteralPath $skillsMd) {
    $catalog = Get-Content -LiteralPath $skillsMd -Raw
    foreach ($dir in $skillDirs) {
        $name = $dir.Name
        if ($catalog -notmatch [regex]::Escape($name)) {
            $failures += "SKILLS.md missing catalog entry for: $name"
        }
    }
}
else {
    $failures += 'docs/SKILLS.md missing (required catalog)'
}

# README Skills table must list every skill folder (CI parity with pastas)
if (Test-Path -LiteralPath $readmePath) {
    $readme = Get-Content -LiteralPath $readmePath -Raw
    foreach ($dir in $skillDirs) {
        $name = $dir.Name
        if ($readme -notmatch [regex]::Escape("``$name``")) {
            $failures += "README.md missing Skills table entry for: $name"
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host 'Docs consistency validation FAILED:' -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    exit 1
}

Write-Host 'Docs consistency validation passed.' -ForegroundColor Green
exit 0
