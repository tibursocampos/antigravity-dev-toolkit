# Installation: antigravity-dev-toolkit

This repository contains the personal development toolkit for the Antigravity IDE (Gemini).

## Prerequisites
- Windows (Powershell)
- Antigravity IDE installed and running (so that the `~/.gemini` folder exists)

## Installation Steps

1. Clone the repository to your machine (e.g., `D:\Source\Repos\antigravity-dev-toolkit`).
2. Open a PowerShell terminal in the repository root.
3. Run the synchronization script:

   ```powershell
   .\scripts\sync-antigravity.ps1
   ```

4. The script will copy the `plugin/` directory to the Antigravity IDE plugins folder (`~/.gemini/antigravity-ide/plugins/Local.raphadev.antigravity-dev-toolkit`).
5. The copy process is idempotent (based on SHA-256 hashes), copying only modified files and avoiding unnecessary overwrites.
6. Optionally restart the chat sessions in the Antigravity IDE so that it loads/indexes the new skills effectively.

## Updating
Whenever you make local changes to the skills or rules (`_shared/`) in this base repository, run `.\scripts\sync-antigravity.ps1` again to apply the changes to the IDE.

---

## Spec Kit Setup (Optional)

Spec Kit skills depend on the official CLI of the GitHub project.

### 1. Automatic Configuration via PowerShell Script
You can configure all prerequisites (Python, `uv`, and `specify-cli`) and initialize global directories by running the utility script from the repository root:
```powershell
.\scripts\setup-speckit.ps1
```

### 2. Automatic Configuration via Chat
Alternatively, call the corresponding skill in the IDE chat:
```
/speckit_setup
```

### 3. Manual Configuration on Windows
If you prefer to install prerequisites manually:
1. Install Python 3.10+
2. Install the `uv` package manager:
   ```powershell
   powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
   ```
3. Install the Spec Kit CLI tool globally:
   ```powershell
   uv tool install specify-cli --from git+https://github.com/github/spec-kit.git --force
   ```

---

## Initializing the Repository

### Via PowerShell Script
You can initialize the `.specify/` structure and register the active repository in the `manifest.json` with the desired storage mode (`global` or `repository`):
```powershell
.\scripts\configure-repo-sdd.ps1 -StorageMode global
```

### Via Chat
Or call the corresponding skills in the chat:
1. Initialize and select the storage mode: `/speckit_init`
2. Create specifications: `/speckit_spec`
