# PowerShell script to commit and push the UI prototype using SSH
# File: commit_and_push_ui_ssh.ps1
# ------------------------------------------------------------
# This script:
#   1. Ensures the OpenSSH client and ssh-agent service are installed.
#   2. Starts the ssh-agent service (if it is stopped).
#   3. Loads the default private key (id_ed25519 or id_rsa).
#   4. Adds the frontend folder to git, commits, and pushes to the remote.
# ------------------------------------------------------------

function Write-Info($msg) { Write-Host $msg -ForegroundColor Cyan }
function Write-ErrorMsg($msg) { Write-Host $msg -ForegroundColor Red }

# ------------------------------------------------------------
# 0. Verify OpenSSH client is available
# ------------------------------------------------------------
if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) {
    Write-ErrorMsg "OpenSSH client not found. Install it via 'Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0' and retry."
    exit 1
}

# ------------------------------------------------------------
# 1. Ensure ssh-agent service exists and start it
# ------------------------------------------------------------
$service = Get-Service -Name ssh-agent -ErrorAction SilentlyContinue
if (-not $service) {
    Write-ErrorMsg "ssh-agent service not found. Enable the OpenSSH Authentication Agent feature:"
    Write-Host "   Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0" -ForegroundColor Yellow
    exit 1
}
if ($service.Status -ne 'Running') {
    Write-Info "Starting ssh-agent service..."
    try {
        Start-Service ssh-agent -ErrorAction Stop
        Write-Info "ssh-agent service started."
    } catch {
        Write-ErrorMsg "Failed to start ssh-agent service: $_.Exception.Message"
        exit 1
    }
}

# ------------------------------------------------------------
# 2. Add the private key to the agent
# ------------------------------------------------------------
$defaultKey = "$HOME\.ssh\id_ed25519"
if (-not (Test-Path $defaultKey)) { $defaultKey = "$HOME\.ssh\id_rsa" }
if (-not (Test-Path $defaultKey)) {
    Write-ErrorMsg "No SSH private key found at $HOME\.ssh\id_ed25519 or id_rsa. Place your key there or specify its path as a parameter."
    exit 1
}
Write-Info "Adding SSH key $defaultKey to the agent..."
ssh-add $defaultKey
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "ssh-add failed. Verify the key file and its permissions."
    exit 1
}
Write-Info "SSH key added successfully."

# ------------------------------------------------------------
# 3. Git operations (run from repository root)
# ------------------------------------------------------------
$repoRoot = (git rev-parse --show-toplevel) 2>$null
if (-not $repoRoot) {
    Write-ErrorMsg "Cannot determine git repository root. Make sure you run this script inside the FTTH_System repo."
    exit 1
}
Set-Location $repoRoot

Write-Info "Staging frontend folder..."
git add frontend
if ($LASTEXITCODE -ne 0) { Write-ErrorMsg "git add failed."; exit 1 }

$commitMsg = "Add main‑screen UI prototype (HTML + CSS)"
Write-Info "Creating commit: $commitMsg"
git commit -m "$commitMsg"
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "git commit failed (maybe nothing to commit)."
    exit 1
}

Write-Info "Pushing to remote (origin/main)..."
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "git push failed. Ensure the SSH key is registered on GitHub and you have push rights."
    exit 1
}

Write-Info "✅ Push completed successfully."

