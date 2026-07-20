# Design decisions

Short rationale for future maintainers (single-owner toolkit). Update when the “why” changes.

## DD-001 — Three Formas (A / B / C)

**Decision:** Classic SDD (A), backlog prep (B), and orchestration (C) coexist.

**Why:** Match complexity to process cost. Small fixes should not pay full SDD; brownfield needs orchestration.

## DD-002 — Orchestrators reuse `sdd_*` contracts

**Decision:** O2 reuses `sdd_spec` / `sdd_plan`; O3 reuses `sdd_develop` (one PLAN step). Parents do not write app code.

**Why:** Single source of quality rules; manual `sdd_develop` remains valid instead of O3.

## DD-003 — PowerShell as the automation language

**Decision:** Canonical `.ps1`; Unix via `pwsh` and `.sh` wrappers.

**Why:** One implementation across OS; avoid bash/ps1 dual maintenance.

## DD-004 — No GitHub CLI in skills

**Decision:** `git` only; PRs via GitHub web UI; CI via pasted logs.

**Why:** Corporate environments often block or omit the GitHub CLI; automated PR create is easy to misuse against branch policy.

**Consequence:** Validators forbid GitHub CLI invoke patterns in docs and skills.

## DD-005 — Fork-only public repos

**Decision:** Clone/fork OK; no community PR acceptance.

**Why:** Opinionated personal toolkit; unipersonal review capacity.

## DD-006 — Independent toolkit (no public sibling sync policy)

**Decision:** This repository does not document or depend on any other IDE toolkit.

**Why:** Cross-toolkit SYNC docs caused drift and confused onboarding.

## DD-007 — Global plugin deploy with backup

**Decision:** Sync writes under `~/.gemini/…`; sync creates timestamped backup; restore script rolls back.

**Why:** Global plugin/skills affect all Antigravity workspaces — high blast radius on bad sync.
