#!/usr/bin/env bash
set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

SESSION_ID="${1:-unknown}"
PROJECT_DIR="${2:-$PWD}"

log_info "Mem0 Plugin: Initializing session ${SESSION_ID}"

# Create session state directory
SESSION_STATE_DIR="${HOME}/.claude/plugins/mem0/sessions/${SESSION_ID}"
mkdir -p "${SESSION_STATE_DIR}"

# Initialize change counter
echo '{"changes_count": 0, "started_at": "'$(date -Iseconds)'"}' > "${SESSION_STATE_DIR}/state.json"

# Check Mem0 connectivity (optional)
if command -v curl &> /dev/null && [[ -n "${MEM0_API_KEY:-}" ]]; then
    log_info "Checking Mem0 API connectivity..."
    # Could add actual API check here
fi

# Load project-specific memory context (if configured)
if is_auto_load_context_enabled; then
    log_info "Auto-loading project memory context"
    # This would trigger context loading in future versions
fi

log_info "Session initialized successfully"
exit 0
