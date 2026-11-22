#!/usr/bin/env pwsh
# push_with_ssh.ps1 – start temporary ssh-agent, add key, then push to origin/main
# Usage: ./push_with_ssh.ps1
# Assumes remote "origin" is already set to the SSH URL.

# Run the ssh agent setup (adds key to the agent)
Write-Host "Setting up SSH agent and loading key..."
& "$PSScriptRoot\setup_ssh_agent.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error "SSH setup failed – aborting push."
    exit 1
}

# Perform the push
Write-Host "Pushing to remote origin/main..."
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Error "git push failed."
    exit 1
}
Write-Host "✅ Push completed successfully."

