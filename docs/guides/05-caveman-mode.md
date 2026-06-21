# Guide 05: Caveman Mode

Caveman mode compresses conversational prose while preserving execution safety.

## State

- File: `~/.gemini/antigravity-ide/sdd/preferences.json`
- Key: `caveman_mode`
- Commands: `caveman on`, `caveman off`, `caveman status`

## Participation levels

- **NEVER**: `commit`, `push`
- **LITE**: `sdd_spec`, `sdd_plan`, `speckit_spec`, `speckit_plan`
- **FULL**: `code_review`, `developer`, `fix_build`, `test_coverage`, `sdd_develop`, `speckit_develop`, general chat

## Never-compress content

- confirmation gates (`sim / ajustar / cancelar`)
- artifact drafts
- paths, commands, code blocks, and safety alerts

## Interaction with guardrails

Caveman mode does not bypass:
- `GUARDRAILS.md`
- session-state gates
- one-step-per-session limits
