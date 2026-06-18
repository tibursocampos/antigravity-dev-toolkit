# Spec Kit Workflow (setup → init → spec → plan → develop)

The Spec Kit workflow is an alternative to classic SDD, based on the official [GitHub Spec Kit](https://github.com/github/spec-kit) CLI and the `.specify/` folder structure.

---

## Initial Step: `use skill speckit_setup`
Verifies prerequisites on Windows and installs the CLI.
**Example:** `use skill speckit_setup`

The agent will:
- Verify Python 3.10+.
- Ask to install the `uv` package manager if it does not exist.
- Install the `specify-cli` tool via `uv tool install`.
- Configure the global SDD manifest directory.

---

## Step 2: `use skill speckit_init`
Initializes the Spec Kit structure in the active repository.
**Example:** `use skill speckit_init`

The agent will:
- **Storage Resolution:** On the first execution, asks whether you prefer to store plans locally (in the repository) or globally (in `~/.gemini/antigravity-ide/sdd/`) to avoid cluttering the project's git. This choice is saved in `manifest.json`.
- Create the `.specify/` folder in the chosen destination and generate the project principles file (`.specify/memory/constitution.md`).

---

## Step 3: `use skill speckit_spec`
Creates a new technical specification for a feature.
**Example:** `use skill speckit_spec`

The agent will:
- Collect the feature description, current behavior, and expected behavior.
- Generate the sequential identifier `NNN` (e.g., `001`) and the feature slug.
- Create and save the `spec.md` file under the path `.specify/specs/NNN-<slug>/spec.md` (at the location defined by the active storage).

---

## Step 4: `use skill speckit_plan`
Generates the detailed plan and checklist from the specification.
**Example:** `use skill speckit_plan — <path-to-spec.md>`

The agent will:
- Analyze the `spec.md` and the `constitution.md` of the project.
- Create two files in the same feature subfolder:
  - `plan.md`: Technical architecture design and list of affected files.
  - `tasks.md`: List of atomic tasks of 20-45 minutes with checkboxes (`- [ ]`).

---

## Step 5: `use skill speckit_develop`
Executes tasks iteratively step by step.
**Example:** `use skill speckit_develop — <path-to-tasks.md>`

The agent will:
- Read the first pending task from the `tasks.md` file.
- Implement the code and tests (in English).
- Update the task in the `tasks.md` file as completed (`[x]`).
- Offer a conventional commit to save progress.
