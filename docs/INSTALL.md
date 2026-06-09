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
