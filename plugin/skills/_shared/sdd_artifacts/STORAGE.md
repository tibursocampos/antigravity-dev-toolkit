# SDD artifact storage (spec / plan / implement)

Single source of truth for where PRD and PLAN files are written. Load on demand from skills - do not paste this file into PRD/PLAN bodies.

**Language:** This guideline file is **English**. Default **PRD/PLAN artifact** prose is **pt-BR**. **Chat** replies and the storage prompt below are **pt-BR** unless the user overrides in the skill invocation.

Install path after sync: `~/.gemini/antigravity-ide/plugins/Local.raphadev.antigravity-dev-toolkit/skills/_shared/sdd_artifacts/STORAGE.md`

## Storage modes

| Mode | PRD folder | PLAN folder |
|------|------------|-------------|
| **repository** | `PRD/` (preferred) or `docs/PRD/` | `PLAN/` at workspace root |

> **Nota:** O antigravity-dev-toolkit pode usar o modo `repository` (pastas locais) ou `global` (salvos externamente sob o caminho resolvido no `manifest.json`), dependendo da escolha registrada no `manifest.json`.

## Repository mode - `.gitignore`

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
   # SDD artifacts (local agent workflow - antigravity-dev-toolkit)
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
use skill sdd_plan - PRD/003_feature.md

use skill sdd_develop - PLAN/PLAN_003_feature.md - Step 1
```

## Invalid paths and promotion

**Forbidden** as final SDD destinations: `docs/backlog/`, generic `docs/*.md`, repo-root markdown without `NNN_` / `PLAN_NNN_` patterns.

When the user cites a non-canonical `.md`: read it, build the artifact per skill templates, confirm path (`PIPELINE.md` § Confirm before write), then `Write` only under `PRD/`, `docs/PRD/`, or `PLAN/`.

## Skill responsibilities

| Skill | Storage question | `.gitignore` | Writes |
|-------|------------------|--------------|--------|
| sdd_spec | Yes (confirm path) | Repository mode only | PRD |
| sdd_plan | Yes (if PRD does not specify) | Repository mode only | PLAN |
| sdd_develop | No - uses PLAN path from input | No | Updates same PLAN file |
| code_review | No | No | Read-only |
| fix_build | No | No | Read-only - do not invent PRD/PLAN paths |
| document_plan / document_implement | No | No | **Do not** use this file for `docs/documentation-plan/plan.md` |

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

## Global Manifest and Dynamic Storage Resolution (schema v2)

> **Used by:** all `sdd_*`, `speckit_*`, `refine_backlog_item`, `breakdown_tasks` skills.

### Manifest location

```
$env:USERPROFILE\.gemini\antigravity-ide\sdd\manifest.json
```

### Manifest structure (v2)

```json
{
  "schema_version": 2,
  "repositories": {
    "D:/Source/Repos/MyApp": {
      "classic": {
        "storage_mode": "global",
        "path": "C:/Users/me/.gemini/antigravity-ide/sdd/MyApp"
      },
      "speckit": {
        "storage_mode": "global",
        "path": "C:/Users/me/.gemini/antigravity-ide/sdd/MyApp",
        "initialized": true,
        "init_validated_at": "2026-06-21T12:00:00Z"
      }
    }
  }
}
```

### Legacy migration (v1 -> v2)

If a repository entry has top-level `storage_mode` and `path` (no `classic`/`speckit`):

```json
{
  "storage_mode": "repository",
  "path": "D:/Source/Repos/MyApp"
}
```

Migrate in memory to:

```json
{
  "classic": { "storage_mode": "repository", "path": "D:/Source/Repos/MyApp" },
  "speckit": { "storage_mode": "repository", "path": "D:/Source/Repos/MyApp", "initialized": false }
}
```

Write back to manifest on first skill run after migration.

### Resolution algorithm

Execute at skill load time, before any read or write. Parameter: `$Workflow` = `classic` | `speckit`.

```
1. Normalize $Cwd (replace \ with /, trim trailing /).
2. Read manifest.json; ensure schema_version = 2 (migrate v1 if needed).
3. Look up repositories[$Cwd].
4. If NOT found (first run):
   a. Ask user (pt-BR) storage for classic SDD (local vs global).
   b. Ask user (pt-BR) storage for Spec Kit (local vs global - may match classic path).
   c. Write classic + speckit sections; set speckit.initialized = false.
   d. Set session gate storage_confirmed = true after user sim.
5. If found: read repositories[$Cwd][$Workflow].storage_mode and .path.
6. For speckit skills (except setup/init): if speckit.initialized != true, run validate-speckit-init.ps1;
   if fail -> STOP - handoff to speckit_init.
```

### Physical path mapping

| storage_mode | Spec Kit | Classic PRD | Classic PLAN |
|---|---|---|---|
| `repository` | `$Cwd/.specify/` | `$Cwd/PRD/` or `$Cwd/docs/PRD/` | `$Cwd/PLAN/` |
| `global` | `<path>/.specify/` | `<path>/PRD/` | `<path>/PLAN/` |

`<path>` = `repositories[$Cwd][$Workflow].path`  
`<RepositoryName>` = last segment of `$Cwd` with `\` and `/` replaced by `_`.

### Handoff paths (v2)

```text
use skill sdd_plan - PRD/003_feature.md
use skill sdd_develop - PLAN/PLAN_003_feature.md - Step 1
use skill speckit_plan - .specify/specs/003-feature/spec.md
use skill speckit_develop - .specify/specs/003-feature/tasks.md
```

## Integration

- Pipeline guards: `_shared/sdd_artifacts/PIPELINE.md`
- Session gates: `_shared/sdd_artifacts/SESSION.md`
- Context management: `dev_persona` § Context Management

