#Requires -Version 5.1
<#
.SYNOPSIS
  Runs the antigravity-dev-toolkit smoke test suite.

.DESCRIPTION
  Orchestrates deploy, structure, docs, and language validations. Optional
  session-gate checks are available via flags.

.PARAMETER RepoPath
  Repository path for optional session-gate validation.

.PARAMETER IncludeSessionGate
  Run validate-session-gates.ps1.

.PARAMETER RequiredGate
  Gate name when IncludeSessionGate is enabled.

.PARAMETER FailFast
  Stop on first failing check.

.PARAMETER Quiet
  Suppress per-check banners; print summary only.

.EXAMPLE
  .\scripts\validation\validate-all.ps1

.EXAMPLE
  .\scripts\validation\validate-all.ps1 -IncludeSessionGate -RepoPath "D:\Source\Repos\MyApp"
#>
[CmdletBinding()]
param(
    [string] $RepoPath = (Get-Location).Path,
    [switch] $IncludeSessionGate,
    [ValidateSet('storage_confirmed', 'write_confirmed', 'step_confirmed', 'tests_run')]
    [string] $RequiredGate = 'write_confirmed',
    [switch] $FailFast,
    [switch] $Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($scriptDir)) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
}

function Invoke-ValidationCheck {
    param(
        [string] $Name,
        [string] $ScriptPath,
        [hashtable] $Arguments = @{}
    )

    if (-not $Quiet) {
        Write-Host ''
        Write-Host "=== $Name ===" -ForegroundColor Cyan
    }

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        Write-Host "Missing script: $ScriptPath" -ForegroundColor Red
        return [PSCustomObject]@{ Name = $Name; Status = 'FAIL'; ExitCode = 1 }
    }

    & $ScriptPath @Arguments
    $code = $LASTEXITCODE
    $status = if ($code -eq 0) { 'PASS' } else { 'FAIL' }
    return [PSCustomObject]@{ Name = $Name; Status = $status; ExitCode = $code }
}

$results = @()

$coreChecks = @(
    @{ Name = 'deploy'; Script = 'validate-toolkit-deploy.ps1'; Args = @{} },
    @{ Name = 'skills-structure'; Script = 'validate-skills-structure.ps1'; Args = @{} },
    @{ Name = 'docs-consistency'; Script = 'validate-docs-consistency.ps1'; Args = @{} },
    @{ Name = 'skills-english'; Script = 'validate-skills-english.ps1'; Args = @{} },
    @{ Name = 'impeccable-skill'; Script = 'validate-impeccable-skill.ps1'; Args = @{} },
    @{ Name = 'blip-plugin-skill'; Script = 'validate-blip-plugin-skill.ps1'; Args = @{} },
    @{ Name = 'frontend-ecosystem'; Script = 'validate-frontend-ecosystem.ps1'; Args = @{} },
    @{ Name = 'skill-contracts'; Script = 'validate-skill-contracts.ps1'; Args = @{} },
    @{ Name = 'skill-graph'; Script = 'validate-skill-graph.ps1'; Args = @{} },
    @{ Name = 'skill-fixtures'; Script = 'validate-skill-fixtures.ps1'; Args = @{} }
)

foreach ($check in $coreChecks) {
    $result = Invoke-ValidationCheck -Name $check.Name -ScriptPath (Join-Path $scriptDir $check.Script) -Arguments $check.Args
    $results += $result

    if ($FailFast -and $result.Status -eq 'FAIL') {
        break
    }
}

if (-not ($FailFast -and ($results | Where-Object { $_.Status -eq 'FAIL' }))) {
    if ($IncludeSessionGate) {
        $result = Invoke-ValidationCheck `
            -Name 'session-gate' `
            -ScriptPath (Join-Path $scriptDir 'validate-session-gates.ps1') `
            -Arguments @{ RepoPath = $RepoPath; RequiredGate = $RequiredGate }
        $results += $result
    }
    else {
        $results += [PSCustomObject]@{ Name = 'session-gate'; Status = 'SKIP'; ExitCode = 0 }
    }
}

Write-Host ''
Write-Host 'Smoke test summary' -ForegroundColor Cyan
Write-Host '----------------' -ForegroundColor Cyan
foreach ($result in $results) {
    $color = switch ($result.Status) {
        'PASS' { [ConsoleColor]::Green }
        'FAIL' { [ConsoleColor]::Red }
        'SKIP' { [ConsoleColor]::DarkGray }
        default { [ConsoleColor]::Gray }
    }
    Write-Host ("{0,-20} {1}" -f $result.Name, $result.Status) -ForegroundColor $color
}

$failed = @($results | Where-Object { $_.Status -eq 'FAIL' })
if ($failed.Count -gt 0) {
    Write-Host ''
    Write-Host "Smoke test FAILED ($($failed.Count) check(s))." -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host 'Smoke test PASSED.' -ForegroundColor Green
exit 0
