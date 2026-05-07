#!/usr/bin/env bash
# ================================================================
# scheduler-manager.sh  (macOS / Linux - bash 3.2+)
# GCP Scheduler Manager - Interactive CLI for Google Cloud Scheduler
# Gerenciador GCP - CLI interativo para o Google Cloud Scheduler
#
# Language is loaded from config file at startup.
# O idioma e carregado do arquivo de configuracao na inicializacao.
#
# Requires / Requer: gcloud, jq (brew install jq)
# Usage / Uso: ./scheduler-manager.sh [-c CONFIG_FILE]
# ================================================================

set -euo pipefail

# ----------------------------------------------------------------
# Script directory / Diretorio do script
# ----------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/scheduler-manager.cfg"

# Optional config file override / Substituicao opcional do arquivo de config
while getopts "c:" opt 2>/dev/null; do
  case $opt in
    c) CONFIG_FILE="$OPTARG" ;;
  esac
done

# ================================================================
# ANSI COLORS / CORES ANSI
# ================================================================
CY='\033[0;36m'; GR='\033[0;32m'; YL='\033[0;33m'
RD='\033[0;31m'; DG='\033[0;90m'; WH='\033[0;97m'
DC='\033[0;96m'; NC='\033[0m'

# ================================================================
# LANGUAGE STRINGS / STRINGS DE IDIOMA
# ================================================================
# Keys are identical between EN and PT arrays.
# As chaves sao identicas entre os arrays EN e PT.

declare -A LANG_EN
LANG_EN[menu_title]="Google Cloud Scheduler - Manager"
LANG_EN[menu_project]="Project"
LANG_EN[menu_location]="Location"
LANG_EN[menu_log]="Log"
LANG_EN[menu_opt_consult]="Consult jobs"
LANG_EN[menu_opt_update]="Update jobs"
LANG_EN[menu_opt_copy]="Copy job"
LANG_EN[menu_opt_toggle]="Enable / Disable"
LANG_EN[menu_opt_run]="Run jobs"
LANG_EN[menu_opt_quit]="Quit"
LANG_EN[menu_invalid]="Invalid option."
LANG_EN[loading_jobs]="Loading jobs..."
LANG_EN[no_jobs_found]="No jobs found."
LANG_EN[confirm_yn]="[y/N]"
LANG_EN[confirm_yes]="y"
LANG_EN[cancelled]="Cancelled."
LANG_EN[back_to_list]="[Enter] back to list"
LANG_EN[invalid_option]="Invalid option."
LANG_EN[none_selected]="No jobs selected."
LANG_EN[no_valid_index]="No valid index."
LANG_EN[nothing_to_apply]="Nothing to apply."
LANG_EN[selected_jobs]="Selected jobs:"
LANG_EN[col_num]="#"
LANG_EN[col_name]="Name"
LANG_EN[col_cron]="Cron"
LANG_EN[col_status]="Status"
LANG_EN[detail_name]="Name"
LANG_EN[detail_cron]="Cron"
LANG_EN[detail_timezone]="TimeZone"
LANG_EN[detail_status]="Status"
LANG_EN[detail_type]="Type"
LANG_EN[detail_url]="URL"
LANG_EN[detail_method]="Method"
LANG_EN[detail_topic]="Topic"
LANG_EN[detail_body]="Body (decoded)"
LANG_EN[detail_data]="Data (decoded)"
LANG_EN[detail_last_exec]="Last exec"
LANG_EN[detail_status_code]="Status code"
LANG_EN[detail_status_msg]="Status msg"
LANG_EN[consult_opt_detail]="view job detail"
LANG_EN[consult_opt_export]="export all to JSON"
LANG_EN[consult_opt_reload]="reload list"
LANG_EN[consult_opt_back]="back to main menu"
LANG_EN[export_title]="Export jobs"
LANG_EN[export_folder_prompt]="Destination folder (Enter for"
LANG_EN[export_folder_warn]="Folder not found, using default."
LANG_EN[export_ok]="Exported"
LANG_EN[export_jobs_label]="jobs"
LANG_EN[update_opt_job]="select a job"
LANG_EN[update_opt_batch]="batch mode (multiple jobs)"
LANG_EN[update_opt_back]="back to main menu"
LANG_EN[update_what]="What to update?"
LANG_EN[update_opt_cron]="Cron"
LANG_EN[update_opt_body]="Body"
LANG_EN[update_opt_both]="Cron + Body"
LANG_EN[update_opt_cancel]="Cancel"
LANG_EN[update_how]="How to define values?"
LANG_EN[update_same_for_all]="Same value for all jobs"
LANG_EN[update_diff_per_job]="Different value per job"
LANG_EN[update_cron_empty]="Empty cron - ignored."
LANG_EN[update_body_empty]="Empty body - ignored."
LANG_EN[update_body_unchanged]="Body was not changed - ignored."
LANG_EN[update_body_valid]="Valid JSON - compacted for sending."
LANG_EN[update_body_invalid]="Invalid JSON. Try again?"
LANG_EN[update_body_no_valid]="Sending body without JSON validation."
LANG_EN[update_body_preview]="Preview"
LANG_EN[update_cron_current]="Current cron"
LANG_EN[update_cron_label]="New cron (e.g. '0 6 * * *')"
LANG_EN[update_body_current]="Current body"
LANG_EN[update_body_label]="New body (JSON)"
LANG_EN[update_cron_unique]="Single cron for all jobs"
LANG_EN[update_body_unique]="Single body for all jobs"
LANG_EN[update_editor_open]="Opening editor with current value."
LANG_EN[update_editor_inst]="Edit JSON, save and close the editor to continue."
LANG_EN[update_confirm]="Confirm?"
LANG_EN[update_batch_confirm]="Confirm batch apply?"
LANG_EN[update_batch_title]="Batch summary"
LANG_EN[update_applying]="Applying..."
LANG_EN[update_ok]="Updated."
LANG_EN[update_fail]="Failed"
LANG_EN[update_batch_start]="Batch started"
LANG_EN[update_batch_done]="Batch completed"
LANG_EN[update_no_info]="No value provided."
LANG_EN[copy_opt_job]="select source job"
LANG_EN[copy_opt_back]="back to main menu"
LANG_EN[copy_title]="Copy job"
LANG_EN[copy_editor_open]="Opening editor with source job data."
LANG_EN[copy_editor_inst]="Change name, cron, uri and/or body as needed."
LANG_EN[copy_editor_save]="Save and close the editor to continue."
LANG_EN[copy_empty_editor]="Editor closed with no content - cancelled."
LANG_EN[copy_invalid_json]="Invalid JSON after editing - cancelled."
LANG_EN[copy_name_required]="Field 'name' is required."
LANG_EN[copy_name_same_warn]="New job name is the same as the original."
LANG_EN[copy_name_same_warn2]="A job with this name already exists."
LANG_EN[copy_name_same_cont]="Continue anyway?"
LANG_EN[copy_summary_name]="Name (new)"
LANG_EN[copy_summary_cron]="Cron"
LANG_EN[copy_summary_uri]="URI"
LANG_EN[copy_summary_body]="Body"
LANG_EN[copy_summary_updated]="updated"
LANG_EN[copy_confirm]="Confirm creation?"
LANG_EN[copy_creating]="Creating job..."
LANG_EN[copy_ok]="created successfully!"
LANG_EN[copy_fail_title]="Failed to create job:"
LANG_EN[copy_more]="Create another job using"
LANG_EN[copy_more2]="as template?"
LANG_EN[copy_unsupported]="Target type not supported for copy."
LANG_EN[toggle_opt_job]="toggle job state"
LANG_EN[toggle_opt_batch]="toggle in batch"
LANG_EN[toggle_opt_back]="back to main menu"
LANG_EN[toggle_batch_title]="Batch - select jobs"
LANG_EN[toggle_enable_all]="Enable all"
LANG_EN[toggle_disable_all]="Disable all"
LANG_EN[toggle_invert]="Invert state"
LANG_EN[toggle_cancel]="Cancel"
LANG_EN[toggle_confirm_batch]="Confirm for"
LANG_EN[toggle_confirm_batch2]="jobs?"
LANG_EN[toggle_applying]="Applying..."
LANG_EN[toggle_already]="Already"
LANG_EN[toggle_already2]="- ignored."
LANG_EN[toggle_ok]="updated."
LANG_EN[toggle_fail]="Failed"
LANG_EN[toggle_confirm_single]="Confirm?"
LANG_EN[run_opt_job]="run a job"
LANG_EN[run_opt_batch]="run in batch"
LANG_EN[run_opt_back]="back to main menu"
LANG_EN[run_batch_title]="Batch - select jobs to run"
LANG_EN[run_confirm_batch]="Confirm execution of"
LANG_EN[run_confirm_batch2]="jobs?"
LANG_EN[run_running]="Running batch..."
LANG_EN[run_confirm_single]="Confirm execution of job"
LANG_EN[run_ok]="Execution triggered."
LANG_EN[run_ok_single]="Execution triggered successfully."
LANG_EN[run_fail]="Failed"
LANG_EN[cfg_welcome]="Welcome to GCP Scheduler Manager!"
LANG_EN[cfg_first_run]="Config file not found. Let's set it up."
LANG_EN[cfg_lang_prompt]="Choose language / Escolha o idioma:"
LANG_EN[cfg_lang_en]="English"
LANG_EN[cfg_lang_pt]="Portuguese BR"
LANG_EN[cfg_project_prompt]="GCP Project name"
LANG_EN[cfg_project_default]="Default"
LANG_EN[cfg_location_prompt]="Location"
LANG_EN[cfg_location_default]="Default"
LANG_EN[cfg_log_prompt]="Log file path"
LANG_EN[cfg_log_default]="Default"
LANG_EN[cfg_saved]="Config saved to"
LANG_EN[cfg_loaded]="Config loaded from"
LANG_EN[choose]="Choose"
LANG_EN[select_hint]="Numbers, ranges or all/todos (e.g. 1,3,23-27,31)"

declare -A LANG_PT
LANG_PT[menu_title]="Google Cloud Scheduler - Gerenciador"
LANG_PT[menu_project]="Projeto"
LANG_PT[menu_location]="Location"
LANG_PT[menu_log]="Log"
LANG_PT[menu_opt_consult]="Consultar jobs"
LANG_PT[menu_opt_update]="Atualizar jobs"
LANG_PT[menu_opt_copy]="Copiar job"
LANG_PT[menu_opt_toggle]="Habilitar / Desabilitar"
LANG_PT[menu_opt_run]="Executar jobs"
LANG_PT[menu_opt_quit]="Sair"
LANG_PT[menu_invalid]="Opcao invalida."
LANG_PT[loading_jobs]="Carregando jobs..."
LANG_PT[no_jobs_found]="Nenhum job encontrado."
LANG_PT[confirm_yn]="[s/N]"
LANG_PT[confirm_yes]="s"
LANG_PT[cancelled]="Cancelado."
LANG_PT[back_to_list]="[Enter] voltar a lista"
LANG_PT[invalid_option]="Opcao invalida."
LANG_PT[none_selected]="Nenhum job selecionado."
LANG_PT[no_valid_index]="Nenhum indice valido."
LANG_PT[nothing_to_apply]="Nada para aplicar."
LANG_PT[selected_jobs]="Jobs selecionados:"
LANG_PT[col_num]="#"
LANG_PT[col_name]="Nome"
LANG_PT[col_cron]="Cron"
LANG_PT[col_status]="Estado"
LANG_PT[detail_name]="Nome"
LANG_PT[detail_cron]="Cron"
LANG_PT[detail_timezone]="TimeZone"
LANG_PT[detail_status]="Estado"
LANG_PT[detail_type]="Tipo"
LANG_PT[detail_url]="URL"
LANG_PT[detail_method]="Metodo"
LANG_PT[detail_topic]="Topico"
LANG_PT[detail_body]="Body (decodificado)"
LANG_PT[detail_data]="Data (decodificado)"
LANG_PT[detail_last_exec]="Ultima exec"
LANG_PT[detail_status_code]="Status code"
LANG_PT[detail_status_msg]="Status msg"
LANG_PT[consult_opt_detail]="ver detalhe do job"
LANG_PT[consult_opt_export]="exportar todos para JSON"
LANG_PT[consult_opt_reload]="recarregar lista"
LANG_PT[consult_opt_back]="voltar ao menu principal"
LANG_PT[export_title]="Exportar jobs"
LANG_PT[export_folder_prompt]="Pasta de destino (Enter para"
LANG_PT[export_folder_warn]="Pasta nao encontrada, usando padrao."
LANG_PT[export_ok]="Exportado"
LANG_PT[export_jobs_label]="jobs"
LANG_PT[update_opt_job]="selecionar um job"
LANG_PT[update_opt_batch]="modo lote (varios jobs)"
LANG_PT[update_opt_back]="voltar ao menu principal"
LANG_PT[update_what]="O que atualizar?"
LANG_PT[update_opt_cron]="Cron"
LANG_PT[update_opt_body]="Body"
LANG_PT[update_opt_both]="Cron + Body"
LANG_PT[update_opt_cancel]="Cancelar"
LANG_PT[update_how]="Como definir os valores?"
LANG_PT[update_same_for_all]="Mesmo valor para todos os jobs"
LANG_PT[update_diff_per_job]="Valor diferente para cada job"
LANG_PT[update_cron_empty]="Cron vazio - ignorado."
LANG_PT[update_body_empty]="Body vazio - ignorado."
LANG_PT[update_body_unchanged]="Body nao foi alterado - ignorado."
LANG_PT[update_body_valid]="JSON valido - compactado para envio."
LANG_PT[update_body_invalid]="JSON invalido. Tentar novamente?"
LANG_PT[update_body_no_valid]="Enviando body sem validacao JSON."
LANG_PT[update_body_preview]="Preview"
LANG_PT[update_cron_current]="Cron atual"
LANG_PT[update_cron_label]="Novo cron (ex: '0 6 * * *')"
LANG_PT[update_body_current]="Body atual"
LANG_PT[update_body_label]="Novo body (JSON)"
LANG_PT[update_cron_unique]="Cron unico para todos os jobs"
LANG_PT[update_body_unique]="Body unico para todos os jobs"
LANG_PT[update_editor_open]="Abrindo editor com o valor atual."
LANG_PT[update_editor_inst]="Edite o JSON, salve e feche o editor para continuar."
LANG_PT[update_confirm]="Confirmar?"
LANG_PT[update_batch_confirm]="Confirmar aplicacao do lote?"
LANG_PT[update_batch_title]="Resumo do lote"
LANG_PT[update_applying]="Aplicando..."
LANG_PT[update_ok]="Atualizado."
LANG_PT[update_fail]="Falha"
LANG_PT[update_batch_start]="LOTE iniciado"
LANG_PT[update_batch_done]="LOTE concluido"
LANG_PT[update_no_info]="Nenhum valor informado."
LANG_PT[copy_opt_job]="selecionar job de origem"
LANG_PT[copy_opt_back]="voltar ao menu principal"
LANG_PT[copy_title]="Copiar job"
LANG_PT[copy_editor_open]="Abrindo editor com os dados do job de origem."
LANG_PT[copy_editor_inst]="Altere name, cron, uri e/ou body conforme necessario."
LANG_PT[copy_editor_save]="Salve e feche o editor para continuar."
LANG_PT[copy_empty_editor]="Editor fechado sem conteudo - operacao cancelada."
LANG_PT[copy_invalid_json]="JSON invalido apos edicao - operacao cancelada."
LANG_PT[copy_name_required]="Campo 'name' e obrigatorio."
LANG_PT[copy_name_same_warn]="O nome do novo job e igual ao original."
LANG_PT[copy_name_same_warn2]="Um job com esse nome ja existe."
LANG_PT[copy_name_same_cont]="Deseja continuar mesmo assim?"
LANG_PT[copy_summary_name]="Nome (novo)"
LANG_PT[copy_summary_cron]="Cron"
LANG_PT[copy_summary_uri]="URI"
LANG_PT[copy_summary_body]="Body"
LANG_PT[copy_summary_updated]="atualizado"
LANG_PT[copy_confirm]="Confirmar criacao?"
LANG_PT[copy_creating]="Criando job..."
LANG_PT[copy_ok]="criado com sucesso!"
LANG_PT[copy_fail_title]="Falha ao criar job:"
LANG_PT[copy_more]="Criar outro job usando"
LANG_PT[copy_more2]="como template?"
LANG_PT[copy_unsupported]="Tipo de target nao suportado para copia."
LANG_PT[toggle_opt_job]="alternar estado do job"
LANG_PT[toggle_opt_batch]="alternar em lote"
LANG_PT[toggle_opt_back]="voltar ao menu principal"
LANG_PT[toggle_batch_title]="Lote - selecione os jobs"
LANG_PT[toggle_enable_all]="Habilitar todos"
LANG_PT[toggle_disable_all]="Desabilitar todos"
LANG_PT[toggle_invert]="Inverter estado"
LANG_PT[toggle_cancel]="Cancelar"
LANG_PT[toggle_confirm_batch]="Confirmar para"
LANG_PT[toggle_confirm_batch2]="jobs?"
LANG_PT[toggle_applying]="Aplicando..."
LANG_PT[toggle_already]="Ja esta"
LANG_PT[toggle_already2]="- ignorado."
LANG_PT[toggle_ok]="atualizado."
LANG_PT[toggle_fail]="Falha"
LANG_PT[toggle_confirm_single]="Confirmar?"
LANG_PT[run_opt_job]="executar um job"
LANG_PT[run_opt_batch]="executar em lote"
LANG_PT[run_opt_back]="voltar ao menu principal"
LANG_PT[run_batch_title]="Lote - selecione os jobs para executar"
LANG_PT[run_confirm_batch]="Confirmar execucao de"
LANG_PT[run_confirm_batch2]="jobs?"
LANG_PT[run_running]="Executando lote..."
LANG_PT[run_confirm_single]="Confirmar execucao do job"
LANG_PT[run_ok]="Execucao disparada."
LANG_PT[run_ok_single]="Execucao disparada com sucesso."
LANG_PT[run_fail]="Falha"
LANG_PT[cfg_welcome]="Bem-vindo ao GCP Scheduler Manager!"
LANG_PT[cfg_first_run]="Arquivo de configuracao nao encontrado. Vamos configura-lo."
LANG_PT[cfg_lang_prompt]="Escolha o idioma / Choose language:"
LANG_PT[cfg_lang_en]="Ingles (English)"
LANG_PT[cfg_lang_pt]="Portugues BR"
LANG_PT[cfg_project_prompt]="Nome do projeto GCP"
LANG_PT[cfg_project_default]="Padrao"
LANG_PT[cfg_location_prompt]="Location"
LANG_PT[cfg_location_default]="Padrao"
LANG_PT[cfg_log_prompt]="Caminho do arquivo de log"
LANG_PT[cfg_log_default]="Padrao"
LANG_PT[cfg_saved]="Configuracao salva em"
LANG_PT[cfg_loaded]="Configuracao carregada de"
LANG_PT[choose]="Escolha"
LANG_PT[select_hint]="Numeros, intervalos ou all/todos (ex: 1,3,23-27,31)"

# Active language reference / Referencia de idioma ativo
# Bash 3 doesn't support namerefs, so we use a function.
# Bash 3 nao suporta namerefs, entao usamos uma funcao.
LANG_CODE="EN"

# Translate / Traduzir
t() {
  local key="$1"
  if [[ "$LANG_CODE" == "PT" ]]; then
    echo "${LANG_PT[$key]:-$key}"
  else
    echo "${LANG_EN[$key]:-$key}"
  fi
}

# ================================================================
# OUTPUT HELPERS / AUXILIARES DE OUTPUT
# ================================================================
write_header() {
  local txt="$1"
  local line; line=$(printf '%*s' "${#txt}" '' | tr ' ' '-')
  echo
  printf "  ${CY}%s${NC}\n" "$txt"
  printf "  ${DG}%s${NC}\n" "$line"
}
write_ok()   { printf "  ${GR}[OK]${NC} %s\n" "$1"; }
write_warn() { printf "  ${YL}[!] ${NC} %s\n" "$1"; }
write_err()  { printf "  ${RD}[X] ${NC} %s\n" "$1"; }
write_info() { printf "       ${DG}%s${NC}\n"  "$1"; }

# ================================================================
# LOGGING / LOG
# ================================================================
write_log() {
  local msg="$1" level="${2:-INFO}" ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$ts] [$level] $msg" >> "$LOG_FILE"
}

# ================================================================
# CONFIG FILE / ARQUIVO DE CONFIGURACAO
# ================================================================
load_config() {
  # Default values / Valores padroes
  local def_project="eqtl-prj-dev-dlk-bronze"
  local def_location="southamerica-east1"
  local def_log="${SCRIPT_DIR}/scheduler_changes.log"

  if [[ -f "$CONFIG_FILE" ]]; then
    # Parse KEY=VALUE ignoring comments / Faz parse KEY=VALOR ignorando comentarios
    while IFS='=' read -r key val; do
      key=$(echo "$key" | xargs 2>/dev/null || echo "$key")
      val=$(echo "$val" | xargs 2>/dev/null || echo "$val")
      [[ -z "$key" || "$key" == \#* ]] && continue
      case "$key" in
        language) LANG_CODE="${val^^}" ;;
        project)  PROJECT="$val"       ;;
        location) LOCATION="$val"      ;;
        log_file) LOG_FILE="$val"      ;;
      esac
    done < "$CONFIG_FILE"

    PROJECT="${PROJECT:-$def_project}"
    LOCATION="${LOCATION:-$def_location}"
    LOG_FILE="${LOG_FILE:-$def_log}"
    write_info "$(t cfg_loaded): $CONFIG_FILE"
  else
    # First-run wizard / Assistente de primeira execucao
    echo
    printf "  ${CY}================================================${NC}\n"
    printf "  ${CY}%s${NC}\n" "${LANG_EN[cfg_welcome]}"
    printf "  ${CY}================================================${NC}\n\n"
    printf "  ${YL}%s${NC}\n\n" "${LANG_EN[cfg_first_run]}"

    # Language / Idioma
    printf "  %s\n" "${LANG_EN[cfg_lang_prompt]}"
    printf "  [1] %s\n" "${LANG_EN[cfg_lang_en]}"
    printf "  [2] %s\n\n" "${LANG_EN[cfg_lang_pt]}"
    while true; do
      read -r -p "  ${LANG_EN[choose]}: " lang_choice
      [[ "$lang_choice" =~ ^[12]$ ]] && break
    done
    [[ "$lang_choice" == "2" ]] && LANG_CODE="PT" || LANG_CODE="EN"
    echo

    # Project / Projeto
    printf "  %s (%s: %s):\n" "$(t cfg_project_prompt)" "$(t cfg_project_default)" "$def_project"
    read -r -p "  >> " input_project
    input_project=$(echo "$input_project" | xargs 2>/dev/null || echo "$input_project")
    PROJECT="${input_project:-$def_project}"

    # Location
    printf "  %s (%s: %s):\n" "$(t cfg_location_prompt)" "$(t cfg_location_default)" "$def_location"
    read -r -p "  >> " input_location
    input_location=$(echo "$input_location" | xargs 2>/dev/null || echo "$input_location")
    LOCATION="${input_location:-$def_location}"

    # Log file / Arquivo de log
    printf "  %s (%s: %s):\n" "$(t cfg_log_prompt)" "$(t cfg_log_default)" "$def_log"
    read -r -p "  >> " input_log
    input_log=$(echo "$input_log" | xargs 2>/dev/null || echo "$input_log")
    LOG_FILE="${input_log:-$def_log}"

    # Write config / Grava configuracao
    cat > "$CONFIG_FILE" << CFGEOF
# GCP Scheduler Manager - Config file
# Generated automatically / Gerado automaticamente
# $(date '+%Y-%m-%d %H:%M:%S')

language = ${LANG_CODE}
project  = ${PROJECT}
location = ${LOCATION}
log_file = ${LOG_FILE}
CFGEOF

    echo
    write_ok "$(t cfg_saved): $CONFIG_FILE"
    echo
  fi
}

# ================================================================
# DEPENDENCY CHECK / VERIFICACAO DE DEPENDENCIAS
# ================================================================
check_deps() {
  for cmd in gcloud jq base64; do
    if ! command -v "$cmd" &>/dev/null; then
      write_err "Missing dependency / Dependencia ausente: '$cmd'"
      [[ "$cmd" == "jq" ]] && write_info "Install with / Instale com: brew install jq"
      exit 1
    fi
  done
}

# ================================================================
# BASE64 DECODE / DECODIFICACAO BASE64
# ================================================================
decode_body() {
  local b64="$1"
  [[ -z "$b64" ]] && echo "" && return
  echo "$b64" | base64 --decode 2>/dev/null || echo "[error decoding / erro ao decodificar]"
}

# ================================================================
# EDITOR HELPER / AUXILIAR DE EDITOR
# Opens editor pre-filled with content, returns result in EDITOR_RESULT
# Abre editor pre-preenchido, retorna resultado em EDITOR_RESULT
# ================================================================
open_editor() {
  local content="$1"
  local tmpfile; tmpfile=$(mktemp /tmp/scheduler_XXXXXX.json)
  echo "$content" > "$tmpfile"

  local editor
  if   [[ -n "${EDITOR:-}" ]];          then editor="$EDITOR"
  elif command -v nano &>/dev/null;      then editor="nano"
  elif command -v vim  &>/dev/null;      then editor="vim"
  else
    write_err "No editor found. Set: export EDITOR=nano"
    rm -f "$tmpfile"; EDITOR_RESULT=""; return
  fi

  write_info "$(t update_editor_open) ($editor)"
  sleep 0.3
  $editor "$tmpfile"
  EDITOR_RESULT=$(cat "$tmpfile")
  rm -f "$tmpfile"
}

# ================================================================
# LOAD JOBS / CARREGA JOBS
# ================================================================
load_jobs() {
  printf "  ${DG}%s${NC}\n" "$(t loading_jobs)"
  JOBS_JSON=$(gcloud scheduler jobs list \
    --project="$PROJECT" \
    --location="$LOCATION" \
    --format=json 2>&1) || { write_err "gcloud error: $JOBS_JSON"; return 1; }

  JOBS_COUNT=$(echo "$JOBS_JSON" | jq 'length')
  if [[ "$JOBS_COUNT" -eq 0 ]]; then
    write_warn "$(t no_jobs_found)"; return 1
  fi

  JOBS_NAMES=(); JOBS_SCHEDULES=(); JOBS_STATES=()
  while IFS= read -r line; do
    JOBS_NAMES+=("$(echo "$line" | jq -r '.name | split("/") | last')")
    JOBS_SCHEDULES+=("$(echo "$line" | jq -r '.schedule // ""')")
    JOBS_STATES+=("$(echo "$line" | jq -r '.state // ""')")
  done < <(echo "$JOBS_JSON" | jq -c '.[]')
  return 0
}

# ================================================================
# JOB TABLE / TABELA DE JOBS
# ================================================================
show_job_table() {
  echo
  local max_len=4
  for n in "${JOBS_NAMES[@]}"; do [[ ${#n} -gt $max_len ]] && max_len=${#n}; done

  printf "  ${DG}%-3s  %-${max_len}s  %-17s  %s${NC}\n" \
    "$(t col_num)" "$(t col_name)" "$(t col_cron)" "$(t col_status)"
  printf "  ${DG}%s${NC}\n" "$(printf '%*s' $((max_len + 44)) '' | tr ' ' '-')"

  local i
  for i in "${!JOBS_NAMES[@]}"; do
    local cor="$WH"
    [[ "${JOBS_STATES[$i]}" != "ENABLED" ]] && cor="$DG"
    printf "  ${cor}%-3s  %-${max_len}s  %-17s  %s${NC}\n" \
      $(( i + 1 )) "${JOBS_NAMES[$i]}" "${JOBS_SCHEDULES[$i]}" "${JOBS_STATES[$i]}"
  done
  echo
}

# ================================================================
# PARSE SELECTION WITH RANGES / PARSE DA SELECAO COM INTERVALOS
# Supports: 1,3,23-27,31  or  all  or  todos
# Suporta:  1,3,23-27,31  ou  all  ou  todos
# Returns 0-based indices in array PARSED_IDXS
# Retorna indices base-0 no array PARSED_IDXS
# ================================================================
parse_selection() {
  local sel="$1" total="$2"
  PARSED_IDXS=()

  if [[ "$sel" == "all" || "$sel" == "todos" ]]; then
    for (( i=0; i<total; i++ )); do PARSED_IDXS+=("$i"); done
    return 0
  fi

  # Split by comma, then handle ranges / Divide por virgula, depois trata intervalos
  IFS=',' read -ra PARTS <<< "$sel"
  for part in "${PARTS[@]}"; do
    part=$(echo "$part" | xargs 2>/dev/null || echo "$part")
    if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
      # Range / Intervalo
      local start="${BASH_REMATCH[1]}" end="${BASH_REMATCH[2]}"
      if [[ $start -le $end && $start -ge 1 && $end -le $total ]]; then
        for (( n=start; n<=end; n++ )); do PARSED_IDXS+=("$(( n - 1 ))"); done
      fi
    elif [[ "$part" =~ ^[0-9]+$ ]]; then
      # Single number / Numero simples
      if [[ "$part" -ge 1 && "$part" -le "$total" ]]; then
        PARSED_IDXS+=("$(( part - 1 ))")
      fi
    fi
  done
}

# ================================================================
# CONFIRM HELPER / AUXILIAR DE CONFIRMACAO
# ================================================================
confirm() {
  local prompt="$1"
  local answer
  read -r -p "  $prompt $(t confirm_yn): " answer
  [[ "$(echo "$answer" | tr '[:upper:]' '[:lower:]')" == "$(t confirm_yes)" ]]
}

# ================================================================
# CONSULT / CONSULTA
# ================================================================
show_job_detail() {
  local idx="$1"
  local name="${JOBS_NAMES[$idx]}"
  local job_json; job_json=$(echo "$JOBS_JSON" | jq --argjson i "$idx" '.[$i]')

  write_header "$(t col_name): $name"
  write_info "$(t detail_name)     : $name"
  write_info "$(t detail_cron)     : ${JOBS_SCHEDULES[$idx]}"
  write_info "$(t detail_timezone) : $(echo "$job_json" | jq -r '.timeZone // ""')"
  write_info "$(t detail_status)   : ${JOBS_STATES[$idx]}"

  local tipo; tipo=$(echo "$job_json" | jq -r \
    'if .httpTarget then "http" elif .pubsubTarget then "pubsub" else "?" end')

  if [[ "$tipo" == "http" ]]; then
    write_info "$(t detail_type)     : httpTarget"
    write_info "$(t detail_url)      : $(echo "$job_json" | jq -r '.httpTarget.uri // ""')"
    write_info "$(t detail_method)   : $(echo "$job_json" | jq -r '.httpTarget.httpMethod // ""')"
    local b64; b64=$(echo "$job_json" | jq -r '.httpTarget.body // ""')
    local body; body=$(decode_body "$b64")
    if [[ -n "$body" ]]; then
      echo; printf "  ${DG}--- %s ---${NC}\n" "$(t detail_body)"
      echo "$body" | jq . 2>/dev/null || echo "$body"
    fi
  elif [[ "$tipo" == "pubsub" ]]; then
    write_info "$(t detail_type)     : pubsubTarget"
    write_info "$(t detail_topic)    : $(echo "$job_json" | jq -r '.pubsubTarget.topicName // ""')"
    local b64; b64=$(echo "$job_json" | jq -r '.pubsubTarget.data // ""')
    local body; body=$(decode_body "$b64")
    if [[ -n "$body" ]]; then
      echo; printf "  ${DG}--- %s ---${NC}\n" "$(t detail_data)"
      echo "$body" | jq . 2>/dev/null || echo "$body"
    fi
  fi

  local last; last=$(echo "$job_json" | jq -r '.lastAttemptTime // ""')
  [[ -n "$last" ]] && write_info "$(t detail_last_exec) : $last"
}

export_jobs() {
  write_header "$(t export_title)"
  local fixed_name="scheduler_jobs_$(date '+%Y%m%d_%H%M%S').json"
  local default_dir="$HOME/Desktop"
  [[ ! -d "$default_dir" ]] && default_dir="$HOME"

  printf "  %s '%s'):\n" "$(t export_folder_prompt)" "$default_dir"
  read -r -p "  >> " folder
  folder=$(echo "$folder" | xargs 2>/dev/null || echo "$folder")
  if [[ -z "$folder" ]] || [[ ! -d "$folder" ]]; then
    [[ -n "$folder" ]] && write_warn "$(t export_folder_warn)"
    folder="$default_dir"
  fi
  local out_file="$folder/$fixed_name"

  echo "$JOBS_JSON" | jq '[.[] | {
    name:        (.name | split("/") | last),
    schedule:    .schedule,
    timeZone:    .timeZone,
    state:       .state,
    targetType:  (if .httpTarget then "httpTarget" elif .pubsubTarget then "pubsubTarget" else "unknown" end),
    url:         (.httpTarget.uri // ""),
    bodyDecoded: (if .httpTarget.body then (.httpTarget.body | @base64d)
                  elif .pubsubTarget.data then (.pubsubTarget.data | @base64d)
                  else "" end)
  }]' > "$out_file"

  write_ok "$(t export_ok): $out_file ($JOBS_COUNT $(t export_jobs_label))"
  write_log "EXPORT | file=$out_file | jobs=$JOBS_COUNT"
}

run_consult() {
  while true; do
    load_jobs || return
    show_job_table

    printf "  ${WH}[#]${NC}  %s\n" "$(t consult_opt_detail)"
    printf "  ${WH}[E]${NC}  %s\n" "$(t consult_opt_export)"
    printf "  ${WH}[R]${NC}  %s\n" "$(t consult_opt_reload)"
    printf "  ${DG}[V]${NC}  %s\n\n" "$(t consult_opt_back)"
    read -r -p "  $(t choose): " INPUT
    INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null || echo "$INPUT")

    [[ "$INPUT" == "v" ]] && break
    [[ "$INPUT" == "r" ]] && continue
    [[ "$INPUT" == "e" ]] && { export_jobs; continue; }

    if ! [[ "$INPUT" =~ ^[0-9]+$ ]] || [[ "$INPUT" -lt 1 ]] || [[ "$INPUT" -gt "$JOBS_COUNT" ]]; then
      write_warn "$(t invalid_option)"; continue
    fi
    show_job_detail $(( INPUT - 1 ))
    echo; printf "  ${DG}%s${NC}\n" "$(t back_to_list)"; read -r
  done
}

# ================================================================
# UPDATE / ATUALIZACAO
# ================================================================
read_cron_input() {
  local label="$1"
  write_info "$label:"
  read -r -p "  >> " REPLY_CRON
  REPLY_CRON=$(echo "$REPLY_CRON" | xargs 2>/dev/null || echo "$REPLY_CRON")
  if [[ -z "$REPLY_CRON" ]]; then
    write_warn "$(t update_cron_empty)"; REPLY_CRON=""
  fi
}

read_body_input() {
  local label="$1" current_body="${2:-}"
  local content

  if [[ -n "$current_body" ]] && echo "$current_body" | jq . &>/dev/null; then
    content=$(echo "$current_body" | jq .)
  elif [[ -n "$current_body" ]]; then
    content="$current_body"
  else
    content='{ "": "" }'
  fi

  write_info "$(t update_editor_inst)"
  echo
  open_editor "$content"
  local raw_body="$EDITOR_RESULT"

  if [[ -z "$(echo "$raw_body" | tr -d '[:space:]')" ]]; then
    write_warn "$(t update_body_empty)"; REPLY_BODY=""; return
  fi

  if echo "$raw_body" | jq . &>/dev/null; then
    local new_clean curr_clean
    new_clean=$(echo "$raw_body" | jq -c .)
    curr_clean=$(echo "$current_body" | jq -c . 2>/dev/null || echo "")
    if [[ "$new_clean" == "$curr_clean" ]]; then
      write_warn "$(t update_body_unchanged)"; REPLY_BODY=""; return
    fi
    REPLY_BODY="$new_clean"
    write_ok "$(t update_body_valid)"
    write_info "$(t update_body_preview): $(echo "$REPLY_BODY" | cut -c1-80)..."
  else
    write_warn "$(t update_body_invalid) $(t confirm_yn)"
    read -r -p "  >> " retry
    if [[ "$(echo "$retry" | tr '[:upper:]' '[:lower:]')" == "$(t confirm_yes)" ]]; then
      read_body_input "$label" "$current_body"
    else
      REPLY_BODY="$raw_body"; write_warn "$(t update_body_no_valid)"
    fi
  fi
}

apply_update() {
  local name="$1" cron="$2" body="$3" idx="$4"
  local job_json; job_json=$(echo "$JOBS_JSON" | jq --argjson i "$idx" '.[$i]')
  local tipo=""
  echo "$job_json" | jq -e '.httpTarget'   &>/dev/null && tipo="http"
  echo "$job_json" | jq -e '.pubsubTarget' &>/dev/null && tipo="pubsub"
  [[ -z "$tipo" ]] && { write_err "[$name] $(t copy_unsupported)"; return; }

  local -a flags=(scheduler jobs update "$tipo" "$name" \
    --project="$PROJECT" --location="$LOCATION")
  [[ -n "$cron" ]] && flags+=(--schedule="$cron")

  local result rc=0
  if [[ -n "$body" && "$tipo" == "http" ]]; then
    flags+=(--message-body-from-file=-)
    result=$(echo "$body" | gcloud "${flags[@]}" 2>&1) && rc=0 || rc=$?
  elif [[ -n "$body" && "$tipo" == "pubsub" ]]; then
    flags+=(--message-body="$body")
    result=$(gcloud "${flags[@]}" 2>&1) && rc=0 || rc=$?
  else
    result=$(gcloud "${flags[@]}" 2>&1) && rc=0 || rc=$?
  fi

  if [[ $rc -eq 0 ]]; then
    write_ok "[$name] $(t update_ok)"
    local log_msg="UPDATE OK | job=$name"
    [[ -n "$cron" ]] && log_msg+=" | cron: '${JOBS_SCHEDULES[$idx]}' -> '$cron'"
    [[ -n "$body" ]] && log_msg+=" | body updated"
    write_log "$log_msg" "OK"
  else
    write_err "[$name] $(t update_fail): $result"
    write_log "UPDATE FAIL | job=$name | error=$result" "ERROR"
  fi
}

collect_batch_individual() {
  local -a sel_idxs=("$@")
  BATCH_NAMES=(); BATCH_CRONS=(); BATCH_BODYS=(); BATCH_IDXS=()
  local total=${#sel_idxs[@]} pos=1

  for idx in "${sel_idxs[@]}"; do
    local name="${JOBS_NAMES[$idx]}" cron="" body=""
    echo; printf "  ${DC}[%d/%d] %s${NC}\n" "$pos" "$total" "$name"

    if [[ $UPDATE_MODE -eq 1 || $UPDATE_MODE -eq 3 ]]; then
      write_info "$(t update_cron_current): ${JOBS_SCHEDULES[$idx]}"
      read_cron_input "$(t update_cron_label)"; cron="$REPLY_CRON"
    fi
    if [[ $UPDATE_MODE -eq 2 || $UPDATE_MODE -eq 3 ]]; then
      local b64; b64=$(echo "$JOBS_JSON" | jq -r --argjson i "$idx" \
        '.[$i] | if .httpTarget then (.httpTarget.body // "") elif .pubsubTarget then (.pubsubTarget.data // "") else "" end')
      local curr_body; curr_body=$(decode_body "$b64")
      write_info "$(t update_body_current): $curr_body"
      read_body_input "$(t update_body_label)" "$curr_body"; body="$REPLY_BODY"
    fi

    if [[ -n "$cron" || -n "$body" ]]; then
      BATCH_NAMES+=("$name"); BATCH_CRONS+=("$cron")
      BATCH_BODYS+=("$body"); BATCH_IDXS+=("$idx")
    fi
    (( pos++ ))
  done
}

collect_batch_single() {
  local -a sel_idxs=("$@")
  BATCH_NAMES=(); BATCH_CRONS=(); BATCH_BODYS=(); BATCH_IDXS=()
  local single_cron="" single_body=""

  write_header "$(t update_same_for_all) (${#sel_idxs[@]})"
  if [[ $UPDATE_MODE -eq 1 || $UPDATE_MODE -eq 3 ]]; then
    read_cron_input "$(t update_cron_unique)"; single_cron="$REPLY_CRON"
  fi
  if [[ $UPDATE_MODE -eq 2 || $UPDATE_MODE -eq 3 ]]; then
    local ref_idx="${sel_idxs[0]}"
    local b64; b64=$(echo "$JOBS_JSON" | jq -r --argjson i "$ref_idx" \
      '.[$i] | if .httpTarget then (.httpTarget.body // "") elif .pubsubTarget then (.pubsubTarget.data // "") else "" end')
    local ref_body; ref_body=$(decode_body "$b64")
    read_body_input "$(t update_body_unique)" "$ref_body"; single_body="$REPLY_BODY"
  fi

  [[ -z "$single_cron" && -z "$single_body" ]] && { write_warn "$(t nothing_to_apply)"; return; }

  for idx in "${sel_idxs[@]}"; do
    BATCH_NAMES+=("${JOBS_NAMES[$idx]}"); BATCH_CRONS+=("$single_cron")
    BATCH_BODYS+=("$single_body"); BATCH_IDXS+=("$idx")
  done
}

run_update() {
  while true; do
    load_jobs || return
    show_job_table

    printf "  ${WH}[#]${NC}  %s\n" "$(t update_opt_job)"
    printf "  ${WH}[L]${NC}  %s\n" "$(t update_opt_batch)"
    printf "  ${DG}[V]${NC}  %s\n\n" "$(t update_opt_back)"
    read -r -p "  $(t choose): " INPUT
    INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null || echo "$INPUT")
    [[ "$INPUT" == "v" ]] && break

    # Batch / Lote
    if [[ "$INPUT" == "l" ]]; then
      write_header "$(t update_opt_batch)"
      write_info "$(t select_hint):"
      echo; read -r -p "  >> " SEL
      SEL=$(echo "$SEL" | xargs 2>/dev/null || echo "$SEL")
      [[ -z "$SEL" ]] && { write_warn "$(t none_selected)"; continue; }

      parse_selection "$SEL" "$JOBS_COUNT"
      [[ ${#PARSED_IDXS[@]} -eq 0 ]] && { write_warn "$(t no_valid_index)"; continue; }

      echo; printf "  ${DG}%s${NC}\n" "$(t selected_jobs)"
      for idx in "${PARSED_IDXS[@]}"; do
        printf "    ${DG}- %s  [%s]${NC}\n" "${JOBS_NAMES[$idx]}" "${JOBS_SCHEDULES[$idx]}"
      done

      write_header "$(t update_what)"
      printf "  [1] %s\n  [2] %s\n  [3] %s\n  [0] %s\n\n" \
        "$(t update_opt_cron)" "$(t update_opt_body)" "$(t update_opt_both)" "$(t update_opt_cancel)"
      while true; do read -r -p "  $(t choose): " UPDATE_MODE; [[ "$UPDATE_MODE" =~ ^[0-3]$ ]] && break; done
      [[ "$UPDATE_MODE" == "0" ]] && continue
      UPDATE_MODE=$(( UPDATE_MODE ))

      write_header "$(t update_how)"
      printf "  [1] %s\n  [2] %s\n  [0] %s\n\n" \
        "$(t update_same_for_all)" "$(t update_diff_per_job)" "$(t update_opt_cancel)"
      while true; do read -r -p "  $(t choose): " VALUE_MODE; [[ "$VALUE_MODE" =~ ^[0-2]$ ]] && break; done
      [[ "$VALUE_MODE" == "0" ]] && continue

      if [[ "$VALUE_MODE" == "1" ]]; then
        collect_batch_single "${PARSED_IDXS[@]}"
      else
        write_header "$(t update_diff_per_job)"
        collect_batch_individual "${PARSED_IDXS[@]}"
      fi

      [[ ${#BATCH_NAMES[@]} -eq 0 ]] && { write_warn "$(t nothing_to_apply)"; continue; }

      write_header "$(t update_batch_title) - ${#BATCH_NAMES[@]}"
      for (( ii=0; ii<${#BATCH_NAMES[@]}; ii++ )); do
        printf "    ${WH}%s${NC}\n" "${BATCH_NAMES[$ii]}"
        [[ -n "${BATCH_CRONS[$ii]}" ]] && write_info "  cron: '${JOBS_SCHEDULES[${BATCH_IDXS[$ii]}]}' -> '${BATCH_CRONS[$ii]}'"
        [[ -n "${BATCH_BODYS[$ii]}" ]] && write_info "  body: $(t copy_summary_updated)"
      done
      echo

      if confirm "$(t update_batch_confirm)"; then
        local mode_label; [[ "$VALUE_MODE" == "1" ]] && mode_label="single" || mode_label="individual"
        write_header "$(t update_applying)"
        write_log "$(t update_batch_start) | ${#BATCH_NAMES[@]} jobs | mode=$mode_label"
        for (( ii=0; ii<${#BATCH_NAMES[@]}; ii++ )); do
          apply_update "${BATCH_NAMES[$ii]}" "${BATCH_CRONS[$ii]}" "${BATCH_BODYS[$ii]}" "${BATCH_IDXS[$ii]}"
        done
        write_log "$(t update_batch_done)"
      else
        write_warn "$(t cancelled)"
      fi
      continue
    fi

    # Individual
    if ! [[ "$INPUT" =~ ^[0-9]+$ ]] || [[ "$INPUT" -lt 1 ]] || [[ "$INPUT" -gt "$JOBS_COUNT" ]]; then
      write_warn "$(t invalid_option)"; continue
    fi

    local IDX=$(( INPUT - 1 ))
    local JNAME="${JOBS_NAMES[$IDX]}"
    local JTYPE; JTYPE=$(echo "$JOBS_JSON" | jq -r --argjson i "$IDX" \
      '.[$i] | if .httpTarget then "http" elif .pubsubTarget then "pubsub" else "?" end')
    local JBODY="" b64=""

    write_header "$(t col_name): $JNAME"
    write_info "$(t detail_cron): ${JOBS_SCHEDULES[$IDX]}"
    write_info "$(t detail_status): ${JOBS_STATES[$IDX]}"
    if [[ "$JTYPE" == "http" ]]; then
      write_info "$(t detail_url): $(echo "$JOBS_JSON" | jq -r --argjson i "$IDX" '.[$i].httpTarget.uri')"
      b64=$(echo "$JOBS_JSON" | jq -r --argjson i "$IDX" '.[$i].httpTarget.body // ""')
      JBODY=$(decode_body "$b64"); write_info "Body: $JBODY"
    elif [[ "$JTYPE" == "pubsub" ]]; then
      b64=$(echo "$JOBS_JSON" | jq -r --argjson i "$IDX" '.[$i].pubsubTarget.data // ""')
      JBODY=$(decode_body "$b64"); write_info "Data: $JBODY"
    fi

    echo
    printf "  ${WH}[1]${NC} %s  ${WH}[2]${NC} %s  ${WH}[3]${NC} %s  ${DG}[0]${NC} %s\n\n" \
      "$(t update_opt_cron)" "$(t update_opt_body)" "$(t update_opt_both)" "$(t update_opt_cancel)"
    while true; do read -r -p "  $(t choose): " MODO; [[ "$MODO" =~ ^[0-3]$ ]] && break; done
    [[ "$MODO" == "0" ]] && continue

    local ICRON="" IBODY=""
    if [[ "$MODO" -eq 1 || "$MODO" -eq 3 ]]; then
      write_info "$(t update_cron_current): ${JOBS_SCHEDULES[$IDX]}"
      read_cron_input "$(t update_cron_label)"; ICRON="$REPLY_CRON"
    fi
    if [[ "$MODO" -eq 2 || "$MODO" -eq 3 ]]; then
      write_info "$(t update_body_current): $JBODY"
      read_body_input "$(t update_body_label)" "$JBODY"; IBODY="$REPLY_BODY"
    fi
    [[ -z "$ICRON" && -z "$IBODY" ]] && { write_warn "$(t update_no_info)"; continue; }

    write_header "$(t update_confirm)"
    write_info "$(t col_name): $JNAME"
    [[ -n "$ICRON" ]] && write_info "cron: '${JOBS_SCHEDULES[$IDX]}' -> '$ICRON'"
    [[ -n "$IBODY" ]] && write_info "body: $(t copy_summary_updated)"
    echo

    if confirm "$(t update_confirm)"; then
      apply_update "$JNAME" "$ICRON" "$IBODY" "$IDX"
    else
      write_warn "$(t cancelled)"
    fi
  done
}

# ================================================================
# COPY / COPIA
# ================================================================
run_copy() {
  while true; do
    load_jobs || return
    show_job_table

    printf "  ${WH}[#]${NC}  %s\n" "$(t copy_opt_job)"
    printf "  ${DG}[V]${NC}  %s\n\n" "$(t copy_opt_back)"
    read -r -p "  $(t choose): " INPUT
    INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null || echo "$INPUT")
    [[ "$INPUT" == "v" ]] && break

    if ! [[ "$INPUT" =~ ^[0-9]+$ ]] || [[ "$INPUT" -lt 1 ]] || [[ "$INPUT" -gt "$JOBS_COUNT" ]]; then
      write_warn "$(t invalid_option)"; continue
    fi

    local src_idx=$(( INPUT - 1 ))
    local src_name="${JOBS_NAMES[$src_idx]}"
    local src_json; src_json=$(echo "$JOBS_JSON" | jq --argjson i "$src_idx" '.[$i]')
    local src_tipo; src_tipo=$(echo "$src_json" | jq -r \
      'if .httpTarget then "http" elif .pubsubTarget then "pubsub" else "?" end')
    [[ "$src_tipo" == "?" ]] && { write_err "$(t copy_unsupported)"; continue; }

    local src_cron="${JOBS_SCHEDULES[$src_idx]}"
    local src_uri="" src_body="" b64=""

    if [[ "$src_tipo" == "http" ]]; then
      src_uri=$(echo "$src_json" | jq -r '.httpTarget.uri // ""')
      b64=$(echo "$src_json" | jq -r '.httpTarget.body // ""')
    else
      b64=$(echo "$src_json" | jq -r '.pubsubTarget.data // ""')
    fi
    src_body=$(decode_body "$b64")

    # Build template JSON / Monta JSON template
    local body_json
    if [[ -n "$src_body" ]] && echo "$src_body" | jq . &>/dev/null; then
      body_json=$(echo "$src_body" | jq .)
    elif [[ -n "$src_body" ]]; then
      body_json="\"$src_body\""
    else
      body_json="{}"
    fi

    local template_json
    if [[ "$src_tipo" == "http" ]]; then
      template_json=$(jq -n \
        --arg name "$src_name" --arg cron "$src_cron" \
        --arg uri  "$src_uri"  --argjson body "$body_json" \
        '{"name":$name,"cron":$cron,"uri":$uri,"body":$body}')
    else
      template_json=$(jq -n \
        --arg name "$src_name" --arg cron "$src_cron" \
        --argjson body "$body_json" \
        '{"name":$name,"cron":$cron,"body":$body}')
    fi

    write_header "$(t copy_title): $src_name"

    # Inner loop: create multiple jobs from same template
    # Loop interno: cria varios jobs a partir do mesmo template
    while true; do
      write_info "$(t copy_editor_open)"
      write_info "$(t copy_editor_inst)"
      write_info "$(t copy_editor_save)"
      echo
      open_editor "$template_json"
      local raw_edited="$EDITOR_RESULT"

      [[ -z "$(echo "$raw_edited" | tr -d '[:space:]')" ]] && \
        { write_warn "$(t copy_empty_editor)"; break; }

      if ! echo "$raw_edited" | jq . &>/dev/null; then
        write_err "$(t copy_invalid_json)"; continue
      fi

      local new_name new_cron new_uri new_body
      new_name=$(echo "$raw_edited" | jq -r '.name // ""')
      new_cron=$(echo "$raw_edited" | jq -r '.cron // ""')
      new_uri=$(echo "$raw_edited"  | jq -r '.uri  // ""')
      new_body=$(echo "$raw_edited" | jq -c '.body // empty' 2>/dev/null || echo "")

      if [[ -z "$new_name" ]]; then write_err "$(t copy_name_required)"; continue; fi

      if [[ "$new_name" == "$src_name" ]]; then
        write_warn "$(t copy_name_same_warn)"
        write_warn "$(t copy_name_same_warn2)"
        if ! confirm "$(t copy_name_same_cont)"; then continue; fi
      fi

      local schedule="${new_cron:-$src_cron}"
      local timezone; timezone=$(echo "$src_json" | jq -r '.timeZone // "America/Sao_Paulo"')

      write_header "$(t copy_title) - $new_name"
      write_info "$(t copy_summary_name) : $new_name"
      write_info "$(t copy_summary_cron) : $schedule"
      [[ "$src_tipo" == "http" ]] && write_info "$(t copy_summary_uri)  : ${new_uri:-$src_uri}"
      [[ -n "$new_body" ]]        && write_info "$(t copy_summary_body) : $(t copy_summary_updated)"
      echo

      if ! confirm "$(t copy_confirm)"; then write_warn "$(t cancelled)"; continue; fi

      write_header "$(t copy_creating)"
      local result rc=0

      if [[ "$src_tipo" == "http" ]]; then
        local uri_final="${new_uri:-$src_uri}"
        local method; method=$(echo "$src_json" | jq -r '.httpTarget.httpMethod // "POST"')
        local -a flags=(scheduler jobs create http "$new_name" \
          --project="$PROJECT" --location="$LOCATION" \
          --schedule="$schedule" --time-zone="$timezone" \
          --uri="$uri_final" --http-method="$method")

        local sa_oidc; sa_oidc=$(echo "$src_json" | jq -r '.httpTarget.oidcToken.serviceAccountEmail // ""')
        local sa_oauth; sa_oauth=$(echo "$src_json" | jq -r '.httpTarget.oauthToken.serviceAccountEmail // ""')
        [[ -n "$sa_oidc" ]]  && flags+=(--oidc-service-account-email="$sa_oidc")
        [[ -n "$sa_oauth" ]] && flags+=(--oauth-service-account-email="$sa_oauth")

        if [[ -n "$new_body" ]]; then
          flags+=(--message-body-from-file=-)
          result=$(echo "$new_body" | gcloud "${flags[@]}" 2>&1) && rc=0 || rc=$?
        else
          result=$(gcloud "${flags[@]}" 2>&1) && rc=0 || rc=$?
        fi
      else
        local topic; topic=$(echo "$src_json" | jq -r '.pubsubTarget.topicName // ""')
        local -a flags=(scheduler jobs create pubsub "$new_name" \
          --project="$PROJECT" --location="$LOCATION" \
          --schedule="$schedule" --time-zone="$timezone" --topic="$topic")
        [[ -n "$new_body" ]] && flags+=(--message-body="$new_body")
        result=$(gcloud "${flags[@]}" 2>&1) && rc=0 || rc=$?
      fi

      if [[ $rc -eq 0 ]]; then
        write_ok "'$new_name' $(t copy_ok)"
        write_log "COPY OK | source=$src_name | new=$new_name | cron=$schedule" "OK"
      else
        write_err "$(t copy_fail_title) $result"
        write_log "COPY FAIL | source=$src_name | new=$new_name | error=$result" "ERROR"
      fi

      echo
      if ! confirm "$(t copy_more) '$src_name' $(t copy_more2)"; then
        load_jobs; break
      fi
    done
  done
}

# ================================================================
# TOGGLE (ENABLE/DISABLE) / HABILITAR/DESABILITAR
# ================================================================
run_toggle() {
  while true; do
    load_jobs || return

    # Colored status table / Tabela com estado colorido
    echo
    local max_len=4
    for n in "${JOBS_NAMES[@]}"; do [[ ${#n} -gt $max_len ]] && max_len=${#n}; done
    printf "  ${DG}%-3s  %-${max_len}s  %-17s  %s${NC}\n" \
      "$(t col_num)" "$(t col_name)" "$(t col_cron)" "$(t col_status)"
    printf "  ${DG}%s${NC}\n" "$(printf '%*s' $((max_len + 44)) '' | tr ' ' '-')"
    local i
    for i in "${!JOBS_NAMES[@]}"; do
      local cor; [[ "${JOBS_STATES[$i]}" == "ENABLED" ]] && cor="$GR" || cor="$RD"
      printf "  ${cor}%-3s  %-${max_len}s  %-17s  %s${NC}\n" \
        $(( i + 1 )) "${JOBS_NAMES[$i]}" "${JOBS_SCHEDULES[$i]}" "${JOBS_STATES[$i]}"
    done
    echo

    printf "  ${WH}[#]${NC}  %s\n" "$(t toggle_opt_job)"
    printf "  ${WH}[L]${NC}  %s\n" "$(t toggle_opt_batch)"
    printf "  ${DG}[V]${NC}  %s\n\n" "$(t toggle_opt_back)"
    read -r -p "  $(t choose): " INPUT
    INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null || echo "$INPUT")
    [[ "$INPUT" == "v" ]] && break

    if [[ "$INPUT" == "l" ]]; then
      write_header "$(t toggle_batch_title)"
      write_info "$(t select_hint):"
      echo; read -r -p "  >> " SEL
      SEL=$(echo "$SEL" | xargs 2>/dev/null || echo "$SEL")
      [[ -z "$SEL" ]] && { write_warn "$(t none_selected)"; continue; }

      parse_selection "$SEL" "$JOBS_COUNT"
      [[ ${#PARSED_IDXS[@]} -eq 0 ]] && { write_warn "$(t no_valid_index)"; continue; }

      echo; printf "  ${DG}%s${NC}\n" "$(t selected_jobs)"
      for idx in "${PARSED_IDXS[@]}"; do
        local cor; [[ "${JOBS_STATES[$idx]}" == "ENABLED" ]] && cor="$GR" || cor="$RD"
        printf "    ${cor}- %-45s [%s]${NC}\n" "${JOBS_NAMES[$idx]}" "${JOBS_STATES[$idx]}"
      done

      echo
      printf "  [1] %s\n  [2] %s\n  [3] %s\n  [0] %s\n\n" \
        "$(t toggle_enable_all)" "$(t toggle_disable_all)" "$(t toggle_invert)" "$(t toggle_cancel)"
      while true; do read -r -p "  $(t choose): " TACTION; [[ "$TACTION" =~ ^[0-3]$ ]] && break; done
      [[ "$TACTION" == "0" ]] && continue

      echo
      if ! confirm "$(t toggle_confirm_batch) ${#PARSED_IDXS[@]} $(t toggle_confirm_batch2)"; then
        write_warn "$(t cancelled)"; continue
      fi

      write_header "$(t toggle_applying)"
      for idx in "${PARSED_IDXS[@]}"; do
        local name="${JOBS_NAMES[$idx]}" curr="${JOBS_STATES[$idx]}" cmd
        case "$TACTION" in
          1) cmd="resume"  ;;
          2) cmd="pause"   ;;
          3) [[ "$curr" == "ENABLED" ]] && cmd="pause" || cmd="resume" ;;
        esac

        if [[ "$cmd" == "resume" && "$curr" == "ENABLED" ]] || \
           [[ "$cmd" == "pause"  && "$curr" == "PAUSED"  ]]; then
          write_warn "[$name] $(t toggle_already) $curr $(t toggle_already2)"; continue
        fi

        local result rc=0
        result=$(gcloud scheduler jobs "$cmd" "$name" \
          --project="$PROJECT" --location="$LOCATION" 2>&1) && rc=0 || rc=$?

        if [[ $rc -eq 0 ]]; then
          local next; [[ "$cmd" == "resume" ]] && next="ENABLED" || next="PAUSED"
          write_ok "[$name] $curr -> $next"
          write_log "TOGGLE OK | job=$name | $curr -> $next" "OK"
        else
          write_err "[$name] $(t toggle_fail): $result"
          write_log "TOGGLE FAIL | job=$name | error=$result" "ERROR"
        fi
      done
      continue
    fi

    # Individual
    if ! [[ "$INPUT" =~ ^[0-9]+$ ]] || [[ "$INPUT" -lt 1 ]] || [[ "$INPUT" -gt "$JOBS_COUNT" ]]; then
      write_warn "$(t invalid_option)"; continue
    fi

    local idx=$(( INPUT - 1 ))
    local name="${JOBS_NAMES[$idx]}" curr="${JOBS_STATES[$idx]}"
    local cmd dest cor_dest
    [[ "$curr" == "ENABLED" ]] && cmd="pause" || cmd="resume"
    [[ "$cmd" == "resume" ]] && dest="ENABLED" || dest="PAUSED"
    [[ "$cmd" == "resume" ]] && cor_dest="$GR" || cor_dest="$RD"

    echo
    printf "  ${WH}%s${NC}: %s\n" "$(t col_name)" "$name"
    printf "  %s: %s  ->  ${cor_dest}%s${NC}\n" "$(t col_status)" "$curr" "$dest"
    echo

    if confirm "$(t toggle_confirm_single)"; then
      local result rc=0
      result=$(gcloud scheduler jobs "$cmd" "$name" \
        --project="$PROJECT" --location="$LOCATION" 2>&1) && rc=0 || rc=$?
      if [[ $rc -eq 0 ]]; then
        write_ok "[$name] $curr -> $dest"
        write_log "TOGGLE OK | job=$name | $curr -> $dest" "OK"
      else
        write_err "$(t toggle_fail): $result"
        write_log "TOGGLE FAIL | job=$name | error=$result" "ERROR"
      fi
    else
      write_warn "$(t cancelled)"
    fi
  done
}

# ================================================================
# RUN / EXECUTAR
# ================================================================
run_execute() {
  while true; do
    load_jobs || return
    show_job_table

    printf "  ${WH}[#]${NC}  %s\n" "$(t run_opt_job)"
    printf "  ${WH}[L]${NC}  %s\n" "$(t run_opt_batch)"
    printf "  ${DG}[V]${NC}  %s\n\n" "$(t run_opt_back)"
    read -r -p "  $(t choose): " INPUT
    INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null || echo "$INPUT")
    [[ "$INPUT" == "v" ]] && break

    if [[ "$INPUT" == "l" ]]; then
      write_header "$(t run_batch_title)"
      write_info "$(t select_hint):"
      echo; read -r -p "  >> " SEL
      SEL=$(echo "$SEL" | xargs 2>/dev/null || echo "$SEL")
      [[ -z "$SEL" ]] && { write_warn "$(t none_selected)"; continue; }

      parse_selection "$SEL" "$JOBS_COUNT"
      [[ ${#PARSED_IDXS[@]} -eq 0 ]] && { write_warn "$(t no_valid_index)"; continue; }

      echo; printf "  ${DG}%s${NC}\n" "$(t selected_jobs)"
      for idx in "${PARSED_IDXS[@]}"; do
        printf "    ${DG}- %s  [%s]${NC}\n" "${JOBS_NAMES[$idx]}" "${JOBS_SCHEDULES[$idx]}"
      done
      echo

      if confirm "$(t run_confirm_batch) ${#PARSED_IDXS[@]} $(t run_confirm_batch2)"; then
        write_header "$(t run_running)"
        for idx in "${PARSED_IDXS[@]}"; do
          local name="${JOBS_NAMES[$idx]}"
          local result rc=0
          result=$(gcloud scheduler jobs run "$name" \
            --project="$PROJECT" --location="$LOCATION" 2>&1) && rc=0 || rc=$?
          if [[ $rc -eq 0 ]]; then
            write_ok "[$name] $(t run_ok)"
            write_log "RUN OK | job=$name" "OK"
          else
            write_err "[$name] $(t run_fail): $result"
            write_log "RUN FAIL | job=$name | error=$result" "ERROR"
          fi
        done
      else
        write_warn "$(t cancelled)"
      fi
      continue
    fi

    if ! [[ "$INPUT" =~ ^[0-9]+$ ]] || [[ "$INPUT" -lt 1 ]] || [[ "$INPUT" -gt "$JOBS_COUNT" ]]; then
      write_warn "$(t invalid_option)"; continue
    fi

    local idx=$(( INPUT - 1 ))
    local name="${JOBS_NAMES[$idx]}"
    echo
    printf "  ${WH}%s${NC}: %s\n" "$(t col_name)" "$name"
    printf "  cron: ${DG}%s${NC}\n\n" "${JOBS_SCHEDULES[$idx]}"

    if confirm "$(t run_confirm_single) '$name'?"; then
      local result rc=0
      result=$(gcloud scheduler jobs run "$name" \
        --project="$PROJECT" --location="$LOCATION" 2>&1) && rc=0 || rc=$?
      if [[ $rc -eq 0 ]]; then
        write_ok "[$name] $(t run_ok_single)"
        write_log "RUN OK | job=$name" "OK"
      else
        write_err "$(t run_fail): $result"
        write_log "RUN FAIL | job=$name | error=$result" "ERROR"
      fi
    else
      write_warn "$(t cancelled)"
    fi
  done
}

# ================================================================
# ENTRY POINT / PONTO DE ENTRADA
# ================================================================
check_deps
load_config

write_log "Session started | project=$PROJECT | location=$LOCATION | lang=$LANG_CODE"

# ================================================================
# MAIN MENU / MENU PRINCIPAL
# ================================================================
while true; do
  echo
  printf "  ${CY}================================================${NC}\n"
  printf "  ${CY} %s${NC}\n" "$(t menu_title)"
  printf "  ${CY}================================================${NC}\n"
  printf "  ${DG}%s: %s${NC}\n" "$(t menu_project)"  "$PROJECT"
  printf "  ${DG}%s: %s${NC}\n" "$(t menu_location)" "$LOCATION"
  printf "  ${DG}%s: %s${NC}\n\n" "$(t menu_log)"    "$LOG_FILE"
  printf "  ${WH}[1]${NC} %s\n" "$(t menu_opt_consult)"
  printf "  ${WH}[2]${NC} %s\n" "$(t menu_opt_update)"
  printf "  ${WH}[3]${NC} %s\n" "$(t menu_opt_copy)"
  printf "  ${WH}[4]${NC} %s\n" "$(t menu_opt_toggle)"
  printf "  ${WH}[5]${NC} %s\n" "$(t menu_opt_run)"
  printf "  ${DG}[Q]${NC} %s\n\n" "$(t menu_opt_quit)"
  read -r -p "  $(t choose): " OPTION
  OPTION=$(echo "$OPTION" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null || echo "$OPTION")

  if [[ "$OPTION" == "q" ]]; then
    write_log "Session ended by user."
    write_warn "$(t menu_opt_quit)"; break
  fi

  case "$OPTION" in
    1) run_consult  ;;
    2) run_update   ;;
    3) run_copy     ;;
    4) run_toggle   ;;
    5) run_execute  ;;
    *) write_warn "$(t menu_invalid)" ;;
  esac
done
