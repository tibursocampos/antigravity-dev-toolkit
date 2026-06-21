---
name: speckit-init
description: >
  Initialize the Spec Kit structure (.specify/) in the active repository or the configured
  global SDD path, generating an intelligent pre-filled constitution based on the detected stack.
  Use to initialize Spec Kit or /speckit_init.
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

# Skill: speckit_init

## Trigger

Invoke when the user asks for: `use skill speckit_init`, `initialize speckit`, `init spec kit`, or `/speckit_init`.

## Outcome

`.specify/` structure created at the resolved destination (local repository or global directory), and `.specify/memory/constitution.md` configured with principles tailored to the detected project stack.

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Storage schema v2 and manifest | `_shared/sdd_artifacts/STORAGE.md` § Global Manifest and Dynamic Storage Resolution |
| Repository guideline scan | `_shared/git_guidelines/git-flow.md` |
| Code principles | `_shared/code_guidelines/principles/` |
| .NET rules | `_shared/dotnet_guidelines/` |
| Frontend rules | `_shared/frontend_guidelines/` |

## Process

### -1. Check prerequisites

Run: `specify --version`

- If the command fails:
  - Ask user (pt-BR):
    > *"A CLI do Spec Kit nao foi encontrada. Execute primeiro: `use skill speckit_setup`."*
  - Stop.

### 1. Resolve storage

Load `STORAGE.md` schema v2 and run the dynamic storage resolution algorithm with parameter `$Workflow = speckit`. Resolve `storage_mode` and `path` for the active repository (`$Cwd`). On first run for this repository, execute the storage mode selection flow.

### 2. Check existing `.specify/` and validate state

Check whether `.specify/` already exists at the resolved destination.

- **Does not exist**: proceed to step 3.
- **Exists**:
  1. Run `scripts/validate-speckit-init.ps1` (or equivalent resolved script path).
  2. If validation **passes**:
     - Ask user (pt-BR):
       > *"A estrutura `.specify/` ja existe em `{destino}` e a validacao foi aprovada. Deseja manter como esta e encerrar? (sim / nao)"*
     - If **sim**: stop without changes.
     - If **nao**: continue to step 3 only with explicit confirmation to reinitialize.
  3. If validation **fails**:
     - Ask user (pt-BR):
       > *"A estrutura `.specify/` existe, mas a validacao falhou. Deseja que eu tente reparar/reinicializar agora? (sim / nao)"*
     - If **sim**: continue to step 3 (repair/reinit path).
     - If **nao**: stop and report the validation output.

### 3. Initialize via CLI

| storage_mode | Command |
|---|---|
| `repository` | `specify init . --integration generic --integration-options="--commands-dir .specify/commands/" --force` |
| `global` | Create `{path}` if missing, then run `specify init {path} --integration generic --integration-options="--commands-dir .specify/commands/" --force` |

If the command fails:
- Show the error output in chat.
- Suggest checking installation with `specify --version`.

### 3.5. Smart constitution pre-fill

After successful initialization, scan `$Cwd` to detect stack and pre-fill constitution.

1. Detect technologies:
   - Any `.csproj` or `.sln` -> **.NET / C#**
   - `package.json` -> **Node.js/JS/TS**
     - `@angular/` or `angular.json` -> **Angular**
     - `react` dependency -> **React**
   - `requirements.txt`, `pyproject.toml`, `Pipfile`, or `setup.py` -> **Python**
   - `plugin.json` or `.ps1` -> **PowerShell / Antigravity Plugin**
2. Load guidelines:
   - `_shared/git_guidelines/git-flow.md`
   - `_shared/code_guidelines/principles/` (SOLID, DRY, KISS, YAGNI)
   - If .NET detected: `_shared/dotnet_guidelines/clean-architecture.md`, `_shared/dotnet_guidelines/csharp-patterns.md`
   - If Angular/React detected: `_shared/frontend_guidelines/frontend-practices.md`
3. Write tailored principles to `.specify/memory/constitution.md`:
   - Up to 5 principles aligned with detected stack and shared rules
   - Add constraints for build tools and Git flow guardrails
4. Overwrite only if file still contains default placeholders (for example `[PRINCIPLE_1_NAME]`). If user customized it, do not modify.
5. Ask user (pt-BR): report detected stacks and configured principles.

### 4. Validate result

Check whether `.specify/memory/constitution.md` exists and contains custom principles.

- **Yes**, Ask user (pt-BR):
  > *"✅ Spec Kit inicializado em `{destino}`. A constitution inteligente foi gerada em `{destino}/.specify/memory/constitution.md`."*
- **No**, Ask user (pt-BR):
  > *"⚠️ A inicializacao completou, mas `constitution.md` nao foi encontrado. Verifique o diretorio manualmente."*

## Must not

- Overwrite an existing custom `.specify/memory/constitution.md`
- Initialize without confirming destination
- Run `specify init` without checking prerequisites
- Silently stop on invalid existing `.specify/`; always offer repair/reinit

## Handoff

```
use skill speckit_spec
```
