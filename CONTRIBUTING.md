# Contributing

Thank you for considering contributing to **GCP Scheduler Manager**!

## How to Contribute

### Reporting Bugs

1. Check if the issue already exists in [Issues](../../issues)
2. Open a new issue using the **Bug Report** template
3. Include:
   - Operating system and version
   - PowerShell / Bash version
   - `gcloud` version (`gcloud version`)
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant log output from `scheduler_changes.log`

### Suggesting Features

1. Open a new issue using the **Feature Request** template
2. Describe the use case and the expected behavior

### Submitting Code

1. Fork the repository
2. Create a branch: `git checkout -b feature/my-feature` or `fix/my-fix`
3. Make your changes
4. Test on both PowerShell (Windows) and Bash (macOS) if possible
5. Commit using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat: add batch delete support`
   - `fix: correct unicode escape in body export`
   - `docs: update README with new options`
6. Push and open a Pull Request

## Code Guidelines

### PowerShell (`scheduler-manager.ps1`)
- Must be compatible with **PowerShell 5.1** (no `?.` operator, no `#requires`, no `$using:`)
- All string literals must use **straight ASCII double quotes** `"` — never curly quotes `"` `"`
- File must contain **only ASCII characters** (no accented letters in comments or strings)
- Use `ConvertTo-Json -Depth 20` and always strip `\uXXXX` escapes for printable ASCII chars
- Test with: `powershell -File scripts/scheduler-manager.ps1`

### Bash (`scheduler-manager.sh`)
- Must be compatible with **Bash 3.2+** (macOS default) and **zsh**
- Use `base64 --decode` (macOS flag) — not `-d`
- Avoid `local -A` (associative arrays) — use indexed arrays
- File must contain **only ASCII characters**
- Test with: `bash scripts/scheduler-manager.sh`

## Running Locally

```bash
# macOS
chmod +x scripts/scheduler-manager.sh
./scripts/scheduler-manager.sh -p YOUR_PROJECT -l YOUR_LOCATION

# Windows (PowerShell)
.\scripts\scheduler-manager.ps1 -Project YOUR_PROJECT -Location YOUR_LOCATION
```

## Questions?

Open an issue and tag it with `question`.
