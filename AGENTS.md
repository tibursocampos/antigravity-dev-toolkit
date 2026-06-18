<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->

## Caveman Mode

This toolkit supports **Caveman Response Compression Mode**, which is enabled/disabled via the global user preferences at `~/.gemini/antigravity-ide/sdd/preferences.json` (`"caveman_mode"` boolean).
- Users can switch it dynamically by typing `caveman on` or `caveman off` in the chat.
- When active, participating skills load rules from `plugin/skills/_shared/caveman/CAVEMAN.md` to strip polite preambles and compress prose while preserving all technical artifacts, paths, and confirmation gates.
