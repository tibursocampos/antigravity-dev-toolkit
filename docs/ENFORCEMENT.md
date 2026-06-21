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
| **Fragile Spec Kit init** | Agent can create empty `.specify/` without `constitution.md` | `speckit_spec` runs without valid init |

## Cursor vs Antigravity

| Layer | Cursor | Antigravity (before this plan) |
|-------|--------|--------------------------------|
| Always-on rules | User rules + `.cursor/rules` | None |
| Shell blocking | `beforeShellExecution` hooks | None |
| Skill loading | Explicit + rules | KI on explicit invoke only |
| Context management | Rules + hooks | Manual (honor system) |

## Mitigation layers (this toolkit)

1. **`GUARDRAILS.md`** — compact STOP rules at plugin root (English)
2. **`global_guardrails` KI** — loaded every conversation, first turn
3. **`SESSION.md` + session-state** — verifiable gates in `~/.gemini/antigravity-ide/sdd/sessions/`
4. **Gate-first on every skill** — STOP block + step -1 checklist
5. **Validation scripts** — `validate-all.ps1` smoke test after sync; optional Spec Kit and session-gate checks via flags.

## Limitations

Without Antigravity-native shell hooks and **without files in consumer repositories**, there is no 100% technical block equivalent to Cursor. Enforcement relies on KI injection + session gates + skill discipline.

See [`docs/antigravity-hooks-investigation.md`](antigravity-hooks-investigation.md) for hook research.

## After sync

Run:

```powershell
.\scripts\sync-antigravity.ps1
.\scripts\validate-all.ps1
```

Restart Antigravity IDE.
