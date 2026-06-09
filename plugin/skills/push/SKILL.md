---
name: push
description: >
  Execute git push on the current branch. Use when the user says "use skill push",
  "push changes", or "/push".
---

# Skill: push

## Trigger

Invoke when the user asks for: `use skill push`, `push changes`, or `/push`.

## Outcome

Changes pushed to the remote repository for the current branch.

## Lazy-load (only when needed)

| When | Path |
|------|------|
| Branch rules | `dev_persona` § Branch validation |

## Process

### 0. Workspace

Confirm the **target repository** (not `antigravity-dev-toolkit` unless that is the project).

### 1. Validate branch (blocker)

Ensure the current branch is valid per `dev_persona` § Branch validation:

- Allowed: `feature/<slug>`, `feat/<id>`
- Blocked: `main`, `master`, `develop`, nested `feature/a/b`

If blocked, stop and warn the user.

### 2. Push

Push the current branch to the remote repository. Determine if it's the first push to set upstream.

```bash
git push -u origin HEAD
```

Never `git push --force` to `main`, `master`, or `develop`.

### 3. Report

- Branch name pushed
- Status of the push

## Must not

- `git push --force` to `main`, `master`, or `develop`
- Push on invalid branch names

## Handoff

| Situação | Próximo |
|----------|---------|
| Continue SDD step | Nova sessão → `use skill sdd_develop — <full-plan-path> — Step N` |
| Criar PR (usuário pede) | `gh pr create` |
