#!/usr/bin/env pwsh
# ------------------------------------------------------------
# Script automático para configurar e iniciar o serviço NOC
# ------------------------------------------------------------
# Este script executa, na ordem:
#   1. npm ci      – instalação limpa usando package-lock.json
#   2. npm test    – roda a suite de testes (se houver)
#   3. npm run build – compila TypeScript para JavaScript
#   4. npm run start – inicia a aplicação em modo produção
# Se algum passo crítico falhar, o script aborta.
# ------------------------------------------------------------

function Write-Info($msg) { Write-Host $msg -ForegroundColor Cyan }
function Write-ErrorMsg($msg) { Write-Host $msg -ForegroundColor Red }

$serviceDir = "${env:USERPROFILE}\OneDrive\Documentos\ANTIGRAVITY\FTTH_System\services\noc"
Write-Info "Entrando no diretório do serviço NOC: $serviceDir"
Set-Location $serviceDir

# 1. npm ci – instalação limpa
Write-Info "\n--- npm ci (instalação limpa) ---"
npm ci
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "npm ci falhou. Abortando."
    exit 1
}

# 2. npm test – rodar testes (opcional)
Write-Info "\n--- npm test (executando testes) ---"
npm test
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Alguns testes falharam. Continuando, mas verifique os resultados."
    # Não aborta, apenas avisa
}

# 3. npm run build – compilar TypeScript
Write-Info "\n--- npm run build (compilando) ---"
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Build falhou. Abortando."
    exit 1
}

# 4. npm run start – iniciar a aplicação
Write-Info "\n--- npm run start (iniciando aplicação) ---"
npm run start
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Falha ao iniciar a aplicação."
    exit 1
}

Write-Info "\n✅ Script concluído com sucesso. Servico NOC está rodando."

