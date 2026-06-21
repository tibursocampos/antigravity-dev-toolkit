# Antigravity IDE — Hooks Investigation

**Date:** 2026-06-21  
**Scope:** User-level hooks in `~/.gemini/` without modifying consumer repositories.

## Findings

| Location searched | Result |
|-------------------|--------|
| `~/.gemini/antigravity-ide/` | No `hooks.json`, no `hooks/` folder |
| `~/.gemini/antigravity/` | No hook configuration |
| Antigravity plugin API | No documented `beforeShellExecution` equivalent |
| Cursor comparison | Cursor supports `.cursor/hooks.json` + `beforeShellExecution` |

## Conclusion

**Antigravity IDE does not currently expose user-level agent hooks** equivalent to Cursor's shell execution gates. Enforcement must rely on:

1. **Knowledge Items** — `global_guardrails` KI (every conversation)
2. **`GUARDRAILS.md`** — compact STOP rules at plugin root
3. **Session state** — verifiable gates in `~/.gemini/antigravity-ide/sdd/sessions/`
4. **Gate-first skills** — STOP block + step -1 on every skill

## Future escalation

If Antigravity adds hook support under `~/.gemini/`, implement:

- `beforeShellExecution` — block `git commit|push|merge|rebase` unless `~/.gemini/antigravity-ide/sdd/approved-actions.json` contains approval token
- `preToolUse` — block `Write` when session gate is false

This would provide hard enforcement without touching consumer repositories.

## Approved actions file (reserved)

Path: `~/.gemini/antigravity-ide/sdd/approved-actions.json`

Not active until hooks exist. Schema reserved for future use.

```json
{
  "approved_at": "ISO8601",
  "action": "git_commit|git_push|file_write",
  "repo": "D:/Source/Repos/MyApp",
  "expires_at": "ISO8601"
}
```
