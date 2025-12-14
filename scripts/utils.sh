#!/usr/bin/env bash

CONFIG_FILE="${CLAUDE_PLUGIN_ROOT:-$PWD}/config/memory-config.json"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] INFO: $*" >&2
}

log_warn() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] WARN: $*" >&2
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] ERROR: $*" >&2
}

# Check if jq is available
require_jq() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed"
        return 1
    fi
    return 0
}

is_auto_capture_enabled() {
    if [[ -f "$CONFIG_FILE" ]] && require_jq; then
        AUTO_CAPTURE=$(jq -r '.auto_capture // true' "$CONFIG_FILE")
        [[ "$AUTO_CAPTURE" == "true" ]]
    else
        return 0  # default enabled
    fi
}

is_sync_enabled() {
    if [[ -f "$CONFIG_FILE" ]] && require_jq; then
        SYNC_ENABLED=$(jq -r '.sync_to_claude_md // true' "$CONFIG_FILE")
        [[ "$SYNC_ENABLED" == "true" ]]
    else
        return 0  # default enabled
    fi
}

is_auto_load_context_enabled() {
    if [[ -f "$CONFIG_FILE" ]] && require_jq; then
        AUTO_LOAD=$(jq -r '.auto_load_context // false' "$CONFIG_FILE")
        [[ "$AUTO_LOAD" == "true" ]]
    else
        return 1  # default disabled
    fi
}

get_reflection_threshold() {
    if [[ -f "$CONFIG_FILE" ]] && require_jq; then
        jq -r '.reflection_threshold // 5' "$CONFIG_FILE"
    else
        echo "5"
    fi
}

get_session_state_file() {
    local session_id="${CLAUDE_SESSION_ID:-unknown}"
    echo "${HOME}/.claude/plugins/mem0/sessions/${session_id}/state.json"
}

get_changes_count() {
    local state_file=$(get_session_state_file)
    if [[ -f "${state_file}" ]] && require_jq; then
        jq -r '.changes_count // 0' "${state_file}"
    else
        echo "0"
    fi
}

reset_changes_count() {
    local state_file=$(get_session_state_file)
    if [[ -f "${state_file}" ]] && require_jq; then
        jq '.changes_count = 0 | .last_sync = "'$(date -Iseconds)'"' "${state_file}" > "${state_file}.tmp" && mv "${state_file}.tmp" "${state_file}"
    fi
}

# Output JSON for hook responses
output_json() {
    local json="$1"
    echo "${json}"
}

# Output system message to Claude
output_system_message() {
    local message="$1"
    output_json '{"systemMessage": "'"${message}"'"}'
}
