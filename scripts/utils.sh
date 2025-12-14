#!/usr/bin/env bash

CONFIG_FILE="${CLAUDE_PLUGIN_ROOT:-$PWD}/config/memory-config.json"
STATE_FILE="${HOME}/.claude/plugins/mem0-state.json"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] INFO: $*" >&2
}

log_warn() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] WARN: $*" >&2
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] ERROR: $*" >&2
}

is_auto_capture_enabled() {
    if [[ -f "$CONFIG_FILE" ]]; then
        grep -q '"auto_capture":\s*true' "$CONFIG_FILE" && return 0
    fi
    return 0  # default enabled
}

is_sync_enabled() {
    if [[ -f "$CONFIG_FILE" ]]; then
        grep -q '"sync_to_claude_md":\s*true' "$CONFIG_FILE" && return 0
    fi
    return 0  # default enabled
}

get_reflection_threshold() {
    if [[ -f "$CONFIG_FILE" ]]; then
        grep -oP '"reflection_threshold":\s*\K\d+' "$CONFIG_FILE" || echo "5"
    else
        echo "5"
    fi
}

get_changes_since_last_sync() {
    if [[ -f "$STATE_FILE" ]]; then
        grep -oP '"changes_since_sync":\s*\K\d+' "$STATE_FILE" || echo "0"
    else
        echo "0"
    fi
}

reset_sync_counter() {
    mkdir -p "$(dirname "$STATE_FILE")"
    echo '{"changes_since_sync": 0, "last_sync": "'$(date -Iseconds)'"}' > "$STATE_FILE"
}
