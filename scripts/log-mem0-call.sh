#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

TOOL_NAME="${1:-unknown}"

# Read hook event data from stdin
if [[ ! -t 0 ]]; then
    INPUT_JSON=$(cat)
    
    # Extract relevant info
    TOOL_INPUT=$(echo "${INPUT_JSON}" | jq -c '.tool_input // {}')
    TOOL_RESPONSE=$(echo "${INPUT_JSON}" | jq -c '.tool_response // {}')
    
    # Log to debug file
    LOG_FILE="${HOME}/.claude/plugins/mem0/debug.log"
    mkdir -p "$(dirname "${LOG_FILE}")"
    
    echo "[$(date -Iseconds)] ${TOOL_NAME}" >> "${LOG_FILE}"
    echo "  Input: ${TOOL_INPUT}" >> "${LOG_FILE}"
    echo "  Response: ${TOOL_RESPONSE}" >> "${LOG_FILE}"
    echo "" >> "${LOG_FILE}"
fi

exit 0
