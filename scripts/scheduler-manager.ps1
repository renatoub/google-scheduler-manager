# ================================================================
# scheduler-manager.ps1  (PowerShell 5.1+)
# GCP Scheduler Manager - Interactive CLI for Google Cloud Scheduler
# Gerenciador GCP - CLI interativo para o Google Cloud Scheduler
#
# Language is loaded from config file at startup.
# O idioma e carregado do arquivo de configuracao na inicializacao.
# ================================================================

# ----------------------------------------------------------------
# Default config path / Caminho padrao do arquivo de configuracao
# ----------------------------------------------------------------
$CONFIG_FILE = [System.IO.Path]::Combine($PSScriptRoot, "scheduler-manager.cfg")

# ================================================================
# LANGUAGE STRINGS / STRINGS DE IDIOMA
# ================================================================
# All UI text is stored here. Add new keys to both EN and PT sections.
# Todo texto da UI fica aqui. Adicione novas chaves em EN e PT.

$LANG_EN = @{
    # Menu labels / Rotulos do menu
    menu_title           = "Google Cloud Scheduler - Manager"
    menu_project         = "Project"
    menu_location        = "Location"
    menu_log             = "Log"
    menu_opt_consult     = "Consult jobs"
    menu_opt_update      = "Update jobs"
    menu_opt_copy        = "Copy job"
    menu_opt_toggle      = "Enable / Disable"
    menu_opt_run         = "Run jobs"
    menu_opt_quit        = "Quit"
    menu_invalid         = "Invalid option."

    # General / Geral
    select_hint          = "Numbers, ranges or all/todos (e.g. 1,3,23-27,31)"
    loading_jobs         = "Loading jobs..."
    no_jobs_found        = "No jobs found."
    project_not_found    = "Project not found. Use -Project or: gcloud config set project PROJECT"
    confirm_yn           = "[y/N]"
    confirm_yes          = "y"
    cancelled            = "Cancelled."
    back_to_list         = "[Enter] back to list"
    invalid_option       = "Invalid option."
    none_selected        = "No jobs selected."
    no_valid_index       = "No valid index."
    nothing_to_apply     = "Nothing to apply."
    selected_jobs        = "Selected jobs:"

    # Table headers / Cabecalhos da tabela
    col_num              = "#"
    col_name             = "Name"
    col_cron             = "Cron"
    col_status           = "Status"

    # Job detail / Detalhe do job
    detail_name          = "Name"
    detail_cron          = "Cron"
    detail_timezone      = "TimeZone"
    detail_status        = "Status"
    detail_type          = "Type"
    detail_url           = "URL"
    detail_method        = "Method"
    detail_topic         = "Topic"
    detail_body          = "Body (decoded)"
    detail_data          = "Data (decoded)"
    detail_last_exec     = "Last exec"
    detail_status_code   = "Status code"
    detail_status_msg    = "Status msg"

    # Consult menu / Menu de consulta
    consult_opt_detail   = "view job detail"
    consult_opt_export   = "export all to JSON"
    consult_opt_reload   = "reload list"
    consult_opt_back     = "back to main menu"
    export_title         = "Export jobs"
    export_folder_prompt = "Destination folder (Enter for"
    export_folder_warn   = "Folder not found, using default."
    export_ok            = "Exported"
    export_jobs_label    = "jobs"

    # Update menu / Menu de atualizacao
    update_opt_job       = "select a job"
    update_opt_batch     = "batch mode (multiple jobs)"
    update_opt_back      = "back to main menu"
    update_what          = "What to update?"
    update_opt_cron      = "Cron"
    update_opt_body      = "Body"
    update_opt_both      = "Cron + Body"
    update_opt_cancel    = "Cancel"
    update_how           = "How to define values?"
    update_same_for_all  = "Same value for all jobs"
    update_diff_per_job  = "Different value per job"
    update_cron_empty    = "Empty cron - ignored."
    update_body_empty    = "Empty body - ignored."
    update_body_unchanged= "Body was not changed - ignored."
    update_body_valid    = "Valid JSON - compacted for sending."
    update_body_invalid  = "Invalid JSON. Try again?"
    update_body_no_valid = "Sending body without JSON validation."
    update_body_preview  = "Preview"
    update_cron_current  = "Current cron"
    update_cron_label    = "New cron (e.g. '0 6 * * *')"
    update_body_current  = "Current body"
    update_body_label    = "New body (JSON)"
    update_cron_unique   = "Single cron for all jobs"
    update_body_unique   = "Single body for all jobs"
    update_notepad_open  = "Opening Notepad with current value."
    update_notepad_inst  = "Edit JSON, save (Ctrl+S) and close the window to continue."
    update_confirm       = "Confirm?"
    update_batch_confirm = "Confirm batch apply?"
    update_batch_title   = "Batch summary"
    update_applying      = "Applying..."
    update_ok            = "Updated."
    update_fail          = "Failed"
    update_batch_start   = "Batch started"
    update_batch_done    = "Batch completed"
    update_no_info       = "No value provided."

    # Copy menu / Menu de copia
    copy_opt_job         = "select source job"
    copy_opt_back        = "back to main menu"
    copy_title           = "Copy job"
    copy_editor_open     = "Opening Notepad with source job data."
    copy_editor_inst     = "Change name, cron, uri and/or body as needed."
    copy_editor_save     = "Save (Ctrl+S) and close the window to continue."
    copy_empty_editor    = "Editor closed with no content - cancelled."
    copy_invalid_json    = "Invalid JSON after editing - cancelled."
    copy_name_required   = "Field 'name' is required."
    copy_name_same_warn  = "New job name is the same as the original."
    copy_name_same_warn2 = "A job with this name already exists - gcloud will return an error."
    copy_name_same_cont  = "Continue anyway?"
    copy_summary_name    = "Name (new)"
    copy_summary_cron    = "Cron"
    copy_summary_uri     = "URI"
    copy_summary_body    = "Body"
    copy_summary_updated = "updated"
    copy_confirm         = "Confirm creation?"
    copy_creating        = "Creating job..."
    copy_ok              = "created successfully!"
    copy_fail_title      = "Failed to create job:"
    copy_more            = "Create another job using"
    copy_more2           = "as template?"
    copy_unsupported     = "Target type not supported for copy."

    # Toggle menu / Menu habilitar/desabilitar
    toggle_opt_job       = "toggle job state"
    toggle_opt_batch     = "toggle in batch"
    toggle_opt_back      = "back to main menu"
    toggle_batch_title   = "Batch - select jobs"
    toggle_enable_all    = "Enable all"
    toggle_disable_all   = "Disable all"
    toggle_invert        = "Invert state"
    toggle_cancel        = "Cancel"
    toggle_confirm_batch = "Confirm for"
    toggle_confirm_batch2= "jobs?"
    toggle_applying      = "Applying..."
    toggle_already       = "Already"
    toggle_already2      = "- ignored."
    toggle_ok            = "updated."
    toggle_fail          = "Failed"
    toggle_confirm_single= "Confirm?"

    # Run menu / Menu de execucao
    run_opt_job          = "run a job"
    run_opt_batch        = "run in batch"
    run_opt_back         = "back to main menu"
    run_batch_title      = "Batch - select jobs to run"
    run_confirm_batch    = "Confirm execution of"
    run_confirm_batch2   = "jobs?"
    run_running          = "Running batch..."
    run_confirm_single   = "Confirm execution of job"
    run_ok               = "Execution triggered."
    run_ok_single        = "Execution triggered successfully."
    run_fail             = "Failed"

    # Config / Configuracao
    cfg_welcome          = "Welcome to GCP Scheduler Manager!"
    cfg_first_run        = "Config file not found. Let's set it up."
    cfg_lang_prompt      = "Choose language / Escolha o idioma:"
    cfg_lang_en          = "English"
    cfg_lang_pt          = "Portuguese BR"
    cfg_project_prompt   = "GCP Project name"
    cfg_project_default  = "Default"
    cfg_location_prompt  = "Location"
    cfg_location_default = "Default"
    cfg_log_prompt       = "Log file path"
    cfg_log_default      = "Default"
    cfg_saved            = "Config saved to"
    cfg_loaded           = "Config loaded from"
    cfg_invalid_lang     = "Invalid choice. Using English."
    choose               = "Choose"
}

$LANG_PT = @{
    # Menu labels / Rotulos do menu
    menu_title           = "Google Cloud Scheduler - Gerenciador"
    menu_project         = "Projeto"
    menu_location        = "Location"
    menu_log             = "Log"
    menu_opt_consult     = "Consultar jobs"
    menu_opt_update      = "Atualizar jobs"
    menu_opt_copy        = "Copiar job"
    menu_opt_toggle      = "Habilitar / Desabilitar"
    menu_opt_run         = "Executar jobs"
    menu_opt_quit        = "Sair"
    menu_invalid         = "Opcao invalida."

    # General / Geral
    select_hint          = "Numeros, intervalos ou all/todos (ex: 1,3,23-27,31)"
    loading_jobs         = "Carregando jobs..."
    no_jobs_found        = "Nenhum job encontrado."
    project_not_found    = "Projeto nao encontrado. Use -Project ou: gcloud config set project PROJETO"
    confirm_yn           = "[s/N]"
    confirm_yes          = "s"
    cancelled            = "Cancelado."
    back_to_list         = "[Enter] voltar a lista"
    invalid_option       = "Opcao invalida."
    none_selected        = "Nenhum job selecionado."
    no_valid_index       = "Nenhum indice valido."
    nothing_to_apply     = "Nada para aplicar."
    selected_jobs        = "Jobs selecionados:"

    # Table headers / Cabecalhos da tabela
    col_num              = "#"
    col_name             = "Nome"
    col_cron             = "Cron"
    col_status           = "Estado"

    # Job detail / Detalhe do job
    detail_name          = "Nome"
    detail_cron          = "Cron"
    detail_timezone      = "TimeZone"
    detail_status        = "Estado"
    detail_type          = "Tipo"
    detail_url           = "URL"
    detail_method        = "Metodo"
    detail_topic         = "Topico"
    detail_body          = "Body (decodificado)"
    detail_data          = "Data (decodificado)"
    detail_last_exec     = "Ultima exec"
    detail_status_code   = "Status code"
    detail_status_msg    = "Status msg"

    # Consult menu / Menu de consulta
    consult_opt_detail   = "ver detalhe do job"
    consult_opt_export   = "exportar todos para JSON"
    consult_opt_reload   = "recarregar lista"
    consult_opt_back     = "voltar ao menu principal"
    export_title         = "Exportar jobs"
    export_folder_prompt = "Pasta de destino (Enter para"
    export_folder_warn   = "Pasta nao encontrada, usando padrao."
    export_ok            = "Exportado"
    export_jobs_label    = "jobs"

    # Update menu / Menu de atualizacao
    update_opt_job       = "selecionar um job"
    update_opt_batch     = "modo lote (varios jobs)"
    update_opt_back      = "voltar ao menu principal"
    update_what          = "O que atualizar?"
    update_opt_cron      = "Cron"
    update_opt_body      = "Body"
    update_opt_both      = "Cron + Body"
    update_opt_cancel    = "Cancelar"
    update_how           = "Como definir os valores?"
    update_same_for_all  = "Mesmo valor para todos os jobs"
    update_diff_per_job  = "Valor diferente para cada job"
    update_cron_empty    = "Cron vazio - ignorado."
    update_body_empty    = "Body vazio - ignorado."
    update_body_unchanged= "Body nao foi alterado - ignorado."
    update_body_valid    = "JSON valido - compactado para envio."
    update_body_invalid  = "JSON invalido. Tentar novamente?"
    update_body_no_valid = "Enviando body sem validacao JSON."
    update_body_preview  = "Preview"
    update_cron_current  = "Cron atual"
    update_cron_label    = "Novo cron (ex: '0 6 * * *')"
    update_body_current  = "Body atual"
    update_body_label    = "Novo body (JSON)"
    update_cron_unique   = "Cron unico para todos os jobs"
    update_body_unique   = "Body unico para todos os jobs"
    update_notepad_open  = "Notepad abrindo com o valor atual."
    update_notepad_inst  = "Edite o JSON, salve (Ctrl+S) e feche a janela para continuar."
    update_confirm       = "Confirmar?"
    update_batch_confirm = "Confirmar aplicacao do lote?"
    update_batch_title   = "Resumo do lote"
    update_applying      = "Aplicando..."
    update_ok            = "Atualizado."
    update_fail          = "Falha"
    update_batch_start   = "LOTE iniciado"
    update_batch_done    = "LOTE concluido"
    update_no_info       = "Nenhum valor informado."

    # Copy menu / Menu de copia
    copy_opt_job         = "selecionar job de origem"
    copy_opt_back        = "voltar ao menu principal"
    copy_title           = "Copiar job"
    copy_editor_open     = "Notepad abrindo com os dados do job de origem."
    copy_editor_inst     = "Altere name, cron, uri e/ou body conforme necessario."
    copy_editor_save     = "Salve (Ctrl+S) e feche a janela para continuar."
    copy_empty_editor    = "Editor fechado sem conteudo - operacao cancelada."
    copy_invalid_json    = "JSON invalido apos edicao - operacao cancelada."
    copy_name_required   = "Campo 'name' e obrigatorio."
    copy_name_same_warn  = "O nome do novo job e igual ao original."
    copy_name_same_warn2 = "Um job com esse nome ja existe - o gcloud retornara erro."
    copy_name_same_cont  = "Deseja continuar mesmo assim?"
    copy_summary_name    = "Nome (novo)"
    copy_summary_cron    = "Cron"
    copy_summary_uri     = "URI"
    copy_summary_body    = "Body"
    copy_summary_updated = "atualizado"
    copy_confirm         = "Confirmar criacao?"
    copy_creating        = "Criando job..."
    copy_ok              = "criado com sucesso!"
    copy_fail_title      = "Falha ao criar job:"
    copy_more            = "Criar outro job usando"
    copy_more2           = "como template?"
    copy_unsupported     = "Tipo de target nao suportado para copia."

    # Toggle menu / Menu habilitar/desabilitar
    toggle_opt_job       = "alternar estado do job"
    toggle_opt_batch     = "alternar em lote"
    toggle_opt_back      = "voltar ao menu principal"
    toggle_batch_title   = "Lote - selecione os jobs"
    toggle_enable_all    = "Habilitar todos"
    toggle_disable_all   = "Desabilitar todos"
    toggle_invert        = "Inverter estado"
    toggle_cancel        = "Cancelar"
    toggle_confirm_batch = "Confirmar para"
    toggle_confirm_batch2= "jobs?"
    toggle_applying      = "Aplicando..."
    toggle_already       = "Ja esta"
    toggle_already2      = "- ignorado."
    toggle_ok            = "atualizado."
    toggle_fail          = "Falha"
    toggle_confirm_single= "Confirmar?"

    # Run menu / Menu de execucao
    run_opt_job          = "executar um job"
    run_opt_batch        = "executar em lote"
    run_opt_back         = "voltar ao menu principal"
    run_batch_title      = "Lote - selecione os jobs para executar"
    run_confirm_batch    = "Confirmar execucao de"
    run_confirm_batch2   = "jobs?"
    run_running          = "Executando lote..."
    run_confirm_single   = "Confirmar execucao do job"
    run_ok               = "Execucao disparada."
    run_ok_single        = "Execucao disparada com sucesso."
    run_fail             = "Falha"

    # Config / Configuracao
    cfg_welcome          = "Bem-vindo ao GCP Scheduler Manager!"
    cfg_first_run        = "Arquivo de configuracao nao encontrado. Vamos configura-lo."
    cfg_lang_prompt      = "Escolha o idioma / Choose language:"
    cfg_lang_en          = "Ingles (English)"
    cfg_lang_pt          = "Portugues BR"
    cfg_project_prompt   = "Nome do projeto GCP"
    cfg_project_default  = "Padrao"
    cfg_location_prompt  = "Location"
    cfg_location_default = "Padrao"
    cfg_log_prompt       = "Caminho do arquivo de log"
    cfg_log_default      = "Padrao"
    cfg_saved            = "Configuracao salva em"
    cfg_loaded           = "Configuracao carregada de"
    cfg_invalid_lang     = "Escolha invalida. Usando Portugues BR."
    choose               = "Escolha"
}

# ----------------------------------------------------------------
# Active language map / Mapa de idioma ativo
# ----------------------------------------------------------------
$L = $LANG_EN  # will be overridden after config load

# ----------------------------------------------------------------
# Translate shortcut / Atalho de traducao
# ----------------------------------------------------------------
function T([string]$key) { return $L[$key] }

# ================================================================
# CONFIG FILE / ARQUIVO DE CONFIGURACAO
# ================================================================

function Load-Config {
    # Load config from file or run first-time setup wizard
    # Carrega config do arquivo ou executa o assistente de primeira execucao

    # Default values / Valores padroes
    $defaults = @{
        language = "EN"
        project  = "eqtl-prj-dev-dlk-bronze"
        location = "southamerica-east1"
        log_file = [System.IO.Path]::Combine($PSScriptRoot, "scheduler_changes.log")
    }

    if (Test-Path $CONFIG_FILE) {
        # Parse the cfg file (KEY=VALUE format)
        # Faz parse do arquivo cfg (formato CHAVE=VALOR)
        $cfg = @{}
        Get-Content $CONFIG_FILE | ForEach-Object {
            if ($_ -match "^\s*([^#=]+?)\s*=\s*(.*)\s*$") {
                $cfg[$Matches[1].Trim()] = $Matches[2].Trim()
            }
        }

        $script:LANG_CODE = if ($cfg.language) { $cfg.language.ToUpper() } else { "EN" }
        $script:L         = if ($script:LANG_CODE -eq "PT") { $LANG_PT } else { $LANG_EN }
        $script:PROJECT   = if ($cfg.project)  { $cfg.project }  else { $defaults.project }
        $script:LOCATION  = if ($cfg.location) { $cfg.location } else { $defaults.location }
        $script:LOG_FILE  = if ($cfg.log_file) { $cfg.log_file } else { $defaults.log_file }
        Write-Info "$($L.cfg_loaded): $CONFIG_FILE"
    }
    else {
        # First run wizard / Assistente de primeira execucao
        Write-Host ""
        Write-Host "  ================================================" -ForegroundColor Cyan
        Write-Host "  $($LANG_EN.cfg_welcome)" -ForegroundColor Cyan
        Write-Host "  ================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  $($LANG_EN.cfg_first_run)" -ForegroundColor Yellow
        Write-Host ""

        # Language selection / Selecao de idioma
        Write-Host "  $($LANG_EN.cfg_lang_prompt)" -ForegroundColor White
        Write-Host "  [1] $($LANG_EN.cfg_lang_en)"
        Write-Host "  [2] $($LANG_EN.cfg_lang_pt)"
        Write-Host ""
        do { $langChoice = (Read-Host "  $($LANG_EN.choose)").Trim() } while ($langChoice -notmatch "^[12]$")

        if ($langChoice -eq "2") {
            $script:LANG_CODE = "PT"
            $script:L         = $LANG_PT
        } else {
            $script:LANG_CODE = "EN"
            $script:L         = $LANG_EN
        }

        Write-Host ""

        # Project / Projeto
        Write-Host "  $($L.cfg_project_prompt) ($($L.cfg_project_default): $($defaults.project)):" -ForegroundColor White
        $inputProject = (Read-Host "  >>").Trim()
        $script:PROJECT = if ($inputProject) { $inputProject } else { $defaults.project }

        # Location
        Write-Host "  $($L.cfg_location_prompt) ($($L.cfg_location_default): $($defaults.location)):" -ForegroundColor White
        $inputLocation = (Read-Host "  >>").Trim()
        $script:LOCATION = if ($inputLocation) { $inputLocation } else { $defaults.location }

        # Log file / Arquivo de log
        Write-Host "  $($L.cfg_log_prompt) ($($L.cfg_log_default): $($defaults.log_file)):" -ForegroundColor White
        $inputLog = (Read-Host "  >>").Trim()
        $script:LOG_FILE = if ($inputLog) { $inputLog } else { $defaults.log_file }

        # Save config / Salva configuracao
        $cfgContent = @"
# GCP Scheduler Manager - Config file
# Generated automatically / Gerado automaticamente
# $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

language = $($script:LANG_CODE)
project  = $($script:PROJECT)
location = $($script:LOCATION)
log_file = $($script:LOG_FILE)
"@
        Set-Content -Path $CONFIG_FILE -Value $cfgContent -Encoding UTF8
        Write-Host ""
        Write-OK "$($L.cfg_saved): $CONFIG_FILE"
        Write-Host ""
    }
}

# ================================================================
# OUTPUT HELPERS / AUXILIARES DE OUTPUT
# ================================================================
function Write-Header([string]$t) {
    Write-Host ""
    Write-Host "  $t" -ForegroundColor Cyan
    Write-Host ("  " + ("-" * $t.Length)) -ForegroundColor DarkGray
}
function Write-OK  ([string]$m) { Write-Host "  [OK] $m" -ForegroundColor Green  }
function Write-Warn([string]$m) { Write-Host "  [!]  $m" -ForegroundColor Yellow }
function Write-Err ([string]$m) { Write-Host "  [X]  $m" -ForegroundColor Red    }
function Write-Info([string]$m) { Write-Host "       $m" -ForegroundColor Gray   }

# ================================================================
# LOGGING / LOG
# ================================================================
function Write-Log([string]$msg, [string]$level = "INFO") {
    # Append timestamped log entry / Acrescenta entrada de log com timestamp
    $ts   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] [$level] $msg"
    Add-Content -Path $LOG_FILE -Value $line -Encoding UTF8
}

# ================================================================
# BASE64 ENCODE / DECODE
# ================================================================
function Decode-Body([string]$b64) {
    # Decode base64 string to UTF-8 text / Decodifica base64 para texto UTF-8
    if (-not $b64) { return "" }
    try {
        $bytes = [System.Convert]::FromBase64String($b64)
        return [System.Text.Encoding]::UTF8.GetString($bytes)
    } catch { return "[error decoding / erro ao decodificar]" }
}

# ================================================================
# JSON HELPERS - strip Unicode escapes (\u0027 -> ' etc)
# Remove escapes Unicode do ConvertTo-Json (\u0027 -> ' etc)
# ================================================================
function To-JsonClean([object]$obj) {
    $json = $obj | ConvertTo-Json -Depth 20 -Compress
    $json = [System.Text.RegularExpressions.Regex]::Replace($json,
        '\\u([0-9a-fA-F]{4})',
        {
            param($m)
            $code = [Convert]::ToInt32($m.Groups[1].Value, 16)
            if ($code -ge 32 -and $code -le 126 -and $code -ne 34) { [char]$code }
            else { $m.Value }
        })
    return $json
}

function To-JsonPretty([object]$obj) {
    # Indented JSON without Unicode escapes / JSON indentado sem escapes Unicode
    $json = $obj | ConvertTo-Json -Depth 20
    $json = [System.Text.RegularExpressions.Regex]::Replace($json,
        '\\u([0-9a-fA-F]{4})',
        {
            param($m)
            $code = [Convert]::ToInt32($m.Groups[1].Value, 16)
            if ($code -ge 32 -and $code -le 126 -and $code -ne 34) { [char]$code }
            else { $m.Value }
        })
    return $json
}

# ================================================================
# EDITOR HELPER / AUXILIAR DE EDITOR
# ================================================================
function Open-Editor([string]$content) {
    # Open Notepad with content and return edited text
    # Abre o Notepad com conteudo e retorna o texto editado
    $tmpFile = [System.IO.Path]::GetTempFileName()
    $tmpJson = [System.IO.Path]::ChangeExtension($tmpFile, ".json")
    Move-Item -Path $tmpFile -Destination $tmpJson -Force
    Set-Content -Path $tmpJson -Value $content -Encoding UTF8
    Start-Process -FilePath "notepad.exe" -ArgumentList $tmpJson -PassThru -Wait | Out-Null
    Start-Sleep -Milliseconds 300
    $result = Get-Content -Path $tmpJson -Raw -Encoding UTF8
    Remove-Item -Path $tmpJson -Force -ErrorAction SilentlyContinue
    return $result
}

# ================================================================
# LOAD JOBS FROM GCP / CARREGA JOBS DO GCP
# ================================================================
function Load-Jobs {
    Write-Host "  $($L.loading_jobs)" -ForegroundColor DarkGray
    $raw = gcloud scheduler jobs list `
        --project=$PROJECT `
        --location=$LOCATION `
        --format=json 2>&1
    if ($LASTEXITCODE -ne 0) { Write-Err "gcloud error: $raw"; exit 1 }
    $list = $raw | ConvertFrom-Json
    if (-not $list -or $list.Count -eq 0) { Write-Warn $L.no_jobs_found; exit 0 }
    return $list
}

# ================================================================
# JOB TABLE / TABELA DE JOBS
# ================================================================
function Show-JobTable([array]$list) {
    Write-Host ""
    $maxName = ($list | ForEach-Object {
        ($_.name -replace "^.*/jobs/", "").Length
    } | Measure-Object -Maximum).Maximum
    $maxName = [Math]::Max($maxName, 4)

    $header = "  {0,-3}  {1,-$maxName}  {2,-17}  {3}" -f $L.col_num, $L.col_name, $L.col_cron, $L.col_status
    Write-Host $header -ForegroundColor DarkGray
    Write-Host ("  " + ("-" * ($header.Length - 2))) -ForegroundColor DarkGray

    for ($i = 0; $i -lt $list.Count; $i++) {
        $j    = $list[$i]
        $name = $j.name -replace "^.*/jobs/", ""
        $cor  = if ($j.state -eq "ENABLED") { "White" } else { "DarkGray" }
        Write-Host ("  {0,-3}  {1,-$maxName}  {2,-17}  {3}" -f `
            ($i+1), $name, $j.schedule, $j.state) -ForegroundColor $cor
    }
    Write-Host ""
}

# ================================================================
# PARSE JOB SELECTION (comma list or "all"/"todos")
# Faz parse da selecao de jobs (lista de numeros ou "all"/"todos")
# ================================================================
function Parse-Selection([string]$sel, [int]$total) {
    # Supports: 1,3,23-27,31  or  all  or  todos
    # Suporta:  1,3,23-27,31  ou  all  ou  todos
    if ($sel -ieq "all" -or $sel -ieq "todos") { return 1..$total }

    $result = @()
    foreach ($part in ($sel -split ",")) {
        $part = $part.Trim()
        if ($part -match "^(\d+)-(\d+)$") {
            # Range / Intervalo
            $start = [int]$Matches[1]; $end = [int]$Matches[2]
            if ($start -le $end -and $start -ge 1 -and $end -le $total) {
                $result += $start..$end
            }
        } elseif ($part -match "^\d+$") {
            # Single number / Numero simples
            $n = [int]$part
            if ($n -ge 1 -and $n -le $total) { $result += $n }
        }
    }
    return $result | Select-Object -Unique | Sort-Object
}

# ================================================================
# CONSULT / CONSULTA
# ================================================================
function Show-JobDetail([object]$job) {
    $name = $job.name -replace "^.*/jobs/", ""
    Write-Header "$($L.col_name): $name"
    Write-Info "$($L.detail_name)     : $name"
    Write-Info "$($L.detail_cron)     : $($job.schedule)"
    Write-Info "$($L.detail_timezone) : $($job.timeZone)"
    Write-Info "$($L.detail_status)   : $($job.state)"

    if ($job.httpTarget) {
        Write-Info "$($L.detail_type)     : httpTarget"
        Write-Info "$($L.detail_url)      : $($job.httpTarget.uri)"
        Write-Info "$($L.detail_method)   : $($job.httpTarget.httpMethod)"
        $body = Decode-Body $job.httpTarget.body
        if ($body) {
            Write-Host ""; Write-Host "  --- $($L.detail_body) ---" -ForegroundColor DarkGray
            try   { Write-Host (To-JsonPretty ($body | ConvertFrom-Json)) -ForegroundColor Gray }
            catch { Write-Host $body -ForegroundColor Gray }
        }
    } elseif ($job.pubsubTarget) {
        Write-Info "$($L.detail_type)     : pubsubTarget"
        Write-Info "$($L.detail_topic)    : $($job.pubsubTarget.topicName)"
        $data = Decode-Body $job.pubsubTarget.data
        if ($data) {
            Write-Host ""; Write-Host "  --- $($L.detail_data) ---" -ForegroundColor DarkGray
            try   { Write-Host (To-JsonPretty ($data | ConvertFrom-Json)) -ForegroundColor Gray }
            catch { Write-Host $data -ForegroundColor Gray }
        }
    }
    if ($job.lastAttemptTime) { Write-Info "$($L.detail_last_exec) : $($job.lastAttemptTime)" }
    if ($job.status.code)     { Write-Info "$($L.detail_status_code): $($job.status.code)"    }
    if ($job.status.message)  { Write-Info "$($L.detail_status_msg) : $($job.status.message)" }
}

function Export-Jobs([array]$jobs) {
    Write-Header (T "export_title")
    $fixedName  = "scheduler_jobs_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
    $defaultDir = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")
    Write-Info "$(T 'export_folder_prompt') '$defaultDir'):"
    $folder = (Read-Host "  >>").Trim()
    if (-not $folder -or -not (Test-Path $folder)) {
        if ($folder) { Write-Warn (T "export_folder_warn") }
        $folder = $defaultDir
    }
    $outFile = [System.IO.Path]::Combine($folder, $fixedName)

    $result = $jobs | ForEach-Object {
        $name = $_.name -replace "^.*/jobs/", ""
        $body = ""; $url = ""; $type = ""
        if ($_.httpTarget)       { $type = "httpTarget";   $url = $_.httpTarget.uri; $body = Decode-Body $_.httpTarget.body }
        elseif ($_.pubsubTarget) { $type = "pubsubTarget"; $body = Decode-Body $_.pubsubTarget.data }
        [PSCustomObject]@{
            name        = $name
            schedule    = $_.schedule
            timeZone    = $_.timeZone
            state       = $_.state
            targetType  = $type
            url         = $url
            bodyDecoded = if ($body) { try { $body | ConvertFrom-Json } catch { $body } } else { $null }
        }
    }

    $jsonOut = $result | ConvertTo-Json -Depth 20
    $jsonOut = [System.Text.RegularExpressions.Regex]::Replace($jsonOut, '\\u([0-9a-fA-F]{4})',
        { param($m); $c = [Convert]::ToInt32($m.Groups[1].Value,16); if ($c -ge 32 -and $c -le 126 -and $c -ne 34) { [char]$c } else { $m.Value } })
    $jsonOut | Set-Content -Path $outFile -Encoding UTF8
    Write-OK "$(T 'export_ok'): $outFile ($($jobs.Count) $(T 'export_jobs_label'))"
    Write-Log "EXPORT | file=$outFile | jobs=$($jobs.Count)"
}

function Run-Consult([array]$jobs) {
    while ($true) {
        Show-JobTable $jobs
        Write-Host "  [#]  $(T 'consult_opt_detail')"  -ForegroundColor White
        Write-Host "  [E]  $(T 'consult_opt_export')"  -ForegroundColor White
        Write-Host "  [R]  $(T 'consult_opt_reload')"  -ForegroundColor White
        Write-Host "  [V]  $(T 'consult_opt_back')"    -ForegroundColor DarkGray
        Write-Host ""
        $input = (Read-Host "  $(T 'choose')").Trim()
        if ($input -ieq "v") { break }
        if ($input -ieq "r") { $jobs = Load-Jobs; continue }
        if ($input -ieq "e") { Export-Jobs $jobs; continue }
        if ($input -notmatch "^\d+$" -or [int]$input -lt 1 -or [int]$input -gt $jobs.Count) {
            Write-Warn (T "invalid_option"); continue
        }
        Show-JobDetail $jobs[[int]$input - 1]
        Write-Host ""; Write-Host "  $(T 'back_to_list')" -ForegroundColor DarkGray
        Read-Host | Out-Null
    }
}

# ================================================================
# UPDATE / ATUALIZACAO
# ================================================================
function Read-Cron([string]$label) {
    # Prompt user for cron expression / Solicita expressao cron ao usuario
    Write-Info "$label :"
    $v = (Read-Host "  >>").Trim()
    if (-not $v) { Write-Warn (T "update_cron_empty"); return $null }
    return $v
}

function Read-Body([string]$label, [string]$currentBody = "") {
    # Open editor pre-filled with current body / Abre editor pre-preenchido com body atual
    if ($currentBody -and $currentBody.Trim() -ne "") {
        try   { $content = To-JsonPretty ($currentBody | ConvertFrom-Json) }
        catch { $content = $currentBody }
    } else { $content = "{`n  `"`": `"`"`n}" }

    Write-Info "$(T 'update_notepad_open')"
    Write-Info "$(T 'update_notepad_inst')"
    Write-Host ""

    $rawBody = Open-Editor $content

    if (-not $rawBody -or $rawBody.Trim() -eq "") {
        Write-Warn (T "update_body_empty"); $global:REPLY_BODY = $null; return
    }
    try {
        $parsed    = $rawBody | ConvertFrom-Json
        $newClean  = To-JsonClean $parsed
        $currClean = if ($currentBody -and $currentBody.Trim() -ne "") {
            try { To-JsonClean ($currentBody | ConvertFrom-Json) } catch { "" }
        } else { "" }

        if ($newClean -eq $currClean) {
            Write-Warn (T "update_body_unchanged"); $global:REPLY_BODY = $null; return
        }
        $global:REPLY_BODY = $newClean
        Write-OK (T "update_body_valid")
        $preview = if ($global:REPLY_BODY.Length -gt 80) { $global:REPLY_BODY.Substring(0,80)+"..." } else { $global:REPLY_BODY }
        Write-Info "$(T 'update_body_preview'): $preview"
    }
    catch {
        Write-Warn "$(T 'update_body_invalid') $(T 'confirm_yn')"
        $retry = (Read-Host "  >>").Trim().ToLower()
        if ($retry -eq (T "confirm_yes")) { Read-Body $label $currentBody }
        else { $global:REPLY_BODY = $rawBody.Trim(); Write-Warn (T "update_body_no_valid") }
    }
}

function Make-Change([object]$job, [string]$cron, [string]$body) {
    $name     = $job.name -replace "^.*/jobs/", ""
    $currBody = if ($job.httpTarget) { Decode-Body $job.httpTarget.body }
                elseif ($job.pubsubTarget) { Decode-Body $job.pubsubTarget.data }
                else { "" }
    return @{ job = $job; name = $name; cron = $cron; body = $body; currBody = $currBody }
}

function Collect-BatchIndividual([array]$selectedJobs, [int]$mode) {
    $batch = @(); $total = $selectedJobs.Count
    for ($i = 0; $i -lt $total; $i++) {
        $job  = $selectedJobs[$i]; $name = $job.name -replace "^.*/jobs/", ""
        Write-Host ""; Write-Host ("  [$($i+1)/$total] $name") -ForegroundColor DarkCyan
        $cron = $null; $body = $null
        if ($mode -eq 1 -or $mode -eq 3) {
            Write-Info "$(T 'update_cron_current'): $($job.schedule)"
            $cron = Read-Cron "$(T 'update_cron_label')"
            if (-not $cron -and $mode -eq 1) { continue }
        }
        if ($mode -eq 2 -or $mode -eq 3) {
            $bp = if ($job.httpTarget) { Decode-Body $job.httpTarget.body }
                  elseif ($job.pubsubTarget) { Decode-Body $job.pubsubTarget.data } else { "" }
            Write-Info "$(T 'update_body_current'): $bp"
            Read-Body "$(T 'update_body_label')" $bp; $body = $global:REPLY_BODY
            if (-not $body -and $mode -eq 2) { continue }
        }
        if ($cron -or $body) { $batch += Make-Change $job $cron $body }
    }
    return $batch
}

function Collect-BatchSingle([array]$selectedJobs, [int]$mode) {
    $singleCron = $null; $singleBody = $null
    if ($mode -eq 1 -or $mode -eq 3) {
        Write-Host ""; $singleCron = Read-Cron "$(T 'update_cron_unique')"
        if (-not $singleCron -and $mode -eq 1) { return @() }
    }
    if ($mode -eq 2 -or $mode -eq 3) {
        Write-Host ""
        $refBody = if ($selectedJobs[0].httpTarget) { Decode-Body $selectedJobs[0].httpTarget.body }
                   elseif ($selectedJobs[0].pubsubTarget) { Decode-Body $selectedJobs[0].pubsubTarget.data }
                   else { "" }
        Read-Body "$(T 'update_body_unique')" $refBody; $singleBody = $global:REPLY_BODY
        if (-not $singleBody -and $mode -eq 2) { return @() }
    }
    return $selectedJobs | ForEach-Object { Make-Change $_ $singleCron $singleBody }
}

function Apply-Update([hashtable]$c) {
    $job  = $c.job; $name = $c.name
    $type = if ($job.httpTarget) { "http" } elseif ($job.pubsubTarget) { "pubsub" } else { $null }
    if (-not $type) { Write-Err "[$name] $(T 'copy_unsupported')"; return }

    $flags = @("scheduler","jobs","update",$type,$name,"--project=$PROJECT","--location=$LOCATION")
    if ($c.cron) { $flags += "--schedule=$($c.cron)" }
    if ($c.body) {
        if     ($type -eq "http")   { $flags += "--message-body-from-file=-" }
        elseif ($type -eq "pubsub") { $flags += "--message-body=$($c.body)"  }
    }

    $result = if ($c.body -and $type -eq "http") { $c.body | gcloud @flags 2>&1 }
              else { gcloud @flags 2>&1 }

    if ($LASTEXITCODE -eq 0) {
        Write-OK "[$name] $(T 'update_ok')"
        $logMsg = "UPDATE OK | job=$name"
        if ($c.cron) { $logMsg += " | cron: '$($job.schedule)' -> '$($c.cron)'" }
        if ($c.body) { $logMsg += " | body updated" }
        Write-Log $logMsg "OK"
    } else {
        Write-Err "[$name] $(T 'update_fail'): $result"
        Write-Log "UPDATE FAIL | job=$name | error=$result" "ERROR"
    }
}

function Run-Update([array]$jobs) {
    while ($true) {
        Show-JobTable $jobs
        Write-Host "  [#]  $(T 'update_opt_job')"   -ForegroundColor White
        Write-Host "  [L]  $(T 'update_opt_batch')" -ForegroundColor White
        Write-Host "  [V]  $(T 'update_opt_back')"  -ForegroundColor DarkGray
        Write-Host ""
        $input = (Read-Host "  $(T 'choose')").Trim()
        if ($input -ieq "v") { break }

        # Batch / Lote
        if ($input -ieq "l") {
            Write-Header (T "update_opt_batch")
            Write-Info "$(T 'select_hint'):"
            Write-Host ""
            $sel = (Read-Host "  >>").Trim()
            if (-not $sel) { Write-Warn (T "none_selected"); continue }
            $indices = Parse-Selection $sel $jobs.Count
            if (-not $indices) { Write-Warn (T "no_valid_index"); continue }
            $selectedJobs = $indices | ForEach-Object { $jobs[$_ - 1] }

            Write-Host ""; Write-Host "  $(T 'selected_jobs')" -ForegroundColor DarkGray
            $selectedJobs | ForEach-Object {
                Write-Host ("    - {0}  [{1}]" -f ($_.name -replace "^.*/jobs/",""), $_.schedule) -ForegroundColor Gray
            }

            Write-Header (T "update_what")
            Write-Host "  [1] $(T 'update_opt_cron')"; Write-Host "  [2] $(T 'update_opt_body')"
            Write-Host "  [3] $(T 'update_opt_both')"; Write-Host "  [0] $(T 'update_opt_cancel')"
            Write-Host ""
            do { $updateMode = (Read-Host "  $(T 'choose')").Trim() } while ($updateMode -notmatch "^[0-3]$")
            if ($updateMode -eq "0") { continue }
            $updateMode = [int]$updateMode

            Write-Header (T "update_how")
            Write-Host "  [1] $(T 'update_same_for_all')"; Write-Host "  [2] $(T 'update_diff_per_job')"
            Write-Host "  [0] $(T 'update_opt_cancel')"; Write-Host ""
            do { $valueMode = (Read-Host "  $(T 'choose')").Trim() } while ($valueMode -notmatch "^[0-2]$")
            if ($valueMode -eq "0") { continue }

            $batch = if ($valueMode -eq "1") {
                Write-Header "$(T 'update_same_for_all') ($($selectedJobs.Count))"
                Collect-BatchSingle $selectedJobs $updateMode
            } else {
                Write-Header "$(T 'update_diff_per_job') - $($selectedJobs.Count)"
                Collect-BatchIndividual $selectedJobs $updateMode
            }
            if (-not $batch -or $batch.Count -eq 0) { Write-Warn (T "nothing_to_apply"); continue }

            $totalBatch = $batch.Count
            Write-Header "$(T 'update_batch_title') - $totalBatch"
            foreach ($c in $batch) {
                Write-Host "    $($c.name)" -ForegroundColor White
                if ($c.cron) { Write-Info "      cron : '$($c.job.schedule)' -> '$($c.cron)'" }
                if ($c.body) { Write-Info "      body : $(T 'copy_summary_updated')" }
            }
            Write-Host ""
            $conf = (Read-Host "  $(T 'update_batch_confirm') $(T 'confirm_yn')").Trim().ToLower()
            if ($conf -ne (T "confirm_yes")) { Write-Warn (T "cancelled"); continue }

            Write-Header (T "update_applying")
            $modeLabel = if ($valueMode -eq "1") { "single" } else { "individual" }
            Write-Log "$(T 'update_batch_start') | $totalBatch jobs | mode=$modeLabel"
            foreach ($c in $batch) { Apply-Update $c }
            Write-Log (T "update_batch_done")
            $jobs = Load-Jobs; continue
        }

        # Individual
        if ($input -notmatch "^\d+$" -or [int]$input -lt 1 -or [int]$input -gt $jobs.Count) {
            Write-Warn (T "invalid_option"); continue
        }
        $job     = $jobs[[int]$input - 1]
        $jobName = $job.name -replace "^.*/jobs/", ""
        $currBody = if ($job.httpTarget) { Decode-Body $job.httpTarget.body }
                    elseif ($job.pubsubTarget) { Decode-Body $job.pubsubTarget.data } else { "" }

        Write-Header "$($L.col_name): $jobName"
        Write-Info "$(T 'detail_cron')     : $($job.schedule)"
        Write-Info "$(T 'detail_timezone') : $($job.timeZone)"
        Write-Info "$(T 'detail_status')   : $($job.state)"
        if ($job.httpTarget)       { Write-Info "$(T 'detail_url') : $($job.httpTarget.uri)"; Write-Info "Body : $currBody" }
        elseif ($job.pubsubTarget) { Write-Info "Data : $currBody" }

        Write-Host ""
        Write-Host "  [1] $(T 'update_opt_cron')  [2] $(T 'update_opt_body')  [3] $(T 'update_opt_both')  [0] $(T 'update_opt_cancel')" -ForegroundColor White
        Write-Host ""
        do { $mode = (Read-Host "  $(T 'choose')").Trim() } while ($mode -notmatch "^[0-3]$")
        if ($mode -eq "0") { continue }

        $cron = $null; $body = $null
        if ([int]$mode -eq 1 -or [int]$mode -eq 3) {
            Write-Info "$(T 'update_cron_current'): $($job.schedule)"
            $cron = Read-Cron "$(T 'update_cron_label')"
        }
        if ([int]$mode -eq 2 -or [int]$mode -eq 3) {
            Write-Info "$(T 'update_body_current'): $currBody"
            Read-Body "$(T 'update_body_label')" $currBody; $body = $global:REPLY_BODY
        }
        if (-not $cron -and -not $body) { Write-Warn (T "update_no_info"); continue }

        $change = Make-Change $job $cron $body
        Write-Header (T "update_confirm")
        Write-Info "$(T 'col_name'): $jobName"
        if ($change.cron) { Write-Info "cron: '$($job.schedule)' -> '$($change.cron)'" }
        if ($change.body) { Write-Info "body: $(T 'copy_summary_updated')" }
        Write-Host ""
        $conf = (Read-Host "  $(T 'update_confirm') $(T 'confirm_yn')").Trim().ToLower()
        if ($conf -ne (T "confirm_yes")) { Write-Warn (T "cancelled"); continue }

        Apply-Update $change
        $jobs = Load-Jobs
    }
}

# ================================================================
# COPY / COPIA
# ================================================================
function Run-Copy([array]$jobs) {
    while ($true) {
        Show-JobTable $jobs
        Write-Host "  [#]  $(T 'copy_opt_job')"  -ForegroundColor White
        Write-Host "  [V]  $(T 'copy_opt_back')" -ForegroundColor DarkGray
        Write-Host ""
        $input = (Read-Host "  $(T 'choose')").Trim()
        if ($input -ieq "v") { break }

        if ($input -notmatch "^\d+$" -or [int]$input -lt 1 -or [int]$input -gt $jobs.Count) {
            Write-Warn (T "invalid_option"); continue
        }

        $sourceJob  = $jobs[[int]$input - 1]
        $sourceName = $sourceJob.name -replace "^.*/jobs/", ""
        $sourceCron = $sourceJob.schedule
        $sourceUri  = ""; $sourceBody = ""; $type = ""

        if ($sourceJob.httpTarget) {
            $type       = "http"; $sourceUri  = $sourceJob.httpTarget.uri
            $sourceBody = Decode-Body $sourceJob.httpTarget.body
        } elseif ($sourceJob.pubsubTarget) {
            $type       = "pubsub"
            $sourceBody = Decode-Body $sourceJob.pubsubTarget.data
        } else { Write-Err (T "copy_unsupported"); continue }

        $bodyObj = $null
        if ($sourceBody -and $sourceBody.Trim() -ne "") {
            try   { $bodyObj = $sourceBody | ConvertFrom-Json }
            catch { $bodyObj = $sourceBody }
        }

        # Build template JSON / Monta JSON template
        $templateObj = if ($type -eq "http") {
            [ordered]@{ name = $sourceName; cron = $sourceCron; uri = $sourceUri; body = $bodyObj }
        } else {
            [ordered]@{ name = $sourceName; cron = $sourceCron; body = $bodyObj }
        }
        $templateJson = To-JsonPretty $templateObj

        Write-Header "$(T 'copy_title'): $sourceName"

        # Inner loop: create multiple jobs from same template
        # Loop interno: cria varios jobs a partir do mesmo template
        while ($true) {
            Write-Info (T "copy_editor_open")
            Write-Info (T "copy_editor_inst")
            Write-Info (T "copy_editor_save")
            Write-Host ""

            $rawEdited = Open-Editor $templateJson

            if (-not $rawEdited -or $rawEdited.Trim() -eq "") {
                Write-Warn (T "copy_empty_editor"); break
            }
            $edited = $null
            try { $edited = $rawEdited | ConvertFrom-Json }
            catch { Write-Err (T "copy_invalid_json"); continue }

            $newName = $edited.name; $newCron = $edited.cron
            $newUri  = $edited.uri; $newBody  = $null
            if ($edited.body) { $newBody = To-JsonClean $edited.body }

            if (-not $newName -or $newName.Trim() -eq "") { Write-Err (T "copy_name_required"); continue }
            $newName = $newName.Trim()

            if ($newName -eq $sourceName) {
                Write-Warn (T "copy_name_same_warn"); Write-Warn (T "copy_name_same_warn2")
                $ok = (Read-Host "  $(T 'copy_name_same_cont') $(T 'confirm_yn')").Trim().ToLower()
                if ($ok -ne (T "confirm_yes")) { continue }
            }

            Write-Header "$(T 'copy_title') - $(T 'copy_summary_name')"
            Write-Info "$(T 'copy_summary_name') : $newName"
            Write-Info "$(T 'copy_summary_cron') : $newCron"
            if ($type -eq "http") { Write-Info "$(T 'copy_summary_uri')  : $newUri" }
            if ($newBody)         { Write-Info "$(T 'copy_summary_body') : $(T 'copy_summary_updated')" }
            Write-Host ""
            $conf = (Read-Host "  $(T 'copy_confirm') $(T 'confirm_yn')").Trim().ToLower()
            if ($conf -ne (T "confirm_yes")) { Write-Warn (T "cancelled"); continue }

            Write-Header (T "copy_creating")
            $schedule = if ($newCron) { $newCron } else { $sourceCron }
            $timezone = $sourceJob.timeZone

            if ($type -eq "http") {
                $uri   = if ($newUri) { $newUri } else { $sourceUri }
                $flags = @("scheduler","jobs","create","http",$newName,
                           "--project=$PROJECT","--location=$LOCATION",
                           "--schedule=$schedule","--time-zone=$timezone",
                           "--uri=$uri","--http-method=$($sourceJob.httpTarget.httpMethod)")
                if ($sourceJob.httpTarget.oidcToken)  { $flags += "--oidc-service-account-email=$($sourceJob.httpTarget.oidcToken.serviceAccountEmail)" }
                if ($sourceJob.httpTarget.oauthToken) { $flags += "--oauth-service-account-email=$($sourceJob.httpTarget.oauthToken.serviceAccountEmail)" }
                $result = if ($newBody) { $flags += "--message-body-from-file=-"; $newBody | gcloud @flags 2>&1 }
                          else { gcloud @flags 2>&1 }
            } else {
                $flags = @("scheduler","jobs","create","pubsub",$newName,
                           "--project=$PROJECT","--location=$LOCATION",
                           "--schedule=$schedule","--time-zone=$timezone",
                           "--topic=$($sourceJob.pubsubTarget.topicName)")
                if ($newBody) { $flags += "--message-body=$newBody" }
                $result = gcloud @flags 2>&1
            }

            if ($LASTEXITCODE -eq 0) {
                Write-OK "'$newName' $(T 'copy_ok')"
                Write-Log "COPY OK | source=$sourceName | new=$newName | cron=$schedule" "OK"
            } else {
                Write-Err "$(T 'copy_fail_title')"; Write-Host "  $result" -ForegroundColor Red
                Write-Log "COPY FAIL | source=$sourceName | new=$newName | error=$result" "ERROR"
            }

            Write-Host ""
            $more = (Read-Host "  $(T 'copy_more') '$sourceName' $(T 'copy_more2') $(T 'confirm_yn')").Trim().ToLower()
            if ($more -ne (T "confirm_yes")) { $jobs = Load-Jobs; break }
        }
    }
}

# ================================================================
# TOGGLE (ENABLE / DISABLE) / HABILITAR / DESABILITAR
# ================================================================
function Run-Toggle([array]$jobs) {
    while ($true) {
        # Colored status table / Tabela com estado colorido
        Write-Host ""
        $maxName = ($jobs | ForEach-Object { ($_.name -replace "^.*/jobs/","").Length } | Measure-Object -Maximum).Maximum
        $maxName = [Math]::Max($maxName, 4)
        $header  = "  {0,-3}  {1,-$maxName}  {2,-17}  {3}" -f $L.col_num, $L.col_name, $L.col_cron, $L.col_status
        Write-Host $header -ForegroundColor DarkGray
        Write-Host ("  " + ("-" * ($header.Length - 2))) -ForegroundColor DarkGray
        for ($i = 0; $i -lt $jobs.Count; $i++) {
            $j = $jobs[$i]; $name = $j.name -replace "^.*/jobs/",""
            $cor = if ($j.state -eq "ENABLED") { "Green" } else { "Red" }
            Write-Host ("  {0,-3}  {1,-$maxName}  {2,-17}  {3}" -f ($i+1),$name,$j.schedule,$j.state) -ForegroundColor $cor
        }
        Write-Host ""

        Write-Host "  [#]  $(T 'toggle_opt_job')"   -ForegroundColor White
        Write-Host "  [L]  $(T 'toggle_opt_batch')" -ForegroundColor White
        Write-Host "  [V]  $(T 'toggle_opt_back')"  -ForegroundColor DarkGray
        Write-Host ""
        $input = (Read-Host "  $(T 'choose')").Trim()
        if ($input -ieq "v") { break }

        if ($input -ieq "l") {
            Write-Header (T "toggle_batch_title")
            Write-Info "$(T 'select_hint'):"
            Write-Host ""; $sel = (Read-Host "  >>").Trim()
            if (-not $sel) { Write-Warn (T "none_selected"); continue }
            $indices     = Parse-Selection $sel $jobs.Count
            if (-not $indices) { Write-Warn (T "no_valid_index"); continue }
            $selectedJobs = $indices | ForEach-Object { $jobs[$_ - 1] }

            Write-Host ""; Write-Host "  $(T 'selected_jobs')" -ForegroundColor DarkGray
            $selectedJobs | ForEach-Object {
                $n = $_.name -replace "^.*/jobs/",""; $cor = if ($_.state -eq "ENABLED") { "Green" } else { "Red" }
                Write-Host ("    - {0,-40} [{1}]" -f $n, $_.state) -ForegroundColor $cor
            }

            Write-Host ""
            Write-Host "  [1] $(T 'toggle_enable_all')"; Write-Host "  [2] $(T 'toggle_disable_all')"
            Write-Host "  [3] $(T 'toggle_invert')";     Write-Host "  [0] $(T 'toggle_cancel')"
            Write-Host ""
            do { $action = (Read-Host "  $(T 'choose')").Trim() } while ($action -notmatch "^[0-3]$")
            if ($action -eq "0") { continue }

            Write-Host ""
            $conf = (Read-Host "  $(T 'toggle_confirm_batch') $($selectedJobs.Count) $(T 'toggle_confirm_batch2') $(T 'confirm_yn')").Trim().ToLower()
            if ($conf -ne (T "confirm_yes")) { Write-Warn (T "cancelled"); continue }

            Write-Header (T "toggle_applying")
            foreach ($job in $selectedJobs) {
                $name = $job.name -replace "^.*/jobs/",""; $curr = $job.state
                $cmd  = switch ($action) {
                    "1" { "resume"  }
                    "2" { "pause"   }
                    "3" { if ($curr -eq "ENABLED") { "pause" } else { "resume" } }
                }
                if (($cmd -eq "resume" -and $curr -eq "ENABLED") -or ($cmd -eq "pause" -and $curr -eq "PAUSED")) {
                    Write-Warn "[$name] $(T 'toggle_already') $curr $(T 'toggle_already2')"; continue
                }
                $result = gcloud scheduler jobs $cmd $name --project=$PROJECT --location=$LOCATION 2>&1
                if ($LASTEXITCODE -eq 0) {
                    $next = if ($cmd -eq "resume") { "ENABLED" } else { "PAUSED" }
                    Write-OK "[$name] $curr -> $next"; Write-Log "TOGGLE OK | job=$name | $curr -> $next" "OK"
                } else { Write-Err "[$name] $(T 'toggle_fail'): $result"; Write-Log "TOGGLE FAIL | job=$name | error=$result" "ERROR" }
            }
            $jobs = Load-Jobs; continue
        }

        if ($input -notmatch "^\d+$" -or [int]$input -lt 1 -or [int]$input -gt $jobs.Count) {
            Write-Warn (T "invalid_option"); continue
        }
        $job  = $jobs[[int]$input - 1]; $name = $job.name -replace "^.*/jobs/",""; $curr = $job.state
        $cmd  = if ($curr -eq "ENABLED") { "pause" } else { "resume" }
        $dest = if ($cmd -eq "resume") { "ENABLED" } else { "PAUSED" }
        $corD = if ($cmd -eq "resume") { "Green" } else { "Red" }

        Write-Host ""; Write-Host "  $(T 'col_name')    : $name" -ForegroundColor White
        Write-Host "  $(T 'col_status')  : $curr  ->  " -NoNewline -ForegroundColor Gray
        Write-Host $dest -ForegroundColor $corD
        Write-Host ""
        $conf = (Read-Host "  $(T 'toggle_confirm_single') $(T 'confirm_yn')").Trim().ToLower()
        if ($conf -ne (T "confirm_yes")) { Write-Warn (T "cancelled"); continue }

        $result = gcloud scheduler jobs $cmd $name --project=$PROJECT --location=$LOCATION 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-OK "[$name] $curr -> $dest"; Write-Log "TOGGLE OK | job=$name | $curr -> $dest" "OK"
        } else { Write-Err "$(T 'toggle_fail'): $result"; Write-Log "TOGGLE FAIL | job=$name | error=$result" "ERROR" }
        $jobs = Load-Jobs
    }
}

# ================================================================
# RUN / EXECUTAR
# ================================================================
function Run-Execute([array]$jobs) {
    while ($true) {
        Show-JobTable $jobs
        Write-Host "  [#]  $(T 'run_opt_job')"   -ForegroundColor White
        Write-Host "  [L]  $(T 'run_opt_batch')" -ForegroundColor White
        Write-Host "  [V]  $(T 'run_opt_back')"  -ForegroundColor DarkGray
        Write-Host ""
        $input = (Read-Host "  $(T 'choose')").Trim()
        if ($input -ieq "v") { break }

        if ($input -ieq "l") {
            Write-Header (T "run_batch_title")
            Write-Info "$(T 'select_hint'):"
            Write-Host ""; $sel = (Read-Host "  >>").Trim()
            if (-not $sel) { Write-Warn (T "none_selected"); continue }
            $indices = Parse-Selection $sel $jobs.Count
            if (-not $indices) { Write-Warn (T "no_valid_index"); continue }
            $selectedJobs = $indices | ForEach-Object { $jobs[$_ - 1] }

            Write-Host ""; Write-Host "  $(T 'selected_jobs')" -ForegroundColor DarkGray
            $selectedJobs | ForEach-Object {
                Write-Host ("    - {0}  [{1}]" -f ($_.name -replace "^.*/jobs/",""), $_.schedule) -ForegroundColor Gray
            }
            Write-Host ""
            $conf = (Read-Host "  $(T 'run_confirm_batch') $($selectedJobs.Count) $(T 'run_confirm_batch2') $(T 'confirm_yn')").Trim().ToLower()
            if ($conf -ne (T "confirm_yes")) { Write-Warn (T "cancelled"); continue }

            Write-Header (T "run_running")
            foreach ($job in $selectedJobs) {
                $name   = $job.name -replace "^.*/jobs/",""
                $result = gcloud scheduler jobs run $name --project=$PROJECT --location=$LOCATION 2>&1
                if ($LASTEXITCODE -eq 0) { Write-OK "[$name] $(T 'run_ok')"; Write-Log "RUN OK | job=$name" "OK" }
                else { Write-Err "[$name] $(T 'run_fail'): $result"; Write-Log "RUN FAIL | job=$name | error=$result" "ERROR" }
            }
            continue
        }

        if ($input -notmatch "^\d+$" -or [int]$input -lt 1 -or [int]$input -gt $jobs.Count) {
            Write-Warn (T "invalid_option"); continue
        }
        $job  = $jobs[[int]$input - 1]; $name = $job.name -replace "^.*/jobs/",""
        Write-Host ""; Write-Host "  $(T 'col_name')  : $name" -ForegroundColor White
        Write-Host "  cron  : $($job.schedule)" -ForegroundColor Gray; Write-Host ""
        $conf = (Read-Host "  $(T 'run_confirm_single') '$name'? $(T 'confirm_yn')").Trim().ToLower()
        if ($conf -ne (T "confirm_yes")) { Write-Warn (T "cancelled"); continue }

        $result = gcloud scheduler jobs run $name --project=$PROJECT --location=$LOCATION 2>&1
        if ($LASTEXITCODE -eq 0) { Write-OK "[$name] $(T 'run_ok_single')"; Write-Log "RUN OK | job=$name" "OK" }
        else { Write-Err "$(T 'run_fail'): $result"; Write-Log "RUN FAIL | job=$name | error=$result" "ERROR" }
    }
}

# ================================================================
# ENTRY POINT / PONTO DE ENTRADA
# ================================================================

# Load config (creates file on first run) / Carrega config (cria arquivo na primeira execucao)
Load-Config

Write-Log "Session started | project=$PROJECT | location=$LOCATION | lang=$LANG_CODE"

# ================================================================
# MAIN MENU / MENU PRINCIPAL
# ================================================================
while ($true) {
    Write-Host ""
    Write-Host "  ================================================" -ForegroundColor Cyan
    Write-Host "   $(T 'menu_title')" -ForegroundColor Cyan
    Write-Host "  ================================================" -ForegroundColor Cyan
    Write-Host "  $(T 'menu_project')  : $PROJECT"  -ForegroundColor DarkGray
    Write-Host "  $(T 'menu_location') : $LOCATION" -ForegroundColor DarkGray
    Write-Host "  $(T 'menu_log')      : $LOG_FILE"  -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  [1] $(T 'menu_opt_consult')"  -ForegroundColor White
    Write-Host "  [2] $(T 'menu_opt_update')"   -ForegroundColor White
    Write-Host "  [3] $(T 'menu_opt_copy')"     -ForegroundColor White
    Write-Host "  [4] $(T 'menu_opt_toggle')"   -ForegroundColor White
    Write-Host "  [5] $(T 'menu_opt_run')"      -ForegroundColor White
    Write-Host "  [Q] $(T 'menu_opt_quit')"     -ForegroundColor DarkGray
    Write-Host ""
    $option = (Read-Host "  $(T 'choose')").Trim()

    if ($option -ieq "q") {
        Write-Log "Session ended by user."
        Write-Warn (T "menu_opt_quit"); break
    }

    if ($option -in "1","2","3","4","5") {
        $jobs = Load-Jobs
        if     ($option -eq "1") { Run-Consult  $jobs }
        elseif ($option -eq "2") { Run-Update   $jobs }
        elseif ($option -eq "3") { Run-Copy     $jobs }
        elseif ($option -eq "4") { Run-Toggle   $jobs }
        elseif ($option -eq "5") { Run-Execute  $jobs }
    } else {
        Write-Warn (T "menu_invalid")
    }
}
