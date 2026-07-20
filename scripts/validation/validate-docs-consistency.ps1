#Requires -Version 5.1
<#
.SYNOPSIS
  Checks docs for obsolete skill names, sibling toolkit refs, and GitHub CLI usage.

.DESCRIPTION
  Called by validate-all.ps1. Forbids cursor-dev-toolkit cross-refs and gh CLI.
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

$siblingForbidden = @(
    'cursor-dev-toolkit',
    'sync-cursor.ps1'
)

$ghForbiddenRegex = @(
    '(?i)(?<![\w/`.])gh (pr|run|api|auth|repo)\b',
    '(?i)`gh`',
    '(?i)GitHub/`gh`',
    '(?i)GitHub CLI example',
    '(?i)optional GitHub Actions via gh',
    '(?i)via gh\b'
)

$failures = @()

function Get-ToolkitMarkdownFiles {
    param([string] $Root)
    if (-not (Test-Path -LiteralPath $Root)) { return @() }
    return @(Get-ChildItem -LiteralPath $Root -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -eq '.md' } |
        ForEach-Object { $_.FullName })
}

$docFiles = @($readmePath) + (Get-ToolkitMarkdownFiles -Root $docsRoot)
$skillFiles = Get-ToolkitMarkdownFiles -Root $skillsRoot
$scanFiles = @($docFiles + $skillFiles | Select-Object -Unique)

foreach ($file in $scanFiles) {
    if (-not (Test-Path -LiteralPath $file)) { continue }
    if ($file -like '*ENFORCEMENT.md*') { continue }
    $content = Get-Content -LiteralPath $file -Raw
    if ([string]::IsNullOrEmpty($content)) { continue }
    $rel = $file.Substring($RepoRoot.Length).TrimStart('\', '/')
    $isDocSurface = ($file -eq $readmePath) -or ($file.StartsWith($docsRoot, [System.StringComparison]::OrdinalIgnoreCase))

    if ($isDocSurface) {
        foreach ($pattern in $obsoletePatterns) {
            if ($content -match $pattern) {
                $failures += "$rel : obsolete pattern '$pattern'"
            }
        }
    }

    foreach ($needle in $siblingForbidden) {
        if ($content.Contains($needle)) {
            $failures += "$rel : forbidden sibling/cross-toolkit reference '$needle'"
        }
    }

    foreach ($pattern in $ghForbiddenRegex) {
        if ($content -match $pattern) {
            $failures += "$rel : forbidden GitHub CLI pattern '$pattern'"
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
