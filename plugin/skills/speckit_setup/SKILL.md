---
name: speckit-setup
description: >
  Configure and install all GitHub Spec Kit dependencies (Python, uv, specify-cli)
  and global directories on Windows. Use when asked for dependency setup or /speckit_setup.
---

## STOP - Read before ANY tool call

1. Read `{pluginRoot}/GUARDRAILS.md`
2. Read `_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`
3. If the relevant gate is not approved: **STOP** - ask user **(pt-BR)** - do **NOT** Write/Shell
4. SDD/develop skills: after **ONE** step/task, **STOP** session - handoff only
5. This skill body is **English**; user-facing prompts may be **(pt-BR)**

### Step -1 - Gate check (report in chat before continuing)

```
Gate check:
[ ] GUARDRAILS.md read
[ ] SESSION.md read; session-state loaded
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
- If any unchecked: STOP
```

---

# Skill: speckit_setup

## Trigger

Invoke when the user asks for: `use skill speckit_setup`, `setup speckit`, `install spec kit`, or `/speckit_setup`.

## Outcome

Environment ready for Spec Kit skills: Python 3.10+, `uv`, and `specify-cli` installed and accessible in PATH. Global directories initialized at `$env:USERPROFILE\.gemini\antigravity-ide\sdd\`.

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Storage schema v2 and manifest | `_shared/sdd_artifacts/STORAGE.md` § Global Manifest |

## Process

### -1. Storage reference

Load `STORAGE.md` schema v2 as reference and use `$Workflow = speckit` semantics for manifest compatibility. This skill prepares prerequisites and does not run write flows for specs/plans/tasks.

### 1. Check Python

Run: `python --version`

- **Success** (3.10+): proceed to step 2.
- **Failure** (command not found or version < 3.10):
  - Ask user (pt-BR):
    > *"O Python 3.10+ nao foi encontrado no PATH. Deseja que eu tente instala-lo automaticamente via winget? (sim / nao)"*
  - If **sim**: run `winget install -e --id Python.Python.3.12`
    - If it fails: show the manual instructions below and stop.
  - If **nao** or failure: show and stop:
    > *"Nao consegui instalar o Python automaticamente (falha no comando ou falta de permissao administrativa)."*
    >
    > *"Por favor, resolva manualmente:"*
    > *"1. Abra o terminal como Administrador e rode: `winget install -e --id Python.Python.3.12`"*
    > *"2. Ou baixe o instalador oficial: https://www.python.org/downloads/"*

### 2. Check `uv`

Run: `uv --version`

- **Success**: proceed to step 3.
- **Failure**:
  - Ask user (pt-BR):
    > *"O gerenciador 'uv' nao foi encontrado. Deseja que eu execute a instalacao? (sim / nao)"*
  - If **sim**: run `powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"`
    - If it fails: show manual instructions below and stop.
  - If **nao** or failure: show and stop:
    > *"Por favor, instale o `uv` manualmente executando este comando no terminal:"*
    >
    > ```powershell
    > powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
    > ```

### 3. Install `specify-cli`

Run: `specify --version`

- **Success**: proceed to step 4.
- **Failure**:
  - Run: `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git --force`
  - If it fails: show the command above and ask the user to run it locally.

### 4. Initialize global directories

1. Check whether `$env:USERPROFILE\.gemini\antigravity-ide\sdd\` exists. If not, create it.
2. Check whether `$env:USERPROFILE\.gemini\antigravity-ide\sdd\manifest.json` exists. If not, create it with:
   ```json
   {"schema_version":2,"repositories":{}}
   ```
3. Confirm in chat, Ask user (pt-BR) style:
   > *"✅ Setup do Spec Kit concluido. Todos os pre-requisitos estao instalados e o diretorio global de SDD foi inicializado."*

## Must not

- Assume Python or `uv` are available without checking
- Skip confirmation prompt before running installers (`winget`, `uv` install script)
- Fail silently - always show manual instructions on failure

## Handoff

```
use skill speckit_init
```
