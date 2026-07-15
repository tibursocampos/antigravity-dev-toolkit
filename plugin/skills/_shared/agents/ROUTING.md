# Forma C routing (Antigravity)

How O1 / O2 / O3 relate to stack skills and the SDD contracts.

Install path after sync: `{pluginRoot}/skills/_shared/agents/ROUTING.md`

## Stage → skill

| Stage | Skill | May write app code? |
|-------|-------|---------------------|
| O1 | `orchestrate_analyze` | **No** — FEATURE / STORY / ANALYSIS / ARCH / SEC / CONTINUITY only |
| O2 | `orchestrate_deliver` | **No** — PRD/PLAN via `sdd_spec` / `sdd_plan` contracts |
| O3 | `orchestrate_develop` | Parent **no**; one `sdd_develop` contract pass per session |
| Manual Forma A | `sdd_spec` → `sdd_plan` → `sdd_develop` | Only `sdd_develop` writes app code |

## Parent vs specialist

| Skill | Parent does | Must not |
|-------|-------------|----------|
| `orchestrate_analyze` | Serial specialist passes via ROSTER prompts | Call `*_developer` to write app code |
| `orchestrate_deliver` | Contracts of `sdd_spec` / `sdd_plan` per story | Implement code |
| `orchestrate_develop` | Resolve next PLAN step; hand off / run **one** `sdd_develop` session | Parent writes app code; multi-step in one session |

**Pass model:** see `SUBAGENT-MODEL.md` — current chat model by default; premium only after rare hard-task gate + user **sim**.

**Caveman receipts:** when `caveman_mode` is ON, specialists return the schema in `RECEIPT.md` (ultra structured findings). Parent inherits prefs `caveman_level` but **never** compresses gates or artifact drafts. Prefer level `ultra` only for long multi-specialist O1 sessions. Load `_shared/caveman/CAVEMAN.md` only if mode ON.

**Memory-bank (Forma C Step 0):** after gate, pass resolved `bank_root` (`$Cwd/memory-bank/` or `<classic.path>/memory-bank/` per `STORAGE.md`) as **read-only** Prior context to specialists / O2 drafts / O3 develop (selective files). Do not place bank under `features/`. Forma A / manual `sdd_*` do not require the gate. Optional narrative compact: `_shared/caveman/COMPACT.md` (user **sim**).

## Stack handoff (implement time)

Use existing skills: `dotnet_developer`, `react_developer`, `angular_developer`, `vue_developer`, `blazor_developer`, `electron_developer`, `javascript_developer`, `python_developer`, or router `developer`. Prefer after O2 PLAN exists; for trivial work skip Forma C.
