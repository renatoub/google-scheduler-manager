# GCP Scheduler Manager

> An interactive CLI tool to manage **Google Cloud Scheduler** jobs — from any terminal. Available for **Windows (PowerShell)** and **macOS/Linux (Bash)**.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)
![Bash](https://img.shields.io/badge/Bash-macOS%20%2F%20Linux-green?logo=gnubash)
![GCP](https://img.shields.io/badge/Google%20Cloud-Scheduler-orange?logo=googlecloud)

---

## Features

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Consult** | List all jobs with name, cron and status. View full job details including decoded body. Export all jobs to JSON. |
| 2 | **Update** | Edit cron and/or body of any job. Supports individual and **batch mode** (same value for all, or different value per job). Editor opens pre-filled with current values. |
| 3 | **Copy** | Duplicate any job using it as a template. Supports creating **multiple jobs in sequence** from the same template without going back to the menu. |
| 4 | **Enable / Disable** | Pause or resume jobs individually or in batch. Supports **invert state** (each job flips to the opposite). |
| 5 | **Run** | Trigger immediate execution of one or multiple jobs, with confirmation prompt per job. |

All actions are logged automatically to `scheduler_changes.log`.

---

## Requirements

### Windows (PowerShell)
- PowerShell 5.1 or higher *(built into Windows 10/11)*
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) with `gcloud` on PATH
- Authenticated session: `gcloud auth login`

### macOS / Linux (Bash)
- Bash 3.2+ or Zsh
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) with `gcloud` on PATH
- **jq** — `brew install jq` *(macOS)* or `apt install jq` *(Ubuntu)*
- Authenticated session: `gcloud auth login`

---

## Quick Start

### Windows

```powershell
# Clone the repository
git clone https://github.com/renatoub/google-scheduler-manager.git
cd google-scheduler-manager

# Run
.\scripts\scheduler-manager.ps1

# Optional: specify project, location or log file
.\scripts\scheduler-manager.ps1 -Project my-project -Location us-central1 -LogFile C:\logs\scheduler.log
```

> **Note:** If you get an execution policy error, run:
> `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### macOS / Linux

```bash
# Clone the repository
git clone https://github.com/renatoub/google-scheduler-manager.git
cd google-scheduler-manager

# Give execution permission
chmod +x scripts/scheduler-manager.sh

# Run
./scripts/scheduler-manager.sh

# Optional: specify project, location or log file
./scripts/scheduler-manager.sh -p my-project -l us-central1 -f ~/logs/scheduler.log
```

> **Tip:** To use VSCode as the editor for body/JSON editing:
> `export EDITOR="code --wait"`

---

## Configuration

Both scripts use defaults that can be overridden via parameters:

| Parameter | PowerShell | Bash | Default |
|-----------|-----------|------|---------|
| GCP Project | `-Project` | `-p` | `eqtl-prj-dev-dlk-bronze` |
| Location | `-Location` | `-l` | `southamerica-east1` |
| Log file | `-LogFile` | `-f` | `scheduler_changes.log` |

---

## Menu Overview

```
================================================
 Google Cloud Scheduler - Manager
================================================
Project  : my-project
Location : southamerica-east1
Log      : scheduler_changes.log

[1] Consult jobs
[2] Update jobs
[3] Copy job
[4] Enable / Disable
[5] Run jobs
[Q] Quit
```

### [2] Update — Batch Mode

When updating multiple jobs, you can choose:
- **Same value for all** — type cron/body once, applied to everyone
- **Different value per job** — prompted individually for each, with current value shown

### [3] Copy — Template Loop

After creating a copy, the script asks:
```
Create another job using 'JOB_EXPORT_001' as template? [y/N]:
```
Answer `y` to open the editor again with the same template, allowing you to create multiple jobs in one session.

### [4] Enable / Disable — Batch Options

```
[1] Enable all
[2] Disable all
[3] Invert state   ← each job flips to the opposite
```

---

## Logging

Every action is appended to the log file in the format:

```
[2026-05-07 14:32:10] [OK]    UPDATE OK | job=JOB_EXPORT_001 | cron: '0 6 * * *' -> '0 8 * * *'
[2026-05-07 14:33:01] [OK]    COPY OK | origem=JOB_EXPORT_001 | novo=JOB_EXPORT_002 | cron=0 6 * * 1
[2026-05-07 14:35:22] [ERROR] UPDATE FAIL | job=JOB_EXPORT_003 | erro=...
[2026-05-07 14:36:00] [OK]    TOGGLE OK | job=JOB_EXPORT_004 | ENABLED -> PAUSED
[2026-05-07 14:37:11] [OK]    RUN OK | job=JOB_EXPORT_005
```

---

## Body Editing

Job bodies are stored Base64-encoded in GCP. The tool handles encoding/decoding transparently:

- **On open**: body is decoded and shown as pretty-printed JSON in your editor
- **On save**: JSON is validated and compacted to a single line before sending
- **Unicode fix**: PowerShell's `ConvertTo-Json` escapes `'` as `\u0027` — this tool automatically converts those back to readable characters

---

## Project Structure

```
google-scheduler-manager/
├── scripts/
│   ├── scheduler-manager.ps1   # Windows / PowerShell 5.1+
│   └── scheduler-manager.sh    # macOS / Linux / Bash
├── docs/
│   └── README.pt-BR.md         # Portuguese documentation
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── workflows/
│       └── lint.yml
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

---

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Author

Renato Ubaldo Moreira e Moraes <renatoub@gmail.com>.
