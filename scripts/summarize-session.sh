#!/usr/bin/env bash
set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

SESSION_ID="${1:-unknown}"
TRANSCRIPT_PATH="${2:-}"
QUICK_MODE="${3:-}"

log_info "Mem0 Plugin: Session summary starting (session: ${SESSION_ID})"

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
EDIT_COUNT=$(grep -c "tool.*Edit\|Write" "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
ERROR_COUNT=$(grep -c "error\|Error\|ERROR" "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
DECISION_COUNT=$(grep -c "decision\|decided\|approach" "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")

log_info "Session stats: ${EDIT_COUNT} edits, ${ERROR_COUNT} errors, ${DECISION_COUNT} decisions"

# Skip if session was trivial
if [[ "$EDIT_COUNT" -lt 3 ]] && [[ "$ERROR_COUNT" -eq 0 ]] && [[ "$DECISION_COUNT" -eq 0 ]] && [[ "$QUICK_MODE" != "--quick" ]]; then
    log_info "Session too small to capture (threshold: 3 edits or errors/decisions)"
    exit 0
fi

# Extract key patterns (simple heuristic - would be replaced by LLM call in production)
KEY_PATTERNS=$(grep -E "decision|pattern|approach|fix|solution|implement" "$TRANSCRIPT_PATH" | head -n 10 || echo "")

if [[ -z "$KEY_PATTERNS" ]]; then
    log_info "No significant patterns found in session"
    exit 0
fi

log_info "Capturing session insights to Mem0..."

# In production, this would:
# 1. Parse transcript more intelligently
# 2. Use Claude API to summarize key decisions
# 3. Call MCP mem0 tool to store memories
# 4. Tag with project context

# For now, create a marker file
SESSION_STATE_DIR="${HOME}/.claude/plugins/mem0/sessions/${SESSION_ID}"
mkdir -p "${SESSION_STATE_DIR}"
echo "${KEY_PATTERNS}" > "${SESSION_STATE_DIR}/patterns.txt"

log_info "Session summary complete. Found $(echo "${KEY_PATTERNS}" | wc -l) patterns."

# Output success message to Claude
if [[ "$QUICK_MODE" == "--quick" ]]; then
    output_system_message "🧠 Mem0: Quick session capture completed"
else
    output_system_message "🧠 Mem0: Session summary captured (${EDIT_COUNT} changes, ${DECISION_COUNT} decisions)"
fi

exit 0
