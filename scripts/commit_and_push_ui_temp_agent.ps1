# PowerShell script to commit and push the UI prototype using a temporary ssh-agent
# File: commit_and_push_ui_temp_agent.ps1
# ------------------------------------------------------------
# This script:
#   1. Starts a temporary ssh-agent via the ssh-agent.exe binary (no admin rights).
#   2. Loads the default private key (id_ed25519 or id_rsa).
#   3. Stages the frontend folder, creates a commit, and pushes to the SSH remote.
# ------------------------------------------------------------

function Write-Info($msg) { Write-Host $msg -ForegroundColor Cyan }
function Write-ErrorMsg($msg) { Write-Host $msg -ForegroundColor Red }

# 0. Verify OpenSSH client is available
if (-not (Get-Command ssh-agent -ErrorAction SilentlyContinue)) {
    Write-ErrorMsg "ssh-agent executable not found. Install the OpenSSH Client feature (requires admin rights)."
    exit 1
}
if (-not (Get-Command ssh-add -ErrorAction SilentlyContinue)) {
    Write-ErrorMsg "ssh-add executable not found. Install the OpenSSH Client feature (requires admin rights)."
    exit 1
}

# 1. Start a temporary ssh-agent
Write-Info "Starting temporary ssh-agent..."
$agentOutput = & ssh-agent -s
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Failed to start ssh-agent. Ensure OpenSSH client is installed and ssh-agent.exe is in PATH."
    exit 1
}
# Export the environment variables returned by ssh-agent
foreach ($line in $agentOutput -split "`n") {
    if ($line -match "^(SSH_AUTH_SOCK|SSH_AGENT_PID)=(.+?);") {
        $var = $matches[1]
        $value = $matches[2]
        Set-Item -Path Env:$var -Value $value
    }
}
Write-Info "ssh-agent started (PID $env:SSH_AGENT_PID)."

# 2. Add the private key to the agent (prefer ed25519, fallback to rsa)
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

# 3. Git operations (run from repository root)
$repoRoot = (git rev-parse --show-toplevel) 2>$null
if (-not $repoRoot) {
    Write-ErrorMsg "Cannot determine git repository root. Run this script from inside the FTTH_System repository."
    exit 1
}
Set-Location $repoRoot

# Stage frontend folder
Write-Info "Staging frontend files..."
git add frontend
if ($LASTEXITCODE -ne 0) { Write-ErrorMsg "git add failed."; exit 1 }

# Commit
$commitMsg = "Add main‑screen UI prototype (HTML + CSS)"
Write-Info "Creating commit: $commitMsg"
git commit -m "$commitMsg"
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "git commit failed (maybe nothing to commit)."
    exit 1
}

# Push – assumes remote 'origin' is already set to the SSH URL
Write-Info "Pushing to remote..."
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "git push failed. Ensure the SSH key is registered on GitHub and you have push rights."
    exit 1
}

Write-Info "✅ Push completed successfully."

