# PowerShell script to start a temporary ssh-agent, add a private key, and test GitHub SSH access
# File: setup_ssh_agent.ps1
# Usage: ./setup_ssh_agent.ps1 [PathToPrivateKey]
# If omitted, it checks $HOME\.ssh\id_ed25519 then id_rsa.

param(
    [string]$KeyPath = "$HOME\.ssh\id_ed25519"
)

# Resolve key location
if (-Not (Test-Path $KeyPath)) {
    $KeyPath = "$HOME\.ssh\id_rsa"
    if (-Not (Test-Path $KeyPath)) {
        Write-Error "No SSH private key found at default locations. Provide the path as argument."
        exit 1
    }
}

# Start a temporary ssh-agent (does not require admin rights)
$agentOutput = & ssh-agent -s
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to start ssh-agent. Ensure OpenSSH client is installed and ssh-agent.exe is in PATH."
    exit 1
}
# ssh-agent -s returns lines like: SSH_AUTH_SOCK=...; export SSH_AUTH_SOCK; SSH_AGENT_PID=...; export SSH_AGENT_PID;
# We need to evaluate those assignments in PowerShell.
foreach ($line in $agentOutput -split "`n") {
    if ($line -match "^(SSH_AUTH_SOCK|SSH_AGENT_PID)=(.+?);") {
        $var = $matches[1]
        $value = $matches[2]
        Set-Item -Path Env:$var -Value $value
    }
}
Write-Host "✅ ssh-agent started (PID $env:SSH_AGENT_PID)"

# Add the private key to the agent (will prompt for passphrase if set)
ssh-add $KeyPath
if ($LASTEXITCODE -ne 0) {
    Write-Error "ssh-add failed. Verify the key file and permissions."
    exit 1
}
Write-Host "✅ SSH key added: $KeyPath"

# Test GitHub connection
Write-Host "Testing GitHub SSH authentication..."
$testResult = ssh -T git@github.com 2>&1
Write-Host $testResult

# End of script
