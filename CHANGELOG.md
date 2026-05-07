# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-05-07

### Added
- Interactive menu with 5 main options: Consult, Update, Copy, Enable/Disable, Run
- **Consult**: list jobs with name, cron and status; full detail view; JSON export to chosen folder
- **Update**: edit cron and/or body individually or in batch; same value for all or different per job; editor pre-filled with current values; Unicode escape fix (`\u0027` → `'`)
- **Copy**: duplicate any job as a template; template loop to create multiple jobs in sequence
- **Enable / Disable**: pause/resume individually or in batch with invert-state option
- **Run**: trigger immediate execution individually or in batch
- Automatic logging of all actions to `scheduler_changes.log`
- Body decode/encode handled transparently (Base64 ↔ JSON)
- Notepad (Windows) / nano/vim/`$EDITOR` (macOS) opens pre-filled with current body for editing
- PowerShell 5.1 compatible (no `?.` operator, no curly quotes)
- macOS Bash compatible (`base64 --decode`, no `-w` flag)
- Both scripts validated to contain only ASCII characters
