#Requires -Version 5.1
<#
.SYNOPSIS
  Backup helpers for antigravity-dev-toolkit deploy targets.
#>
function Get-ToolkitUserHome {
    if (-not [string]::IsNullOrWhiteSpace($env:HOME)) { return $env:HOME }
    return [Environment]::GetFolderPath('UserProfile')
}

function Get-AntigravitySddRoot {
    return (Join-Path (Get-ToolkitUserHome) '.gemini\antigravity-ide\sdd')
}

function New-AntigravityToolkitBackup {
    param(
        [string] $PluginDest,
        [switch] $DryRun
    )

    $sddRoot = Get-AntigravitySddRoot
    $backupRoot = Join-Path $sddRoot 'toolkit-backups'
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupDir = Join-Path $backupRoot $stamp

    $targets = @()
    if (-not [string]::IsNullOrWhiteSpace($PluginDest) -and (Test-Path -LiteralPath $PluginDest)) {
        $targets += @{ Name = 'plugin'; Path = $PluginDest }
    }
    $guardrailsKi = Join-Path (Get-ToolkitUserHome) '.gemini\antigravity-ide\knowledge\global_guardrails'
    if (Test-Path -LiteralPath $guardrailsKi) {
        $targets += @{ Name = 'global_guardrails'; Path = $guardrailsKi }
    }

    if ($targets.Count -eq 0) {
        Write-Host '[antigravity-dev-toolkit] No existing deploy to backup.' -ForegroundColor DarkGray
        return $null
    }

    if ($DryRun) {
        Write-Host "[antigravity-dev-toolkit] Would backup to: $backupDir" -ForegroundColor Cyan
        return $backupDir
    }

    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    foreach ($t in $targets) {
        $dest = Join-Path $backupDir $t.Name
        Copy-Item -LiteralPath $t.Path -Destination $dest -Recurse -Force
    }

    $manifest = @{
        createdUtc = [datetime]::UtcNow.ToString('o')
        pluginDest = $PluginDest
        targets    = @($targets | ForEach-Object { $_.Name })
    } | ConvertTo-Json
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText((Join-Path $backupDir 'backup-manifest.json'), $manifest, $utf8)

    Write-Host "[antigravity-dev-toolkit] Backup created: $backupDir" -ForegroundColor Green
    return $backupDir
}
