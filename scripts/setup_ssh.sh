#!/usr/bin/env bash
# setup_ssh.sh – configure ssh-agent, add your private key and test GitHub connectivity.
# Usage: ./setup_ssh.sh [path-to-private-key]
# If the key path is omitted the script tries ~/.ssh/id_ed25519 then ~/.ssh/id_rsa.

set -e

# -------------------------------------------------------------------
# Resolve key location
# -------------------------------------------------------------------
KEY_PATH="${1:-$HOME/.ssh/id_ed25519}"
if [[ ! -f "$KEY_PATH" ]]; then
  KEY_PATH="$HOME/.ssh/id_rsa"
fi

if [[ ! -f "$KEY_PATH" ]]; then
  echo "Error: No SSH private key found at $HOME/.ssh/id_ed25519 or $HOME/.ssh/id_rsa"
  exit 1
fi

# -------------------------------------------------------------------
# Start ssh-agent if needed
# -------------------------------------------------------------------
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi

# -------------------------------------------------------------------
# Add the key to the agent (prompt for passphrase if set)
# -------------------------------------------------------------------
ssh-add "$KEY_PATH"

echo "✅ SSH key added to the agent: $KEY_PATH"

# -------------------------------------------------------------------
# Test GitHub SSH access
# -------------------------------------------------------------------
ssh -T git@github.com || true   # GitHub returns a non‑zero exit code after success message

# End of script

