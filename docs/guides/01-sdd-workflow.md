# SDD Workflow (Spec → Plan → Implement)

The main workflow for features and epics ensures predictability, quality, and documented context (important for LLM reasoning in long executions).

## Step 1: `use skill spec`
Start by asking the agent to specify a feature.  
**Example:** `use skill spec — add PDF export for orders`

The agent will:
- Ask you questions if there are ambiguities in the requirements or scope.
- Request approval for the artifact before saving.
- Create a PRD (Product Requirements Document) file, typically in `PRD/NNN_feature_slug.md`.

## Step 2: `use skill plan`
Once the PRD is ready and reviewed, ask to plan the development.  
**Example:** `use skill plan — PRD/001_pdf_export.md`

The agent will:
- Read the PRD and design the architecture and exact file-by-file modifications.
- Break down the implementation into atomic iterative steps (e.g., Domain, Infrastructure, Application, API, Tests).
- Create a `PLAN/PLAN_001_pdf_export.md` file with checkboxes (`[ ]`).

## Step 3: `use skill implement`
Work on each step of the plan individually to mitigate context loss.  
**Example:** `use skill implement — PLAN/PLAN_001_pdf_export.md — Step 1`

The agent will:
- Focus strictly on the requested step.
- Modify the code accordingly.
- Update the PLAN file, marking the step as completed (`[x]`).
- Suggest running a commit as soon as the step is finished.

> **Important:** After committing, do not accumulate context. In a new message (or a new chat session), repeat the `implement` skill for `Step 2`, and so on.
