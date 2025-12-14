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

    # Auto-add session summary to Mem0 if enabled
    if is_auto_add_enabled; then
        local project_name=$(basename "${PROJECT_DIR}")
        local timestamp=$(date -Iseconds)
        local session_date=$(date '+%Y-%m-%d %H:%M')

        # Create session summary content
        local summary_content="Session completed on ${session_date} for project '${project_name}': ${CHANGES_COUNT} code changes were made during this development session."

        # Create metadata
        local metadata=$(jq -n \
            --arg project "${project_name}" \
            --arg timestamp "${timestamp}" \
            --arg type "session_summary" \
            --arg changes "${CHANGES_COUNT}" \
            '{
                project: $project,
                timestamp: $timestamp,
                type: $type,
                changes_count: ($changes | tonumber),
                source: "SessionEnd hook"
            }')

        log_info "Adding session summary to Mem0"

        # Add to Mem0
        if memory_id=$(add_memory_to_mem0 "${summary_content}" "${project_name}" "${metadata}"); then
            log_info "Session summary added to Mem0: ${memory_id}"
            output_system_message "✅ Session completed. ${CHANGES_COUNT} changes recorded and automatically saved to project memory [${memory_id}]."
        else
            log_warn "Failed to add session summary to Mem0"
            output_system_message "Session completed. ${CHANGES_COUNT} code changes were made. Use /mem0-reflect to extract learnings from recent sessions."
        fi
    else
        # Auto-add disabled, just notify
        output_system_message "Session completed. ${CHANGES_COUNT} code changes were made. Use /mem0-reflect to extract learnings from recent sessions."
    fi
fi

# Reset changes counter for next session
reset_changes_count "${STATE_FILE}"

log_info "Session summary captured successfully"
exit ${EXIT_SUCCESS}
