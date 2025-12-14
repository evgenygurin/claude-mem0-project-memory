#!/usr/bin/env bash
set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# Validate environment
if ! validate_plugin_env; then
    exit ${EXIT_VALIDATION_ERROR}
fi

# Get project directory from arguments or environment
PROJECT_DIR="${1:-${CLAUDE_PROJECT_DIR:-}}"

if ! validate_project_dir "${PROJECT_DIR}"; then
    exit ${EXIT_VALIDATION_ERROR}
fi

# Check if auto-capture is enabled
if ! is_auto_capture_enabled; then
    log_debug "Auto-capture is disabled, skipping change tracking"
    exit ${EXIT_SUCCESS}
fi

# Get session state
STATE_FILE=$(get_session_state_file "${PROJECT_DIR}")

# Initialize state if needed
if [[ ! -f "${STATE_FILE}" ]]; then
    if ! init_session_state "${STATE_FILE}"; then
        log_error "Failed to initialize session state"
        exit ${EXIT_VALIDATION_ERROR}
    fi
fi

# Increment changes count
if ! increment_changes_count "${STATE_FILE}"; then
    log_error "Failed to increment changes count"
    exit ${EXIT_VALIDATION_ERROR}
fi

# Get current count
CHANGES_COUNT=$(get_changes_count "${STATE_FILE}")
THRESHOLD=$(get_reflection_threshold)

log_debug "Changes count: ${CHANGES_COUNT}, Threshold: ${THRESHOLD}"

# Check if sync is needed
if [[ ${CHANGES_COUNT} -ge ${THRESHOLD} ]] && is_sync_enabled; then
    log_info "Change threshold reached (${CHANGES_COUNT}/${THRESHOLD}), sync recommended"
    output_system_message "💡 Tip: ${CHANGES_COUNT} code changes made. Consider running /mem0-sync to update project memory."
    
    # Reset counter after recommendation
    reset_changes_count "${STATE_FILE}"
fi

exit ${EXIT_SUCCESS}
