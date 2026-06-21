# SDD Workflow (`sdd_spec` → `sdd_plan` → `sdd_develop`)

Classic SDD is the mandatory structured path for medium/high complexity work.

## Skill sequence

1. `sdd_spec` — produce canonical PRD artifact.
2. `sdd_plan` — transform PRD into baby-step PLAN.
3. `sdd_develop` — implement exactly one PLAN step per session.

Deprecated naming (`spec`, `plan`, `implement`) should not be used in docs.

## Gate-first behavior

Before each stage:

- Read `GUARDRAILS.md`.
- Read `SESSION.md` and load session-state for current repo.
- Validate required gates.
- Ask for explicit `sim` before new writes or mutating actions.

## Artifact locations

Resolved from manifest v2:

`~/.gemini/antigravity-ide/sdd/manifest.json`

### `classic.storage_mode = repository`

- PRD: `PRD/NNN_feature_slug.md` or `docs/PRD/NNN_feature_slug.md`
- PLAN: `PLAN/PLAN_NNN_feature_slug.md`
- Ensure `.gitignore` includes SDD folders.

### `classic.storage_mode = global`

- Base: `~/.gemini/antigravity-ide/sdd/<RepoName>/`
- PRD and PLAN use the same canonical naming under that base path.

## Language policy in SDD

- Chat: `pt-BR`
- PRD and PLAN prose: default `pt-BR` (unless user asks English in that invocation)
- Code/tests/identifiers: English
- Skill source docs: English

## Completion constraints

- `sdd_develop` can execute only one step per session.
- Tests must run before marking a step completed.
- After completion, session gates are reset for the next step.

## Handoff examples

- `use skill sdd_plan — PRD/003_feature.md`
- `use skill sdd_develop — PLAN/PLAN_003_feature.md — Step 1`
