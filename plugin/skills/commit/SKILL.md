---
name: commit
description: >
  Review staged and unstaged changes, draft a Conventional Commits message, commit on a valid
  feature branch (or user-authorized branch), and optionally push. Use when the user says
  "use skill commit", "commit changes", or "/commit". Git-only - no work-item tracker APIs.
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
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

## Trigger

Use for `use skill commit`, `commit changes`, or `/commit`.

## Outcome

One or more **Conventional Commits** on `feature/<slug>` or `feat/<id>`, with optional push via `use skill push`. No automatic commit without user approval of the message.

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Branch / language policy | `dev_persona` (Git Mutating Commands + branch rules) |
| Detailed Git flow | `_shared/developer_common/step-4-commits-pr.md` |
| Pre-commit checks | `_shared/developer_common/step-3.5-precommit-validation.md` |
| Message validator | `_shared/format_validators/commit-message-validator.md` |

## Process

### 0. Workspace

Confirm the **target repository**. Read `AGENTS.md` / `README.md` if present.

### 1. Validate branch (blocker unless user overrides)

Default allowed: `feature/<slug>`, `feat/<id>` (single segment after prefix).

Default blocked: `main`, `master`, `develop`, nested `feature/a/b`, or invalid patterns.

If blocked **unless** the user explicitly authorized that branch in the current session (e.g. "pode commitar na master"), stop and show how to create a valid branch. Do not stage or commit.

### 2. Inspect changes

Run in parallel:

```bash
git status
git diff --staged
git diff
git log --oneline -10
```

If the working tree is clean, report and stop.

Summarize: files changed, nature (feat/fix/refactor/test/docs), scope, breaking changes.

### 3. Pre-commit validation

Follow `step-3.5-precommit-validation.md` when changes are non-trivial. User may skip with explicit acknowledgment.

### 4. Draft commit message

Apply `step-4-commits-pr.md` and `commit-message-validator.md`:

```
<type>[optional scope][!]: <description>

[optional body - why, not what]

Refs: #<issue>    # optional footer
```

Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

Present the proposed message and **wait for user confirmation** before committing.

Prefer **atomic commits**: stage explicit paths - avoid `git add -A` unless the user explicitly requests it.

### 5. Commit

After approval, write the **exact** user-approved text to a message file. The file must contain **only** Conventional Commits content - no footers, no trailers, no `Co-authored-by` lines.

```bash
git add <explicit paths>
git commit -F <path-to-approved-message.txt>
```

Use **only** `-F` or a single `-m` with the approved subject (and optional body via `-F`). Do **not** use:

- `git commit --trailer` / `--trailer=…` (any trailer flag)
- Extra `-m` blocks for footers or attribution
- `--author` overrides for Cursor, Antigravity, or any AI agent
- Any line containing `Co-authored-by:` in the message you write

**Never** append `Co-authored-by: Cursor`, `Co-authored-by: Antigravity`, or similar - not in the message file, not in chat drafts shown to git, not in any form.

#### 5.1 Post-commit verification (mandatory)

Cursor IDE or other tooling may inject `Co-authored-by: Cursor` **after** the agent runs `git commit`. The agent must **not** leave that in place.

Immediately after every commit:

```bash
git log -1 --format=%B
```

If the output contains `Co-authored-by:` (any variant, any email), strip it and amend:

1. Rewrite the message file with **only** the approved Conventional Commits text (no `Co-authored-by` lines).
2. Run `git commit --amend -F <path-to-approved-message.txt>`.
3. Re-check with `git log -1 --format=%B`.
4. If the trailer is still present, run `git commit --amend -F <path-to-approved-message.txt> --no-verify` **only** to remove the unauthorized co-author line.
5. If the trailer **still** remains, amend with hooks disabled:

```bash
git -c core.hooksPath=<empty-directory> commit --amend -F <path-to-approved-message.txt>
```

Use a temporary empty folder (not the repo `.git/hooks`). Re-check `git log -1 --format=%B`.

Report the final message body in chat (without co-author trailers).

Do not use `git commit --amend` on shared or pushed history unless the user explicitly requests it and amend rules apply.

### 6. Push (optional)

Push only when the user asks - hand off to `use skill push`. Never `git push --force` to `main`, `master`, or `develop`.

### 7. Report

- Branch name
- Short commit hash (`git rev-parse --short HEAD`)
- Files included
- Push status (if applicable)

## Must not

- Commit on blocked branches without explicit user authorization in the session
- `git add -A` / `git add .` without review (unless user explicitly requests)
- Auto-commit without message approval
- Reference AI, generation, or automation in commit title, body, or footer
- Use tracker APIs or forced workflow templates
- **AI co-author trailers (absolute)** - never write, suggest, or leave in place:
  - `Co-authored-by: Cursor` / `cursoragent@cursor.com`
  - `Co-authored-by: Antigravity` or any AI agent
  - `git commit --trailer` or any trailer flag for attribution
- Finish a commit session while `git log -1` still shows `Co-authored-by:` - amend per section 5.1 first

## Handoff

| Situation | Next |
|-----------|------|
| Push | `use skill push` |
| Review before PR | `use skill code_review` |
| Continue SDD step | New session -> `use skill sdd_develop` |
