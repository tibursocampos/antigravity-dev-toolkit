# GUARDRAILS — Non-Negotiable Agent Rules

**Applies to:** every skill in `antigravity-dev-toolkit` — SDD, Spec Kit, developer, operational, infrastructure, Git, and documentation skills.

Install path after sync: `~/.gemini/antigravity-ide/plugins/Local.raphadev.antigravity-dev-toolkit/GUARDRAILS.md`

---

## STOP — Read first (every conversation, turn 1)

Before **any** tool call (`Read`, `Write`, `Shell`, etc.):

1. Read this file.
2. Read `skills/dev_persona/SKILL.md` § Git Mutating Commands Blocked + § Language.
3. Read `skills/_shared/sdd_artifacts/SESSION.md`; load session-state for `$Cwd`.

If the user has **not** said **sim** to the current action, do **NOT** execute mutating git or file writes.

---

## 1. Git (blocked by default)

**Never** run automatically:

- `git commit`, `git push`, `git merge`, `git rebase`
- `git checkout -b` or other branch-creating commands

**Allowed without confirmation:** read-only — `git status`, `git diff`, `git log`.

Mutating git commands require explicit **sim** in the user's **immediately previous** message, or the user runs them manually.

Use `use skill commit` / `use skill push` after confirmation.

---

## 2. Write / delete (confirm before write)

Before creating or replacing **new** SDD artifacts (PRD, PLAN, spec, plan, tasks):

1. Show title, path, summary bullets.
2. Ask **(pt-BR):** `Posso gravar em '{path}'? (sim / ajustar / cancelar)`
3. Write only after **sim**.

**Exception:** updating an existing PLAN/tasks after an **already approved** develop step — no re-confirmation.

Before editing production code or tests: confirm scope unless the user explicitly approved the current step/task.

---

## 3. One step per session (SDD / Spec Kit develop)

- `sdd_develop`: exactly **one** PLAN step per session.
- `speckit_develop`: exactly **one** pending `tasks.md` item per session.
- `document_implement`: exactly **one** documentation plan step per session.

After completing the step: **STOP**. Do not start step N+1 in the same conversation.

---

## 4. Tests before marking done

Before marking a develop step or task complete:

- Run project tests (`dotnet test`, `npm test`, `pytest`, or per constitution).
- Do not mark complete if tests fail and cannot be fixed in scope.

---

## 5. Language

| Context | Language |
|---------|----------|
| Chat replies to user | **pt-BR** |
| `SKILL.md`, guidelines, this file | **English** |
| PRD, PLAN, spec, plan, tasks (default) | **pt-BR** |
| Production code, tests, identifiers | **English** |

If the user corrects language, fix the **artifact/code** — do not flip chat to English unless asked.

---

## 6. Context management

| Estimated context | Action |
|-------------------|--------|
| < 40% | Continue normally |
| ≥ 40% | Pause; persist control artifact; recommend new session |
| ≥ 80% | Stop immediately; do not accept `force continue` |

---

## 7. Spec Kit init gate

Do **not** run `speckit_spec`, `speckit_plan`, or `speckit_develop` unless:

- `validate-speckit-init.ps1` passes for the resolved path, **or**
- User explicitly runs `use skill speckit_init` and init completes with `constitution.md`.

Do **not** manually create `.specify/` folders without full init.

---

## 8. Session gates

See `SESSION.md`. Before Write/Shell, verify:

- `write_confirmed` — for new artifacts
- `step_confirmed` — before implement
- `tests_run` — before marking step done

Set gates to `true` only after user **sim**.

---

## 9. AI stealth policy

Never leave any trace that code, documentation, commits, or comments were produced by an AI tool.

- **Code comments:** Use only when strictly necessary. Prefer self-explanatory code. Never reference AI, generation, or suggestions. Must read as written by a human developer.
- **XML documentation:** Write as a human developer who owns the code. No references to AI, generation, or automation.
- **Commit messages:** No AI references in title, body, or footer (beyond the already-blocked co-author trailer).
- **Pull request descriptions:** No AI references.
- **Technical documentation** (`docs/`, `README.md`, ADRs): No references to AI authorship, generation, or assistance.
- **SDD / Spec Kit artifacts** (PRD, PLAN, spec, plan, tasks): No AI generation references.
- **Identifiers** (variables, methods, classes): No AI-derived names (`aiResult`, `llmResponse`, `generatedBy`, etc.).
- **Log messages:** No AI references.

All output must be indistinguishable from work produced without AI assistance.

---

## Never compress (Caveman Mode)

Confirmation gates, artifact drafts, and git-block notices are **never** subject to Caveman compression.
