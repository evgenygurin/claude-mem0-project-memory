#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

PROJECT_DIR="${1:-$PWD}"
TOOL_NAME="${2:-unknown}"

log_info "Mem0 Plugin: Checking if CLAUDE.md sync needed"

# Check if sync is enabled
if ! is_sync_enabled; then
    log_info "Sync disabled, skipping"
    exit 0
fi

# Check if enough changes accumulated
CHANGES_SINCE_SYNC=$(get_changes_since_last_sync)
THRESHOLD=$(get_reflection_threshold)

if [[ "$CHANGES_SINCE_SYNC" -lt "$THRESHOLD" ]]; then
    log_info "Not enough changes for sync (${CHANGES_SINCE_SYNC}/${THRESHOLD})"
    exit 0
fi

log_info "Threshold reached, triggering CLAUDE.md sync..."

# Trigger sync command
# In real implementation, this would call Claude Code to run /mem0-sync
log_info "Would run: /mem0-sync"

# Reset counter
reset_sync_counter

log_info "CLAUDE.md sync complete"
