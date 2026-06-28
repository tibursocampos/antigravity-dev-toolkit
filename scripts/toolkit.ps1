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
    Write-Host "[1] 🚀 Sincronizar Toolkit (Deploy para Antigravity)"
    Write-Host "[2] 🧪 Rodar Smoke Tests (Core)"
    Write-Host "[3] ✨ Deploy & Test (Sincronizar + Smoke Tests)"
    Write-Host "[4] 🛡️ Validação Completa (inclui Spec Kit e Gates)"
    Write-Host "[5] 🔧 Executar Suíte de Manutenção (Normalizar e Arrumar Gates)"
    Write-Host "[6] 📦 Configurar Repositório Atual para SDD (setup-speckit & config)"
    Write-Host "[0] ❌ Sair"
    Write-Host "=========================================" -ForegroundColor Cyan
}

function Run-Script {
    param([string]$Path, [string]$ArgsStr = "")
    Write-Host "`n>>> Executando: $Path $ArgsStr" -ForegroundColor Yellow
    $fullPath = Join-Path $scriptDir $Path
    if (-not (Test-Path $fullPath)) {
        Write-Host "Erro: Arquivo não encontrado ($fullPath)" -ForegroundColor Red
        return $false
    }
    
    $pwshExe = (Get-Process -Id $PID).Path
    $procArgs = @("-ExecutionPolicy", "Bypass", "-File", $fullPath)
    if (-not [string]::IsNullOrWhiteSpace($ArgsStr)) {
        # Simple split by space for args.
        $procArgs += $ArgsStr.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
    }

    & $pwshExe @procArgs
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ">>> Sucesso: $Path" -ForegroundColor Green
        return $true
    } else {
        Write-Host ">>> Falha (ExitCode: $LASTEXITCODE): $Path" -ForegroundColor Red
        return $false
    }
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Escolha uma opção"

    switch ($choice) {
        '1' {
            Run-Script "sync-antigravity.ps1"
        }
        '2' {
            Run-Script "validation\validate-all.ps1"
        }
        '3' {
            if (Run-Script "sync-antigravity.ps1") {
                Run-Script "validation\validate-all.ps1"
            }
        }
        '4' {
            Run-Script "validation\validate-all.ps1" "-IncludeSpeckit -IncludeSessionGate"
        }
        '5' {
            Write-Host "`nIniciando Suíte de Manutenção..." -ForegroundColor Cyan
            Run-Script "maintainers\normalize-skill-encoding.ps1"
            Run-Script "maintainers\fix-skill-gates.ps1"
            Run-Script "maintainers\inject-skill-gates.ps1"
        }
        '6' {
            Write-Host "`nCertifique-se de que o npm está instalado." -ForegroundColor Yellow
            if (Run-Script "setup-speckit.ps1") {
                Run-Script "configure-repo-sdd.ps1"
            }
        }
        '0' {
            Write-Host "Saindo..." -ForegroundColor Cyan
            exit 0
        }
        default {
            Write-Host "Opção inválida." -ForegroundColor Red
        }
    }
    
    Write-Host "`nPressione Enter para continuar..." -ForegroundColor DarkGray
    $null = Read-Host
}
