#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

PROJECT_DIR="${1:-$PWD}"
TOOL_NAME="${2:-unknown}"

# Read stdin JSON if available
if [[ ! -t 0 ]]; then
    INPUT_JSON=$(cat)
    # Could parse tool_input/tool_response here for more context
fi

log_info "Mem0 Plugin: Tracking change (tool: ${TOOL_NAME})"

# Increment change counter
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
STATE_FILE="${HOME}/.claude/plugins/mem0/sessions/${SESSION_ID}/state.json"

if [[ -f "${STATE_FILE}" ]]; then
    CURRENT_COUNT=$(jq -r '.changes_count // 0' "${STATE_FILE}" 2>/dev/null || echo "0")
    NEW_COUNT=$((CURRENT_COUNT + 1))
    
    jq --arg count "${NEW_COUNT}" '.changes_count = ($count | tonumber)' "${STATE_FILE}" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "${STATE_FILE}"
    
    log_info "Change count: ${NEW_COUNT}"
    
    # Check if sync threshold reached
    THRESHOLD=$(get_reflection_threshold)
    if [[ "${NEW_COUNT}" -ge "${THRESHOLD}" ]]; then
        log_info "Sync threshold reached (${NEW_COUNT}/${THRESHOLD})"
        # Trigger sync notification
        echo '{"systemMessage": "💾 Mem0: Sync threshold reached. Consider running /mem0-sync"}' 
    fi
fi

exit 0
