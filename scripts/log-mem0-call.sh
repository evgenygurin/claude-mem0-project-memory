#!/usr/bin/env bash
set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Validate environment
if ! validate_plugin_env; then
    exit ${EXIT_VALIDATION_ERROR}
fi

# Read hook input from stdin
if [[ -t 0 ]]; then
    log_warn "No input provided to log-mem0-call hook"
    exit ${EXIT_SUCCESS}
fi

INPUT_JSON=$(cat)

# Parse tool name and details
TOOL_NAME=$(echo "${INPUT_JSON}" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo "unknown")
TIMESTAMP=$(date -Iseconds)

log_debug "Mem0 tool called: ${TOOL_NAME} at ${TIMESTAMP}"

# Create log directory
LOG_DIR="${HOME}/.claude/plugins/mem0/logs"
mkdir -p "${LOG_DIR}" || {
    log_error "Failed to create log directory: ${LOG_DIR}"
    exit ${EXIT_VALIDATION_ERROR}
}

# Append to log file
LOG_FILE="${LOG_DIR}/mem0-calls.jsonl"
echo "${INPUT_JSON}" | jq -c ". + {\"timestamp\": \"${TIMESTAMP}\"}" >> "${LOG_FILE}" 2>/dev/null || {
    # Fallback if jq fails
    echo "{\"tool_name\": \"${TOOL_NAME}\", \"timestamp\": \"${TIMESTAMP}\"}" >> "${LOG_FILE}"
}

log_debug "Mem0 call logged to ${LOG_FILE}"
exit ${EXIT_SUCCESS}
