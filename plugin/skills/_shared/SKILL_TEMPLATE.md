# Skill template - gate-first header

Copy the block below immediately after YAML frontmatter in every `SKILL.md`.

Skill body (process, guardrails, handoff) must be **English**. User-facing prompts: **Ask user (pt-BR):** …

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
[ ] PIPELINE.md read (SDD / orchestrate skills only)
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

### Caveman (participating skills)

Add under **Process** (after gate check). Cap = `Lite` | `Full` | `Never` per `_shared/caveman/CAVEMAN.md` participation table.

**Lite / Full:**

```
### Step -1b - Caveman Mode ({Lite|Full} cap)
1. Read ~/.gemini/antigravity-ide/sdd/preferences.json (create { "caveman_mode": false, "caveman_level": "full" } if missing).
2. If caveman_mode is false: continue without compression.
3. If true: load _shared/caveman/CAVEMAN.md; apply skill cap + caveman_level; show [Caveman] activation notice once.
4. Honor caveman on|off|status|lite|full|ultra during the session.
5. Auto-Clarity + never-compress gates/drafts/paths.
```

**NEVER** (`commit`, `push`):

```
### Caveman Mode
**NEVER** - Ignore caveman_mode. Clear prose only. Do not compress commit/PR text.
```

Lazy-load row when applicable: `| Caveman Mode (if active) | _shared/caveman/CAVEMAN.md - **{Lite|Full} cap** |`

---

## Skill-specific sections (below the header)

- **Trigger**
- **Outcome**
- **Lazy-load**
- **Process** (include Caveman Step -1b or NEVER block)
- **Must not**
- **Handoff**

### Develop skills - mandatory session end

```
### STOP - Session end (mandatory)
- Show git diff summary
- Show test results (if applicable)
- Update PLAN/tasks/plan.md
- Reset session-state gates to false
- Ask user (pt-BR): "Passo concluído. Inicie nova conversa para o próximo passo."
- DO NOT proceed to next step
```

### AI stealth (all skills)

Never leave any trace that output was produced by an AI tool:
- No AI references in code comments, XML docs, identifiers, log messages, commit messages, PR descriptions, or any artifact.
- Code comments: minimal and only when strictly necessary. Prefer self-explanatory code.
- Output must be indistinguishable from work produced without AI assistance.
- See `GUARDRAILS.md` § 9 (AI stealth policy).
