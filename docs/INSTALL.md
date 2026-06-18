# Installation: antigravity-dev-toolkit

This repository contains the personal development toolkit for the Antigravity IDE (Gemini).

## Prerequisites
- Windows (Powershell)
- Antigravity IDE installed and running (so that the `~/.gemini` folder exists)

## Installation Steps

1. Clone the repository to your machine (e.g., `D:\Source\Repos\antigravity-dev-toolkit`).
2. Open a PowerShell terminal in the repository root.
3. Run the synchronization script:

   ```powershell
   .\scripts\sync-antigravity.ps1
   ```

4. The script will copy the `plugin/` directory to the Antigravity IDE plugins folder (`~/.gemini/antigravity-ide/plugins/Local.raphadev.antigravity-dev-toolkit`).
5. The copy process is idempotent (based on SHA-256 hashes), copying only modified files and avoiding unnecessary overwrites.
6. Optionally restart the chat sessions in the Antigravity IDE so that it loads/indexes the new skills effectively.

## Updating
Whenever you make local changes to the skills or rules (`_shared/`) in this base repository, run `.\scripts\sync-antigravity.ps1` again to apply the changes to the IDE.

---

## Setup do Spec Kit (Opcional)

As skills do Spec Kit dependem da CLI oficial do projeto GitHub.

### 1. Configuração Automática via Script PowerShell
Você pode configurar todos os pré-requisitos (Python, `uv` e `specify-cli`) e inicializar os diretórios globais executando o script utilitário a partir da raiz do repositório:
```powershell
.\scripts\setup-speckit.ps1
```

### 2. Configuração Automática via Chat
Alternativamente, chame a skill correspondente no chat do IDE:
```
/speckit_setup
```

### 3. Configuração Manual no Windows
Caso prefira instalar os pré-requisitos manualmente:
1. Instale o Python 3.10+
2. Instale o gerenciador de pacotes `uv`:
   ```powershell
   powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
   ```
3. Instale a ferramenta CLI do Spec Kit globalmente:
   ```powershell
   uv tool install specify-cli --from git+https://github.com/github/spec-kit.git --force
   ```

---

## Inicializando o Repositório

### Via Script PowerShell
Você pode inicializar a estrutura `.specify/` e registrar o repositório ativo no `manifest.json` com o modo de armazenamento desejado (`global` ou `repository`):
```powershell
.\scripts\configure-repo-sdd.ps1 -StorageMode global
```

### Via Chat
Ou chame as skills correspondentes no chat:
1. Inicializar e escolher o modo de armazenamento: `/speckit_init`
2. Criar especificações: `/speckit_spec`
