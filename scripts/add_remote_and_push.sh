#!/usr/bin/env bash
# Script: add_remote_and_push.sh
# Usage: ./add_remote_and_push.sh <repo-url>
# Adds the remote "origin" and pushes the current branch (main) to the remote.
# The script assumes it is run from the root of the FTTH_System repository.

set -e

if [ -z "$1" ]; then
  echo "Error: repository URL not provided."
  echo "Usage: $0 <repo-url>"
  exit 1
fi

REPO_URL="$1"

# Verify we are in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Not inside a git repository."
  exit 1
fi

# Add or update remote "origin"
if git remote get-url origin >/dev/null 2>&1; then
  echo "Remote 'origin' exists. Updating URL to $REPO_URL"
  git remote set-url origin "$REPO_URL"
else
  echo "Adding remote 'origin' -> $REPO_URL"
  git remote add origin "$REPO_URL"
fi

# Push the current branch (default main) and set upstream
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Pushing branch $CURRENT_BRANCH to origin..."

git push -u origin "$CURRENT_BRANCH"

echo "Push completed."

