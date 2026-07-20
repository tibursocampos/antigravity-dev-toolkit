# Portability contract

What is **Antigravity-specific** in this toolkit versus what is **reusable** if you ever port ideas to another agent/IDE.

## Runtime (scripts)

| Piece | Contract |
|-------|----------|
| Canonical language | **PowerShell 7+** (`pwsh`) on Windows, macOS, and Linux |
| `.sh` wrappers | Thin launchers that `exec pwsh` — not a second implementation |
| Validation | `scripts/validation/*.ps1` exit codes; CI runs the same scripts |

Scripts should resolve the user home in a cross-platform way (`$HOME` / `[Environment]::GetFolderPath('UserProfile')`).

## Antigravity-specific (does not migrate automatically)

| Surface | Examples |
|---------|----------|
| Install root | `~/.gemini/antigravity-ide/plugins/`, `~/.gemini/antigravity-ide/sdd/` |
| Invoke style | Antigravity skill picker / `use skill …` (underscore names) |
| Guardrails | `plugin/GUARDRAILS.md` + KI injection |
| Hooks (optional) | AGY hooks under `plugin/hooks/` merged into Gemini config when enabled |
| Subagents | Modes in `SUBAGENT-MODEL.md` (`native` / `serial` / `handoff`) — not Cursor `Task` |
| Router | `dev_persona` skill |

If Antigravity packaging changes, adapt sync + invoke docs; keep the reusable core below.

## Reusable core (portable content)

| Surface | Examples |
|---------|----------|
| Pipeline contract | `plugin/skills/_shared/sdd_artifacts/PIPELINE.md`, `STORAGE.md`, `SESSION.md`, `MEMORY-BANK.md` |
| Templates | features / memory-bank templates |
| Guidelines | `_shared` guideline packs |
| Skill bodies | Process steps, gates, must-not rules |
| Forma model | A / B / C; O2 reuses spec/plan; O3 reuses develop |
| Validation ideas | Skill contracts, fixtures, docs consistency |

## Git / PR policy (tool-agnostic)

- Branch: `feature/<slug>` or `feat/<id>` only for commits
- Integration target: `develop`
- **No GitHub CLI** in skills — `git` locally; open PRs in the **GitHub web UI**

## What this doc is not

Not a multi-IDE runtime. It maps what to keep versus rewrite on a future port.
