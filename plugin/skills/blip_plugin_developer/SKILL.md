---
name: blip-plugin-developer
description: >
  Orchestrate and generate React Plugins for the Blip platform. Independent skill to coordinate development
  with repository fallback (ADO to GitHub), flexible SDD/SpecKit integration, and complete documentation setup.
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
[ ] PIPELINE.md read (SDD/speckit skills only)
[ ] User confirmed current action (sim)
-> If any unchecked: STOP
```

---

# Skill: blip_plugin_developer

## Trigger

Use when user asks for `use skill blip_plugin_developer` or wants to create a new Blip React Plugin.

## Outcome

A new locally cloned template for a Blip Plugin with the correct name, integrated SDD/SpecKit workflow setup, and a clear handoff to execution specialists.

## Lazy-load references

- Branch and commit rules: `dev_persona`
- React/Frontend guidelines: `_shared/react_guidelines/` and `_shared/frontend_guidelines/`
- Blip specific guidelines: `_shared/blip_guidelines/`
- Context and Git policy: `dev_persona` context management
- Caveman rules (if active): `_shared/caveman/CAVEMAN.md`

## Process

### 1. Template Clone & Setup (Infrastructure First)
Before cloning, ask the user (pt-BR):
"Onde deseja criar o projeto do plugin? (No diretório atual `./` ou deseja informar um novo caminho e nome?)"
Wait for the answer. Once confirmed, clone the template into the requested directory:
- **First attempt (ADO)**: `git clone https://curupira@dev.azure.com/curupira/CS%20-%20Community/_git/package-plugin-template <plugin-name>`
- **Fallback (GitHub)**: If ADO fails (permissions/network), silently fallback and inform user: `git clone https://github.com/takenet/cra-template-blip-plugin.git <plugin-name>` (or use `npx`).

**Setup and Cleanup:**
- Navigate into `<plugin-name>`.
- Remove the `.git` folder (`rm -rf .git`).
- Replace any placeholder (`NEW_PACKAGE_NAME` or similar) with the actual plugin name in `package.json` and other configuration files.
- Update the `.gitignore` file to ignore agent-generated artifacts and local documentation folders (e.g., `prd/`, `plan/`, `specify/`, `.gemini/`, `.agents/`).

### 2. SDD / Spec Kit Integration (Documentation Phase)
Once the repository exists and you are inside the project folder, ask the user (pt-BR):
"Qual fluxo de documentação você deseja usar? (SDD, Spec Kit, ou já possui um .md pronto?)"
Wait for the answer. Because the repository now exists, `manifest.json` will correctly map the save/load paths for planning artifacts (like PRDs).

### 3. Handoff (Implementation Phase)
Once the documentation and scope are defined (Phase 2), the actual implementation must begin using the chosen pipeline.
Ask the user (pt-BR):
"Qual persona de desenvolvimento você deseja utilizar para escrever o código: `react_developer` (foco em lógica padrão) ou `impeccable_developer` (foco premium em UX/UI e design system)?"

Wait for the user's choice. Then do the following:
1. **Persist the Choice:** Create or update the `.agents/AGENTS.md` file in the project root with the following rule:
   `Para este projeto, a persona oficial de execução de código frontend é o <chosen_persona>. As skills de desenvolvimento (como sdd_develop) DEVEM atuar sob esta persona ao implementar os passos.`
2. **Instruct the Next Step:** Provide the exact command the user must run to continue, based on the documentation flow chosen in Phase 2.
   - **If SDD was chosen:** "Para seguir com o fluxo SDD, execute o comando: `use skill sdd_plan` (referenciando o PRD). Depois, execute os passos com `sdd_develop`."
   - **If Spec Kit was chosen:** "Para seguir com o fluxo Spec Kit, execute o comando: `use skill speckit_plan` e depois desenvolva com `speckit_develop`."
   - **If Manual/No Flow:** Instruct the user to invoke the chosen persona directly with the `.md` file provided.
