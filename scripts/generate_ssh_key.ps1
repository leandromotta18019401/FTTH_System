# PowerShell script to generate an Ed25519 SSH key for this user
# File: generate_ssh_key.ps1
# ------------------------------------------------------------
# This script creates $HOME\.ssh\id_ed25519 (if it does not already exist)
# and prints the public key so you can add it to GitHub.
# ------------------------------------------------------------

function Write-Info($msg) { Write-Host $msg -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host $msg -ForegroundColor Yellow }
function Write-ErrorMsg($msg) { Write-Host $msg -ForegroundColor Red }

$sshDir = "$HOME\.ssh"
if (-Not (Test-Path $sshDir)) {
    Write-Info "Creating .ssh directory at $sshDir"
    New-Item -ItemType Directory -Path $sshDir | Out-Null
}

$privateKey = "$sshDir\id_ed25519"
$publicKey = "$privateKey.pub"

if (Test-Path $privateKey) {
    Write-Warn "Key $privateKey already exists – not overwriting."
} else {
    Write-Info "Generating Ed25519 SSH key..."
    # -N "" sets an empty passphrase
    ssh-keygen -t ed25519 -C "antigravity_user" -f $privateKey -N ""
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorMsg "ssh-keygen failed. Ensure OpenSSH client is installed."
        exit 1
    }
    Write-Info "Key generated at $privateKey"
}

if (Test-Path $publicKey) {
    Write-Info "Public key ($publicKey):"
    Get-Content $publicKey | Write-Host
    Write-Info "Copy the above line and add it to GitHub -> Settings -> SSH and GPG keys."
} else {
    Write-ErrorMsg "Public key not found after generation."
    exit 1
}

