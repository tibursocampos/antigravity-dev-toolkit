#Requires -Version 5.1
<#
.SYNOPSIS
  Interactive CLI orchestrator for the Antigravity Dev Toolkit.

.DESCRIPTION
  Provides a menu to run sync, validations, and maintenance scripts without
  needing to remember the individual script paths or parameters.
#>
$ErrorActionPreference = 'Stop'

$scriptDir = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($scriptDir)) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
}

function Show-Menu {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host " Antigravity Toolkit - Smart Manager" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "[1] Sincronizar Toolkit (Deploy para Antigravity)"
    Write-Host "[2] Rodar Smoke Tests (validate-all)"
    Write-Host "[3] Deploy & Test (Sincronizar + validate-all)"
    Write-Host "[4] Validacao Completa (inclui Session Gates)"
    Write-Host "[5] Executar Suite de Manutencao (Normalizar e Arrumar Gates)"
    Write-Host "[6] Configurar Repositorio Atual para SDD (manifest classic)"
    Write-Host "[7] Validacao e backup (submenu)"
    Write-Host "[0] Sair"
    Write-Host "=========================================" -ForegroundColor Cyan
}

function Show-ValidationBackupMenu {
    Write-Host ''
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host " Validacao e backup" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "[1] validate-all (suite completa)"
    Write-Host "[2] skill-contracts only"
    Write-Host "[3] skill-graph only"
    Write-Host "[4] skill-fixtures only"
    Write-Host "[5] docs-consistency only"
    Write-Host "[6] Listar sync backups"
    Write-Host "[7] Restore backup (pede BackupId)"
    Write-Host "[0] Voltar"
    Write-Host "=========================================" -ForegroundColor Cyan
}

function Run-Script {
    param([string]$Path, [string]$ArgsStr = "")
    Write-Host "`n>>> Executando: $Path $ArgsStr" -ForegroundColor Yellow
    $fullPath = Join-Path $scriptDir $Path
    if (-not (Test-Path $fullPath)) {
        Write-Host "Erro: Arquivo nao encontrado ($fullPath)" -ForegroundColor Red
        return $false
    }

    $pwshExe = (Get-Process -Id $PID).Path
    $procArgs = @("-ExecutionPolicy", "Bypass", "-File", $fullPath)
    if (-not [string]::IsNullOrWhiteSpace($ArgsStr)) {
        $procArgs += $ArgsStr.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
    }

    & $pwshExe @procArgs | Out-Host

    if ($LASTEXITCODE -eq 0) {
        Write-Host ">>> Sucesso: $Path" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host ">>> Falha (ExitCode: $LASTEXITCODE): $Path" -ForegroundColor Red
        return $false
    }
}

function Invoke-ValidationBackupSubmenu {
    while ($true) {
        Show-ValidationBackupMenu
        $sub = Read-Host "Escolha uma opcao"
        switch ($sub) {
            '1' {
                $null = Run-Script "validation\validate-all.ps1"
            }
            '2' {
                $null = Run-Script "validation\validate-skill-contracts.ps1"
            }
            '3' {
                $null = Run-Script "validation\validate-skill-graph.ps1"
            }
            '4' {
                $null = Run-Script "validation\validate-skill-fixtures.ps1"
            }
            '5' {
                $null = Run-Script "validation\validate-docs-consistency.ps1"
            }
            '6' {
                $null = Run-Script "restore-toolkit-backup.ps1"
            }
            '7' {
                $backupId = Read-Host "BackupId (yyyyMMdd-HHmmss)"
                if ([string]::IsNullOrWhiteSpace($backupId)) {
                    Write-Host "Restore cancelado (BackupId vazio)." -ForegroundColor DarkGray
                }
                else {
                    $null = Run-Script "restore-toolkit-backup.ps1" "-BackupId $backupId"
                }
            }
            '0' {
                return
            }
            default {
                Write-Host "Opcao invalida." -ForegroundColor Red
            }
        }

        Write-Host "`nPressione Enter para continuar..." -ForegroundColor DarkGray
        $null = Read-Host
    }
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Escolha uma opcao"

    switch ($choice) {
        '1' {
            $null = Run-Script "sync-antigravity.ps1"
        }
        '2' {
            $null = Run-Script "validation\validate-all.ps1"
        }
        '3' {
            if (Run-Script "sync-antigravity.ps1") {
                $null = Run-Script "validation\validate-all.ps1"
            }
        }
        '4' {
            $null = Run-Script "validation\validate-all.ps1" "-IncludeSessionGate"
        }
        '5' {
            Write-Host "`nIniciando Suite de Manutencao..." -ForegroundColor Cyan
            $null = Run-Script "maintainers\normalize-skill-encoding.ps1"
            $null = Run-Script "maintainers\fix-skill-gates.ps1"
            $null = Run-Script "maintainers\inject-skill-gates.ps1"
        }
        '6' {
            Write-Host "`nConfigurando manifest classic (features/ + memory-bank) para o CWD atual..." -ForegroundColor Yellow
            $null = Run-Script "configure-repo-sdd.ps1" "-StorageMode repository"
        }
        '7' {
            Invoke-ValidationBackupSubmenu
            continue
        }
        '0' {
            Write-Host "Saindo..." -ForegroundColor Cyan
            exit 0
        }
        default {
            Write-Host "Opcao invalida." -ForegroundColor Red
        }
    }

    Write-Host "`nPressione Enter para continuar..." -ForegroundColor DarkGray
    $null = Read-Host
}
