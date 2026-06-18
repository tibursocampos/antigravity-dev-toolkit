# SDD artifact storage (spec / plan / implement)

Single source of truth for where PRD and PLAN files are written. Load on demand from skills — do not paste this file into PRD/PLAN bodies.

**Language:** This guideline file is **English**. Default **PRD/PLAN artifact** prose is **pt-BR**. **Chat** replies and the storage prompt below are **pt-BR** unless the user overrides in the skill invocation.

Install path after sync: `~/.gemini/antigravity-ide/plugins/Local.raphadev.antigravity-dev-toolkit/skills/_shared/sdd_artifacts/STORAGE.md`

## Storage modes

| Mode | PRD folder | PLAN folder |
|------|------------|-------------|
| **repository** | `PRD/` (preferred) or `docs/PRD/` | `PLAN/` at workspace root |

> **Nota:** O antigravity-dev-toolkit pode usar o modo `repository` (pastas locais) ou `global` (salvos externamente sob o caminho resolvido no `manifest.json`), dependendo da escolha registrada no `manifest.json`.

## Repository mode — `.gitignore`

Run **before** the first `Write` under any SDD folder in the workspace (`spec` or `plan`). Applies to **every** consumer repository.

1. Read `.gitignore` at workspace root. If missing, create it with the SDD block below.
2. **Always** require these four patterns in repository mode:

   | Pattern | When used |
   |---------|-----------|
   | `/PRD/` | Default PRD location (repo root only) |
   | `/PLAN/` | Default PLAN location (repo root only) |
   | `/docs/PRD/` | Alternate PRD location (`prd_folder`) |
   | `/docs/PLAN/` | Reserved alternate; ignore preemptively |

   Use leading `/` so `skills/plan/` and other paths named `plan` are not ignored.

3. If **any** of the four is missing, append the **full** block:

   ```gitignore
   # SDD artifacts (local agent workflow — antigravity-dev-toolkit)
   /PRD/
   /PLAN/
   /docs/PRD/
   /docs/PLAN/
   ```

4. Report: patterns added, or all four already present. Do not duplicate existing entries.

## PRD / PLAN numbering

Collect existing files from the workspace before assigning `NNN`:

| Location | Glob |
|----------|------|
| Workspace | `PRD/*.md`, `docs/PRD/*.md`, `PLAN/PLAN_*.md` |

Use the highest `NNN` across all matches, then +1. PLAN `NNN` must match the source PRD sequence.

## Filenames

| Artifact | Pattern |
|----------|---------|
| PRD | `NNN_short_feature_slug.md` (3-digit `NNN`, ASCII slug) |
| PLAN | `PLAN_NNN_short_feature_slug.md` |

## Handoff paths

Always pass the **full path** used on disk (relative to workspace):

```text
use skill plan — PRD/003_feature.md

use skill implement — PLAN/PLAN_003_feature.md — Step 1
```

## Invalid paths and promotion

**Forbidden** as final SDD destinations: `docs/backlog/`, generic `docs/*.md`, repo-root markdown without `NNN_` / `PLAN_NNN_` patterns.

When the user cites a non-canonical `.md`: read it, build the artifact per skill templates, confirm path (`PIPELINE.md` § Confirm before write), then `Write` only under `PRD/`, `docs/PRD/`, or `PLAN/`.

## Skill responsibilities

| Skill | Storage question | `.gitignore` | Writes |
|-------|------------------|--------------|--------|
| spec | Sim (confirmar path) | Repository mode only | PRD |
| plan | Sim (se PRD não indicar) | Repository mode only | PLAN |
| implement | Não — usa path do PLAN do input | Não | Atualiza mesmo arquivo PLAN |
| code-review | Não | Não | Somente leitura |
| fix-build | Não | Não | Somente leitura — não inventar paths PRD/PLAN |
| plan-repo-docs / document-repo | Não | Não | **Não** usar este arquivo para `docs/documentation-plan/plan.md` (plano de documentação RAG, não SDD) |

## Read-only discovery (other skills)

When a skill needs an **existing** SDD PRD or PLAN and the user did not pass a full path:

1. Glob both `PRD/*.md`, `docs/PRD/*.md` and `PLAN/PLAN_*.md` in the workspace.
2. Pair PRD and PLAN by `NNN` when both are needed.
3. Hand off with **full paths**.
4. If zero or multiple pairs remain ambiguous after a full search, ask once in **pt-BR** with numbered full paths.

**Not SDD:** `docs/documentation-plan/plan.md` and `docs/overview.md` belong to `plan-repo-docs` / `document-repo` only.

## Integration

- Pipeline guards: `_shared/sdd_artifacts/PIPELINE.md`
- Context management: `dev_persona` § Gestão de Contexto

---

## Global Manifest and Dynamic Storage Resolution

> **Used by:** `speckit_setup`, `speckit_init`, `speckit_spec`, `speckit_plan`, `speckit_develop`, `sdd_spec`, `sdd_plan`, `sdd_develop`. All Spec Kit and classic SDD skills now use this resolution algorithm.

### Manifest location

```
$env:USERPROFILE\.gemini\antigravity-ide\sdd\manifest.json
```

### Manifest structure

```json
{
  "repositories": {
    "D:/Source/Repos/Blip/GM.Flows": {
      "storage_mode": "global",
      "path": "C:/Users/rapha/.gemini/antigravity-ide/sdd/Blip_GM_Flows"
    },
    "D:/Source/Repos/antigravity-dev-toolkit": {
      "storage_mode": "repository",
      "path": "D:/Source/Repos/antigravity-dev-toolkit"
    }
  }
}
```

### Resolution algorithm (Spec Kit skills only)

Execute at skill load time, before any read or write:

```
1. Read $Cwd (active workspace working directory).
2. Check whether $env:USERPROFILE\.gemini\antigravity-ide\sdd\manifest.json exists.
   - If it does not exist: create the sdd/ folder and manifest.json with {"repositories": {}}.
3. Look up the key matching $Cwd in the "repositories" object.

4. If the key is NOT found (first run on this repository):
   a. Pause and ask the user (pt-BR):
      "Identifiquei que este é o primeiro uso das skills de SDD neste repositório.
       Onde você prefere salvar as especificações e planos (.md)?
       1) No repositório local (pastas /PRD e /PLAN ou /.specify)
       2) No diretório global compartilhado (salvo externamente em
          ~/.gemini/antigravity-ide/sdd/ para não poluir o repositório)"
   b. If "1" or "local":
      - storage_mode: "repository"
      - path: $Cwd
   c. If "2" or "global":
      - storage_mode: "global"
      - path: $env:USERPROFILE\.gemini\antigravity-ide\sdd\<RepositoryName>
   d. Write the entry to manifest.json.
   e. If global mode: create the folder at the defined path if it does not exist.

5. If the key IS found: read storage_mode and path directly.
```

### Physical path mapping

| storage_mode | Spec Kit target | Classic SDD PRD | Classic SDD PLAN |
|---|---|---|---|
| `repository` | `$Cwd/.specify/` | `$Cwd/PRD/` | `$Cwd/PLAN/` |
| `global` | `<path>/.specify/` | `<path>/PRD/` | `<path>/PLAN/` |

`<path>` = resolved value of the `path` field in the manifest for the active repository.
`<RepositoryName>` = last segment of `$Cwd` with path separators replaced by `_`.
