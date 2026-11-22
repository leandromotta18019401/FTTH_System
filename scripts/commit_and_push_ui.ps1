# PowerShell script to commit and push the UI prototype using SSH
# File: commit_and_push_ui.ps1
# ------------------------------------------------------------
# This script:
# 1. Starts a temporary ssh-agent (if not already running).
# 2. Loads the default private key ($HOME\.ssh\id_ed25519 or id_rsa).
# 3. Adds the frontend files to git, creates a commit, and pushes to the remote.
# ------------------------------------------------------------

# Helper function to write colored messages
function Write-Info($msg) { Write-Host $msg -ForegroundColor Cyan }
function Write-ErrorMsg($msg) { Write-Host $msg -ForegroundColor Red }

# 1. Start ssh-agent (portable across Windows installations)
Write-Info "Starting ssh-agent..."
$agentOutput = & ssh-agent -s
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Failed to start ssh-agent. Ensure OpenSSH client is installed and ssh-agent.exe is in PATH."
    exit 1
}
# Export environment variables returned by ssh-agent
foreach ($line in $agentOutput -split "`n") {
    if ($line -match "^(SSH_AUTH_SOCK|SSH_AGENT_PID)=(.+?);") {
        $var = $matches[1]
        $value = $matches[2]
        Set-Item -Path Env:$var -Value $value
    }
}
Write-Info "ssh-agent started (PID $env:SSH_AGENT_PID)."

# 2. Add private key (prefer ed25519, fallback to rsa)
$defaultKey = "$HOME\.ssh\id_ed25519"
if (-Not (Test-Path $defaultKey)) {
    $defaultKey = "$HOME\.ssh\id_rsa"
}
if (-Not (Test-Path $defaultKey)) {
    Write-ErrorMsg "No SSH private key found at $HOME\.ssh\id_ed25519 or id_rsa. Place your key there or specify its path as a parameter."
    exit 1
}
Write-Info "Adding SSH key $defaultKey..."
ssh-add $defaultKey
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "ssh-add failed. Verify the key file and its permissions."
    exit 1
}
Write-Info "SSH key added successfully."

# 3. Git operations
# Ensure we are in the repository root
$repoRoot = (git rev-parse --show-toplevel) 2>$null
if (-Not $repoRoot) {
    Write-ErrorMsg "Could not determine repository root. Run this script from within the FTTH_System repo."
    exit 1
}
Set-Location $repoRoot

# Stage frontend folder
Write-Info "Adding frontend files to git..."
git add frontend
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "git add failed."
    exit 1
}

# Commit
$commitMessage = "Add main‑screen UI prototype (HTML + CSS)"
Write-Info "Committing with message: $commitMessage"
git commit -m "$commitMessage"
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "git commit failed. Possibly there is nothing to commit."
    exit 1
}

# Push – assumes remote 'origin' is already set to the SSH URL
Write-Info "Pushing to remote..."
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "git push failed. Ensure the SSH key is registered in your GitHub account and you have push rights."
    exit 1
}

Write-Info "✅ Push completed successfully."

