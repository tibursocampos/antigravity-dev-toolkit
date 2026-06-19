# antigravity-dev-toolkit

Personal Antigravity IDE (Google DeepMind) agent toolkit: SDD (classic and Spec Kit) workflows, .NET guidelines, Git-only developer flow. No corporate tracker or pipeline integrations.

Deploy to your Antigravity IDE plugins directory with `scripts/sync-antigravity.ps1` (see [docs/INSTALL.md](docs/INSTALL.md)).

## What this is

| Capability | Description |
|------------|-------------|
| **SDD workflow** | Classic (`sdd_spec` → `sdd_plan` → `sdd_develop`) and Spec Kit (`speckit_spec` → `speckit_plan` → `speckit_develop`) workflows supporting local or global manifest-based storage |
| **.NET guidelines** | `dotnet-guidelines` (Clean Architecture, xUnit/NUnit, Moq/NSubstitute, Shouldly) |
| **Git-only flow** | Branching, commits, checklist — no Azure DevOps |
| **Antigravity-native** | Installed as a plugin under `~/.gemini/antigravity-ide/plugins/` |
| **Operational skills** | fix-build, test-coverage, code-review, repo docs |
| **Caveman Mode** | Optional response compression mode to reduce token usage and speed up interactions |

## Quick start

1. Clone this repo.
2. Run from repo root:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-antigravity.ps1
   ```

3. Restart Antigravity IDE to pick up the new skills.
4. In any project chat: invoke skills via natural language (auto-discovered from `description` field in each SKILL.md).
5. (Optional) Run `use skill speckit_setup` to install Spec Kit CLI prerequisites and run `use skill speckit_init` to initialize Spec Kit folders in your active repositories.

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
│       ├── sdd_spec/             # Classic SDD PRD phase
│       ├── sdd_plan/             # Classic SDD PLAN phase
│       ├── sdd_develop/          # Classic SDD execution phase
│       ├── speckit_setup/        # Spec Kit prerequisites install
│       ├── speckit_init/         # Spec Kit folder initializer
│       ├── speckit_spec/         # Spec Kit spec.md phase
│       ├── speckit_plan/         # Spec Kit plan.md/tasks.md phase
│       ├── speckit_develop/      # Spec Kit tasks execution phase
│       ├── code_review/
│       ├── commit/
│       ├── push/
│       ├── developer/
│       ├── fix_build/
│       ├── test_coverage/
│       ├── document_plan/
│       ├── document_implement/
│       └── _shared/
│           ├── dotnet_guidelines/
│           ├── code_guidelines/
│           └── sdd_artifacts/    # Shared STORAGE.md and PIPELINE.md guidelines
└── scripts/
    ├── sync-antigravity.ps1      # Deploy script (SHA-256 idempotent)
    ├── setup-speckit.ps1         # Spec Kit initialization helper
    └── configure-repo-sdd.ps1    # Repository configuration script
```

## Skills

Skills are auto-discovered by the Antigravity IDE from the `description` field in each `SKILL.md`.

| Skill | Use for |
|-------|---------|
| `dev_persona` | Agent identity, global rules, skill catalog (loaded automatically) |
| `sdd_spec` | PRD from a feature request |
| `sdd_plan` | Baby-step PLAN from PRD |
| `sdd_develop` | Execute one PLAN step per session |
| `code_review` | Review diff or branch vs PRD/PLAN |
| `commit` | Conventional commit with option to push |
| `push` | Git push current branch |
| `developer` | Small dev task without full SDD |
| `fix_build` | Diagnose and fix build/test failures |
| `test_coverage` | .NET coverage report (Coverlet) |
| `document_plan` | Plan repo documentation (RAG-oriented) |
| `document_implement` | Execute one doc plan step |
| `speckit_setup` | Verify and install Spec Kit CLI prerequisites (Python, uv, specify-cli) |
| `speckit_init` | Initialize `.specify/` structure in the active repository (local or global) |
| `speckit_spec` | Create technical specification `spec.md` under `.specify/specs/NNN-<slug>/` |
| `speckit_plan` | Generate technical `plan.md` and atomic checklist `tasks.md` from a spec |
| `speckit_develop` | Implement code and run tests for a single Spec Kit task |

## Conventions

| Area | Rule |
|------|------|
| Skill directory names | `snake_case` |
| Skill `name` field (frontmatter) | `kebab-case` |
| SDD agent artifacts (PRD, PLAN `.md`) | Brazilian Portuguese (pt-BR) |
| Production code & tests | English always |
| User chat replies | Brazilian Portuguese (pt-BR) |
| Test stack | xUnit/NUnit + Moq/NSubstitute + Shouldly |
| SDD Storage Mode | Local `repository` (in-repo) or `global` (centralized `~/.gemini/antigravity-ide/sdd/`) resolved via `manifest.json` |

## Caveman Mode (Response Compression)

Caveman Mode is an optional feature designed to reduce output token consumption by stripping away polite filler text and verbose progress narration, while fully protecting technical facts, code blocks, and confirmation gates.

- **Persisted State**: Configured in `~/.gemini/antigravity-ide/sdd/preferences.json` under `"caveman_mode"`. Checked globally at the first turn of any conversation.
- **In-Session Toggles & Status**: 
  - Send `caveman on` in chat to enable response compression.
  - Send `caveman off` in chat to disable response compression.
  - Send `caveman status` in chat to check the current compression status.
- **Participation Levels**:
  - **NEVER**: `commit`, `push` (kept verbose for safety).
  - **LITE**: `sdd_spec`, `sdd_plan`, `speckit_spec`, `speckit_plan` (compresses headers/preambles, but keeps questions and drafts intact).
  - **FULL**: `code_review`, `developer`, `fix_build`, `test_coverage`, `sdd_develop`, `speckit_develop`, general chat / normal conversations (compresses all prose to telegraphic bullet points).

For a complete explanation, see [docs/guides/05-caveman-mode.md](docs/guides/05-caveman-mode.md).

## License

Personal use.
