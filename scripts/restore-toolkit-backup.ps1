#Requires -Version 5.1
<#
.SYNOPSIS
  Restores a previous antigravity-dev-toolkit sync backup.

.PARAMETER BackupId
  Timestamp folder under ~/.gemini/antigravity-ide/sdd/toolkit-backups/.

.EXAMPLE
  .\scripts\restore-toolkit-backup.ps1
  .\scripts\restore-toolkit-backup.ps1 -BackupId 20260720-091500
#>
[CmdletBinding()]
param(
    [string] $BackupId,
    [switch] $DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '_lib\Backup-AntigravityToolkit.ps1')

$backupRoot = Join-Path (Get-AntigravitySddRoot) 'toolkit-backups'
if (-not (Test-Path -LiteralPath $backupRoot)) {
    Write-Host "No backups found at $backupRoot" -ForegroundColor Yellow
    exit 0
}

$available = @(Get-ChildItem -LiteralPath $backupRoot -Directory | Sort-Object Name -Descending)
if ($available.Count -eq 0) {
    Write-Host "No backup folders under $backupRoot" -ForegroundColor Yellow
    exit 0
}

if ([string]::IsNullOrWhiteSpace($BackupId)) {
    Write-Host 'Available backups (newest first):' -ForegroundColor Cyan
    $available | ForEach-Object { Write-Host "  $($_.Name)" }
    Write-Host ''
    Write-Host 'Re-run with -BackupId <id> to restore.' -ForegroundColor DarkGray
    exit 0
}

$backupDir = Join-Path $backupRoot $BackupId
if (-not (Test-Path -LiteralPath $backupDir)) {
    Write-Host "Backup not found: $backupDir" -ForegroundColor Red
    exit 1
}

$manifestPath = Join-Path $backupDir 'backup-manifest.json'
$pluginDest = $null
if (Test-Path -LiteralPath $manifestPath) {
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    if ($manifest.PSObject.Properties.Name -contains 'pluginDest') {
        $pluginDest = $manifest.pluginDest
    }
}

$pluginBackup = Join-Path $backupDir 'plugin'
if ((Test-Path -LiteralPath $pluginBackup) -and -not [string]::IsNullOrWhiteSpace($pluginDest)) {
    if ($DryRun) {
        Write-Host "Would restore plugin -> $pluginDest" -ForegroundColor Cyan
    }
    else {
        if (Test-Path -LiteralPath $pluginDest) {
            Remove-Item -LiteralPath $pluginDest -Recurse -Force
        }
        $parent = Split-Path -Parent $pluginDest
        if (-not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        Copy-Item -LiteralPath $pluginBackup -Destination $pluginDest -Recurse -Force
        Write-Host "Restored plugin to $pluginDest" -ForegroundColor Green
    }
}
else {
    Write-Host 'Plugin backup or destination missing; skipped plugin restore.' -ForegroundColor Yellow
}

Write-Host "Restore complete from $BackupId" -ForegroundColor Green
exit 0
