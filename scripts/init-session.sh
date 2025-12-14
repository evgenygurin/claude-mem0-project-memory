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

log_info "Mem0 Plugin: Initializing session for project: ${PROJECT_DIR}"

# Ensure session state directory exists
if ! ensure_session_state_dir; then
    exit ${EXIT_VALIDATION_ERROR}
fi

# Initialize session state
STATE_FILE=$(get_session_state_file "${PROJECT_DIR}")
if ! init_session_state "${STATE_FILE}"; then
    exit ${EXIT_VALIDATION_ERROR}
fi

log_info "Session state initialized: ${STATE_FILE}"

# Check Mem0 connectivity (non-fatal)
check_mem0_connectivity || log_warn "Mem0 API connectivity check failed, but continuing"

# Load project-specific memory context (if configured)
if is_auto_load_context_enabled; then
    log_info "Auto-loading project memory context"
    # Future: trigger context loading via MCP
fi

log_info "Session initialized successfully"
exit ${EXIT_SUCCESS}
