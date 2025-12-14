#!/usr/bin/env bash
set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

SESSION_ID="${1:-unknown}"
TRANSCRIPT_PATH="${2:-}"
QUICK_MODE="${3:-}"

log_info "Mem0 Plugin: Session summary starting"

# Check if auto-capture is enabled
if ! is_auto_capture_enabled; then
    log_info "Auto-capture disabled, skipping"
    exit 0
fi

# Read transcript if available
if [[ -z "$TRANSCRIPT_PATH" ]] || [[ ! -f "$TRANSCRIPT_PATH" ]]; then
    log_warn "No transcript available, skipping session summary"
    exit 0
fi

# Count significant events
EDIT_COUNT=$(grep -c "tool.*Edit\|Write" "$TRANSCRIPT_PATH" || echo "0")
ERROR_COUNT=$(grep -c "error\|Error\|ERROR" "$TRANSCRIPT_PATH" || echo "0")

# Skip if session was trivial
if [[ "$EDIT_COUNT" -lt 3 ]] && [[ "$ERROR_COUNT" -eq 0 ]] && [[ "$QUICK_MODE" != "--quick" ]]; then
    log_info "Session too small to capture (${EDIT_COUNT} edits, ${ERROR_COUNT} errors)"
    exit 0
fi

# Extract key decisions/changes (simple heuristic)
SUMMARY=$(grep -E "decision|pattern|approach|fix|solution" "$TRANSCRIPT_PATH" | head -n 10 || echo "")

if [[ -z "$SUMMARY" ]]; then
    log_info "No significant patterns found in session"
    exit 0
fi

# Capture to Mem0 via Claude Code command
log_info "Capturing session summary to Mem0..."

# This would invoke the mem0-capture command through Claude Code
# In practice, this needs to call Claude Code CLI or API
# For now, log what would be captured

log_info "Would capture to Mem0:"
echo "$SUMMARY" | head -n 3

log_info "Session summary complete"
