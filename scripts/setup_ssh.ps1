# PowerShell script to set up SSH agent, add private key, and test GitHub access
# File: setup_ssh.ps1
# Usage: ./setup_ssh.ps1 [PathToPrivateKey]
# If omitted, looks for $HOME\.ssh\id_ed25519 then id_rsa.

param(
    [string]$KeyPath = "$HOME\.ssh\id_ed25519"
)

# Resolve key if not found
if (-Not (Test-Path $KeyPath)) {
    $KeyPath = "$HOME\.ssh\id_rsa"
    if (-Not (Test-Path $KeyPath)) {
        Write-Error "No SSH private key found at default locations. Provide path as argument."
        exit 1
    }
}

# Ensure ssh-agent service is running (Windows OpenSSH)
$service = Get-Service ssh-agent -ErrorAction SilentlyContinue
if ($null -eq $service) {
    Write-Error "ssh-agent service not found. Install OpenSSH client utilities first."
    exit 1
}
if ($service.Status -ne 'Running') {
    Start-Service ssh-agent
    Set-Service -Name ssh-agent -StartupType Automatic
}

# Add key to the agent
ssh-add $KeyPath
if ($LASTEXITCODE -ne 0) {
    Write-Error "ssh-add failed."
    exit 1
}
Write-Host "✅ SSH key added to agent: $KeyPath"

# Test GitHub SSH authentication
Write-Host "Testing GitHub SSH connection..."
ssh -T git@github.com 2>&1 | Write-Host

# End of script

