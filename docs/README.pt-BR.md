# GCP Scheduler Manager

> Ferramenta de linha de comando interativa para gerenciar jobs do **Google Cloud Scheduler** — direto do terminal. Disponível para **Windows (PowerShell)** e **macOS/Linux (Bash)**.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)
![Bash](https://img.shields.io/badge/Bash-macOS%20%2F%20Linux-green?logo=gnubash)
![GCP](https://img.shields.io/badge/Google%20Cloud-Scheduler-orange?logo=googlecloud)

---

## Funcionalidades

| # | Funcionalidade | Descrição |
|---|---------------|-----------|
| 1 | **Consultar** | Lista todos os jobs com nome, cron e estado. Visualiza detalhes completos incluindo body decodificado. Exporta todos os jobs para JSON. |
| 2 | **Atualizar** | Edita cron e/ou body de qualquer job. Suporta modo individual e **lote** (mesmo valor para todos, ou valor diferente por job). Editor abre pré-preenchido com os valores atuais. |
| 3 | **Copiar** | Duplica qualquer job usando-o como template. Suporta criação de **múltiplos jobs em sequência** a partir do mesmo template sem voltar ao menu. |
| 4 | **Habilitar / Desabilitar** | Pausa ou retoma jobs individualmente ou em lote. Suporta **inverter estado** (cada job vai para o oposto do atual). |
| 5 | **Executar** | Dispara execução imediata de um ou vários jobs, com confirmação por job. |

Todas as ações são registradas automaticamente em `scheduler_changes.log`.

---

## Requisitos

### Windows (PowerShell)
- PowerShell 5.1 ou superior *(já incluso no Windows 10/11)*
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) com `gcloud` no PATH
- Sessão autenticada: `gcloud auth login`

### macOS / Linux (Bash)
- Bash 3.2+ ou Zsh
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) com `gcloud` no PATH
- **jq** — `brew install jq` *(macOS)* ou `apt install jq` *(Ubuntu)*
- Sessão autenticada: `gcloud auth login`

---

## Inicio Rapido

### Windows

```powershell
# Clone o repositório
git clone https://github.com/SEU_USUARIO/gcp-scheduler-manager.git
cd gcp-scheduler-manager

# Execute
.\scripts\scheduler-manager.ps1

# Opcional: especifique projeto, location ou arquivo de log
.\scripts\scheduler-manager.ps1 -Project meu-projeto -Location us-central1 -LogFile C:\logs\scheduler.log
```

> **Nota:** Se receber erro de política de execução, rode:
> `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### macOS / Linux

```bash
# Clone o repositório
git clone https://github.com/SEU_USUARIO/gcp-scheduler-manager.git
cd gcp-scheduler-manager

# Dê permissão de execução
chmod +x scripts/scheduler-manager.sh

# Execute
./scripts/scheduler-manager.sh

# Opcional: especifique projeto, location ou arquivo de log
./scripts/scheduler-manager.sh -p meu-projeto -l us-central1 -f ~/logs/scheduler.log
```

> **Dica:** Para usar o VSCode como editor para edição de body/JSON:
> `export EDITOR="code --wait"`

---

## Configuracao

Ambos os scripts possuem valores padrão que podem ser sobrescritos via parâmetros:

| Parâmetro | PowerShell | Bash | Padrão |
|-----------|-----------|------|--------|
| Projeto GCP | `-Project` | `-p` | `eqtl-prj-dev-dlk-bronze` |
| Location | `-Location` | `-l` | `southamerica-east1` |
| Arquivo de log | `-LogFile` | `-f` | `scheduler_changes.log` |

---

## Visao Geral do Menu

```
================================================
 Google Cloud Scheduler - Gerenciador
================================================
Projeto  : meu-projeto
Location : southamerica-east1
Log      : scheduler_changes.log

[1] Consultar jobs
[2] Atualizar jobs
[3] Copiar job
[4] Habilitar / Desabilitar
[5] Executar jobs
[Q] Sair
```

### [2] Atualizar — Modo Lote

Ao atualizar múltiplos jobs, você escolhe:
- **Mesmo valor para todos** — digita cron/body uma vez, aplicado para todos
- **Valor diferente por job** — solicitado individualmente para cada um, com valor atual exibido

### [3] Copiar — Loop de Template

Após criar uma cópia, o script pergunta:
```
Criar outro job usando 'JOB_EXPORT_001' como template? [s/N]:
```
Responda `s` para abrir o editor novamente com o mesmo template, permitindo criar múltiplos jobs em uma única sessão.

### [4] Habilitar / Desabilitar — Opções de Lote

```
[1] Habilitar todos
[2] Desabilitar todos
[3] Inverter estado   <- cada job vai para o oposto do atual
```

---

## Log de Alteracoes

Toda ação é registrada no arquivo de log no formato:

```
[2026-05-07 14:32:10] [OK]    UPDATE OK | job=JOB_EXPORT_001 | cron: '0 6 * * *' -> '0 8 * * *'
[2026-05-07 14:33:01] [OK]    COPY OK | origem=JOB_EXPORT_001 | novo=JOB_EXPORT_002 | cron=0 6 * * 1
[2026-05-07 14:35:22] [ERROR] UPDATE FAIL | job=JOB_EXPORT_003 | erro=...
[2026-05-07 14:36:00] [OK]    TOGGLE OK | job=JOB_EXPORT_004 | ENABLED -> PAUSED
[2026-05-07 14:37:11] [OK]    RUN OK | job=JOB_EXPORT_005
```

---

## Edicao de Body

Os bodies dos jobs são armazenados em Base64 no GCP. A ferramenta lida com codificação/decodificação de forma transparente:

- **Ao abrir**: o body é decodificado e exibido como JSON formatado no seu editor
- **Ao salvar**: o JSON é validado e compactado em uma linha antes do envio
- **Correção Unicode**: o `ConvertTo-Json` do PowerShell escapa `'` como `\u0027` — esta ferramenta converte automaticamente de volta para caracteres legíveis

---

## Estrutura do Projeto

```
gcp-scheduler-manager/
├── scripts/
│   ├── scheduler-manager.ps1   # Windows / PowerShell 5.1+
│   └── scheduler-manager.sh    # macOS / Linux / Bash
├── docs/
│   └── README.pt-BR.md         # Documentação em português
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

## Contribuindo

Contribuições são bem-vindas! Leia o [CONTRIBUTING.md](../CONTRIBUTING.md) antes de abrir um pull request.

---

## Licença

Este projeto está licenciado sob a [Licença MIT](../LICENSE).

---

## Autor

Renato Ubaldo Moreira e Moraes <renatoub@gmail.com>.
