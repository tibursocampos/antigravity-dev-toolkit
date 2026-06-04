---
name: commit
description: >
  Review staged and unstaged changes, draft a Conventional Commits message, commit on a valid
  feature branch, and optionally push. Use when the user says "use skill commit",
  "commit changes", or "/commit". Git-only — no work-item tracker APIs.
---

# Skill: commit

## Trigger

Invoke when the user asks for: `use skill commit`, `commit changes`, or `/commit`.

## Outcome

One or more **Conventional Commits** on `feature/<slug>` or `feat/<id>`, with an optional push. No automatic commit without user approval of the message.

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Branch rules | `dev_persona` § Branch validation |
| Commit format | `dev_persona` § Conventional Commits |

## Process

### 0. Workspace

Confirm the **target repository** (not `antigravity-dev-toolkit` unless that is the project). Read `README.md` if present.

### 1. Validate branch (blocker)

Before any `git add`, `git commit`, or `git push`, enforce branch validation:

- Allowed: `feature/<slug>`, `feat/<id>` (single segment after prefix)
- Blocked: `main`, `master`, `develop`, nested `feature/a/b`, or any other pattern

If blocked, stop and show how to create a valid branch. Do not stage or commit.

### 2. Inspect changes

```bash
git status
git diff --staged
git diff
git log --oneline -10
```

If the working tree is clean and there is nothing to commit, report and stop.

Summarize: files changed, nature (feat/fix/refactor/test/docs), scope, breaking changes.

### 3. Pre-commit validation

Before non-trivial commits: check for hardcoded secrets, run `dotnet build` / `dotnet test` when applicable (or equivalent per stack). User may skip with explicit acknowledgment.

### 4. Draft commit message

Apply Conventional Commits per `dev_persona` § Conventional Commits:

```
<type>[optional scope][!]: <description>

[optional body — why, not what]

Refs: #<issue>    # optional footer
```

Present the proposed message and **wait for user confirmation** before committing. Apply edits if requested.

Prefer **atomic commits**: stage explicit paths — avoid `git add -A` unless the user explicitly requests it.

### 5. Commit

After approval:

```bash
git add <explicit paths>
git commit -m "<message>"
```

Use **only** `-m`. Do **not** add `--trailer`, `--author` overrides, or extra `-m` blocks for attribution. Do not use `git commit --amend` on shared or pushed history unless the user explicitly requests it.

### 6. Push (optional)

Push only when the user asks:

```bash
git push -u origin HEAD
```

Never `git push --force` to `main`, `master`, or `develop`.

### 7. Report

- Branch name
- Short commit hash (`git rev-parse --short HEAD`)
- Files included
- Push status (if applicable)
- SDD handoff: if mid-PLAN, remind to update PLAN via `implement` before the next step in a new chat

## Must not

- Commit on `main`, `master`, `develop`, or invalid branch names
- Work-item APIs, mandatory PR creation, or corporate PR templates
- `git add -A` / `git add .` without review (unless user explicitly requests)
- Auto-commit without message approval
- **AI co-author trailers** — forbidden in any form

## Handoff

| Situação | Próximo |
|----------|---------|
| Continue SDD step | Nova sessão → `use skill implement — <full-plan-path> — Step N` |
| Review antes de PR | `use skill code-review` |
| Criar PR (usuário pede) | `gh pr create` |
