# Enforcement Architecture — Root Cause Analysis

This document explains why Antigravity IDE agents may ignore toolkit guardrails, and how the toolkit mitigates the gap.

## Root causes (evidence-based)

| Problem | Evidence | Impact |
|---------|----------|--------|
| **KI only on explicit skill invocation** | `sync-antigravity.ps1` — `custom_skills/metadata.json` triggers only on `use skill [name]` | Natural prompts ("create a plan", "implement") do not load `PIPELINE.md` or skills |
| **`dev_persona` is not always-on** | Exists only as a skill file; no IDE injection mechanism | Git rules, language policy, one-step-per-session never enter context |
| **`AGENTS.md` was a stub** | Previously only Caveman notes | No hard rules at workspace boot |
| **No native IDE hooks** | Unlike Cursor `beforeShellExecution` | Nothing blocks `git commit` or `Write` at runtime |
| **Skills are honor-system** | Long markdown loaded late or never | Agent runs everything at once, commits, skips confirmation |
| **Lazy-load fails silently** | Step -1 skipped → `PIPELINE.md` / guidelines not loaded | Wrong language in code/artifacts |
| **Layout drift** | Root flat `PRD/` / Spec Kit leftovers in old consumers | Writes outside `features/NNN-slug/` |

## Cursor vs Antigravity

| Layer | Cursor | Antigravity |
|-------|--------|-------------|
| Always-on rules | User rules + `.cursor/rules` | KI `global_guardrails` + `GUARDRAILS.md` |
| Shell blocking | `beforeShellExecution` hooks | None (session gates + honor system) |
| Skill loading | Explicit + rules | KI on explicit invoke only |
| Forma C specialists | Cursor `Task` | Serial specialist passes (`SUBAGENT-MODEL.md`) |

## Mitigation layers (this toolkit)

1. **`GUARDRAILS.md`** — compact STOP rules at plugin root (English)
2. **`global_guardrails` KI** — loaded every conversation, first turn
3. **`~/.gemini/config/AGENTS.md`** — managed block from sync (sandbox bypass via `Get-Content`/`cat` for `skills.json`; skill discovery). Manual `/learn` fallback if the agent still cannot read config (see [INSTALL.md](INSTALL.md#initial-configuration-antigravity-chat))
4. **`SESSION.md` + session-state** — verifiable gates in `~/.gemini/antigravity-ide/sdd/sessions/`
5. **Gate-first on every skill** — STOP block + step -1 checklist
6. **Validation scripts** — `validate-all.ps1` smoke test after sync; optional session-gate checks via `-IncludeSessionGate`.

## Limitations

Without Antigravity-native shell hooks and **without files in consumer repositories**, there is no 100% technical block equivalent to Cursor. Enforcement relies on KI injection + session gates + skill discipline. Direct `view_file` of `~/.gemini/config/skills.json` is often sandboxed; the config `AGENTS.md` + terminal read is the supported workaround.

See [`docs/antigravity-hooks-investigation.md`](antigravity-hooks-investigation.md) for hook research.

## After sync

Run:

```powershell
.\scripts\sync-antigravity.ps1
.\scripts\validate-all.ps1
```

Restart Antigravity IDE.
