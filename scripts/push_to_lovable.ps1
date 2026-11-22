#!/usr/bin/env pwsh
# push_to_lovable.ps1 – configure SSH, set remote to Lovable repo, rename branch to main, push.
# Usage: ./push_to_lovable.ps1
# Assumes the repository root is the current directory.

# 1. Start temporary ssh-agent and load key (uses existing setup_ssh_agent.ps1).
Write-Host "Setting up SSH agent..."
& "$PSScriptRoot\setup_ssh_agent.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error "SSH setup failed – aborting push."
    exit 1
}

# 2. Ensure remote points to the SSH URL of the Lovable repository.
$sshUrl = "git@github.com:leandromotta18019401/FTTH_System.git"
Write-Host "Configuring remote 'origin' to $sshUrl"
git remote set-url origin $sshUrl
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to set remote URL"; exit 1 }

# 3. Rename current branch to 'main' (GitHub default).
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -ne "main") {
    Write-Host "Renaming branch $currentBranch to main..."
    git branch -M main
    if ($LASTEXITCODE -ne 0) { Write-Error "Branch rename failed"; exit 1 }
}

# 4. Push to remote and set upstream.
Write-Host "Pushing to Lovable repository..."
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Error "git push failed. Check SSH access and repository permissions."
    exit 1
}
Write-Host '✅ Push completed successfully. You can now view the project in Lovable.'
