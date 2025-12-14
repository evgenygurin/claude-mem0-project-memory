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
QUICK_MODE="${2:-}"

if ! validate_project_dir "${PROJECT_DIR}"; then
    exit ${EXIT_VALIDATION_ERROR}
fi

# Check if auto-capture is enabled
if ! is_auto_capture_enabled; then
    log_debug "Auto-capture is disabled, skipping session summary"
    exit ${EXIT_SUCCESS}
fi

log_info "Mem0 Plugin: Capturing session summary for project: ${PROJECT_DIR}"

# Get session state
STATE_FILE=$(get_session_state_file "${PROJECT_DIR}")

if [[ ! -f "${STATE_FILE}" ]]; then
    log_warn "Session state file not found, nothing to summarize"
    exit ${EXIT_SUCCESS}
fi

# Get changes count
CHANGES_COUNT=$(get_changes_count "${STATE_FILE}")

if [[ ${CHANGES_COUNT} -eq 0 ]]; then
    log_info "No significant changes in this session"
    exit ${EXIT_SUCCESS}
fi

if [[ "${QUICK_MODE}" == "--quick" ]]; then
    log_info "Quick mode: Session had ${CHANGES_COUNT} changes"
    output_system_message "Session ended with ${CHANGES_COUNT} code changes. Consider capturing key decisions with /mem0-capture."
else
    log_info "Full session summary: ${CHANGES_COUNT} changes recorded"
    
    # Future: Could analyze session transcript here
    # For now, just provide a notification
    output_system_message "Session completed. ${CHANGES_COUNT} code changes were made. Use /mem0-reflect to extract learnings from recent sessions."
fi

# Reset changes counter for next session
reset_changes_count "${STATE_FILE}"

log_info "Session summary captured successfully"
exit ${EXIT_SUCCESS}
