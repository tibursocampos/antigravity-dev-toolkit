# Guide 04: Spec Kit Workflow

Flow:

`speckit_setup` → `speckit_init` → `speckit_spec` → `speckit_plan` → `speckit_develop`

## Step details

1. `use skill speckit_setup`
   - verifies/install Python, `uv`, `specify-cli`
   - ensures global SDD root and manifest exist

2. `use skill speckit_init`
   - resolves storage through manifest v2 (`speckit` section)
   - initializes `.specify/` and `constitution.md`
   - must pass `validate-speckit-init.ps1`

3. `use skill speckit_spec`
   - creates `.specify/specs/NNN-<slug>/spec.md`

4. `use skill speckit_plan`
   - creates `.specify/specs/NNN-<slug>/plan.md` and `tasks.md`

5. `use skill speckit_develop`
   - executes exactly one task per session
   - runs tests before completion

## Guardrails

- Do not skip init validation.
- Do not write outside canonical `.specify/` paths.
- Preserve gate-first confirmations for all writes.
