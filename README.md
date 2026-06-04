# antigravity-dev-toolkit

Personal Antigravity IDE (Google DeepMind) agent toolkit: SDD workflow, .NET guidelines, Git-only developer flow. No corporate tracker or pipeline integrations.

Deploy to your Antigravity IDE plugins directory with `scripts/sync-antigravity.ps1` (see [docs/INSTALL.md](docs/INSTALL.md)).

## What this is

| Capability | Description |
|------------|-------------|
| **SDD workflow** | `spec` → `plan` → `implement` with PRD/PLAN stored in the working repo |
| **.NET guidelines** | `dotnet-guidelines` (Clean Architecture, xUnit, Moq, FluentAssertions) |
| **Git-only flow** | Branching, commits, checklist — no Azure DevOps |
| **Antigravity-native** | Installed as a plugin under `~/.gemini/antigravity-ide/plugins/` |
| **Operational skills** | fix-build, test-coverage, code-review, repo docs |

## Quick start

1. Clone this repo.
2. Run from repo root:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-antigravity.ps1
   ```

3. Restart Antigravity IDE to pick up the new skills.
4. In any project chat: invoke skills via natural language (auto-discovered from `description` field in each SKILL.md).

Re-run sync after pulling toolkit updates (idempotent).

## Repository layout

```
antigravity-dev-toolkit/
├── README.md
├── docs/                         # INSTALL, SKILLS catalog, guides
│   └── guides/                   # User skill manuals
├── plugin/                       # Deployed to ~/.gemini/antigravity-ide/plugins/<id>/
│   ├── plugin.json               # Plugin manifest
│   └── skills/
│       ├── dev_persona/          # Router + global rules (replaces AGENTS.md + rules)
│       ├── spec/
│       ├── plan/
│       ├── implement/
│       ├── code_review/
│       ├── commit/
│       ├── dotnet_developer/
│       ├── fix_build/
│       ├── test_coverage/
│       ├── plan_repo_docs/
│       ├── document_repo/
│       └── _shared/
│           ├── dotnet_guidelines/
│           ├── code_guidelines/
│           └── sdd_artifacts/
└── scripts/
    └── sync-antigravity.ps1      # Deploy script (SHA-256 idempotent)
```

## Skills

Skills are auto-discovered by the Antigravity IDE from the `description` field in each `SKILL.md`.

| Skill | Use for |
|-------|---------|
| `dev_persona` | Agent identity, global rules, skill catalog (loaded automatically) |
| `spec` | PRD from a feature request |
| `plan` | Baby-step PLAN from PRD |
| `implement` | Execute one PLAN step per session |
| `code_review` | Review diff or branch vs PRD/PLAN |
| `commit` | Conventional commit and push |
| `dotnet_developer` | Small .NET task without full SDD |
| `fix_build` | Diagnose and fix build/test failures |
| `test_coverage` | .NET coverage report (Coverlet) |
| `plan_repo_docs` | Plan repo documentation (RAG-oriented) |
| `document_repo` | Execute one doc plan step |

## Conventions

| Area | Rule |
|------|------|
| Skill directory names | `snake_case` |
| Skill `name` field (frontmatter) | `kebab-case` |
| SDD agent artifacts (PRD, PLAN `.md`) | Brazilian Portuguese (pt-BR) |
| Production code & tests | English always |
| User chat replies | Brazilian Portuguese (pt-BR) |
| Test stack | xUnit + Moq + FluentAssertions |

## Lineage

```
ai-prompts (Claude Code / corporate)
    │  "port, clean, decouple"
    ▼
cursor-dev-toolkit (Cursor IDE / personal, Git-only)
    │  "port and adapt again"
    ▼
antigravity-dev-toolkit (Antigravity IDE / Gemini — this repo)
```

## License

Personal use.
