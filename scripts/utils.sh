#!/usr/bin/env bash
# Utility functions for Mem0 plugin

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_CONFIG_ERROR=1
readonly EXIT_DEPENDENCY_ERROR=2
readonly EXIT_VALIDATION_ERROR=3
readonly EXIT_MEM0_ERROR=4

# Get config file path
get_config_file() {
    echo "${CLAUDE_PLUGIN_ROOT:-$PWD}/config/memory-config.json"
}

# Logging functions
log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] INFO: $*" >&2
}

log_warn() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] WARN: $*" >&2
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] ERROR: $*" >&2
}

log_debug() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] [mem0-plugin] DEBUG: $*" >&2
    fi
}

# Dependency checks
require_jq() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed. Install it with: brew install jq (macOS) or apt-get install jq (Linux)"
        return ${EXIT_DEPENDENCY_ERROR}
    fi
    return ${EXIT_SUCCESS}
}

require_curl() {
    if ! command -v curl &> /dev/null; then
        log_error "curl is required but not installed"
        return ${EXIT_DEPENDENCY_ERROR}
    fi
    return ${EXIT_SUCCESS}
}

# Environment validation
validate_plugin_env() {
    if [[ -z "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
        log_error "CLAUDE_PLUGIN_ROOT is not set"
        return ${EXIT_VALIDATION_ERROR}
    fi
    
    if [[ ! -d "${CLAUDE_PLUGIN_ROOT}" ]]; then
        log_error "CLAUDE_PLUGIN_ROOT directory does not exist: ${CLAUDE_PLUGIN_ROOT}"
        return ${EXIT_VALIDATION_ERROR}
    fi
    
    return ${EXIT_SUCCESS}
}

validate_project_dir() {
    local project_dir="${1:-${CLAUDE_PROJECT_DIR}}"
    
    if [[ -z "${project_dir}" ]]; then
        log_error "Project directory not provided and CLAUDE_PROJECT_DIR is not set"
        return ${EXIT_VALIDATION_ERROR}
    fi
    
    if [[ ! -d "${project_dir}" ]]; then
        log_error "Project directory does not exist: ${project_dir}"
        return ${EXIT_VALIDATION_ERROR}
    fi
    
    return ${EXIT_SUCCESS}
}

# Config reading functions
read_config() {
    local key="${1}"
    local default="${2:-}"
    local config_file=$(get_config_file)
    
    if [[ ! -f "${config_file}" ]]; then
        echo "${default}"
        return ${EXIT_SUCCESS}
    fi
    
    if ! require_jq; then
        echo "${default}"
        return ${EXIT_DEPENDENCY_ERROR}
    fi
    
    local value=$(jq -r ".${key} // \"${default}\"" "${config_file}" 2>/dev/null)
    echo "${value}"
}

is_auto_capture_enabled() {
    local enabled=$(read_config "auto_capture" "true")
    [[ "${enabled}" == "true" ]]
}

is_sync_enabled() {
    local enabled=$(read_config "sync_to_claude_md" "true")
    [[ "${enabled}" == "true" ]]
}

is_auto_load_context_enabled() {
    local enabled=$(read_config "auto_load_context" "false")
    [[ "${enabled}" == "true" ]]
}

get_reflection_threshold() {
    read_config "reflection_threshold" "5"
}

# Session state management
get_session_state_dir() {
    echo "${HOME}/.claude/plugins/mem0/sessions"
}

ensure_session_state_dir() {
    local state_dir=$(get_session_state_dir)
    if [[ ! -d "${state_dir}" ]]; then
        mkdir -p "${state_dir}" || {
            log_error "Failed to create session state directory: ${state_dir}"
            return ${EXIT_VALIDATION_ERROR}
        }
    fi
    return ${EXIT_SUCCESS}
}

get_session_state_file() {
    local project_dir="${1:-${CLAUDE_PROJECT_DIR}}"
    local project_name=$(basename "${project_dir}")
    echo "$(get_session_state_dir)/${project_name}-state.json"
}

init_session_state() {
    local state_file="${1}"
    
    if [[ ! -f "${state_file}" ]]; then
        echo '{"changes_count": 0, "started_at": "'$(date -Iseconds)'", "last_sync": null}' > "${state_file}" || {
            log_error "Failed to initialize session state file: ${state_file}"
            return ${EXIT_VALIDATION_ERROR}
        }
    fi
    
    return ${EXIT_SUCCESS}
}

get_changes_count() {
    local state_file="${1}"
    
    if [[ ! -f "${state_file}" ]] || ! require_jq; then
        echo "0"
        return ${EXIT_SUCCESS}
    fi
    
    jq -r '.changes_count // 0' "${state_file}" 2>/dev/null || echo "0"
}

increment_changes_count() {
    local state_file="${1}"
    
    if [[ ! -f "${state_file}" ]]; then
        init_session_state "${state_file}"
    fi
    
    if ! require_jq; then
        return ${EXIT_DEPENDENCY_ERROR}
    fi
    
    local tmp_file="${state_file}.tmp"
    jq '.changes_count = (.changes_count // 0) + 1' "${state_file}" > "${tmp_file}" && \
        mv "${tmp_file}" "${state_file}" || {
        log_error "Failed to increment changes count"
        rm -f "${tmp_file}"
        return ${EXIT_VALIDATION_ERROR}
    }
    
    return ${EXIT_SUCCESS}
}

reset_changes_count() {
    local state_file="${1}"
    
    if [[ ! -f "${state_file}" ]] || ! require_jq; then
        return ${EXIT_SUCCESS}
    fi
    
    local tmp_file="${state_file}.tmp"
    jq '.changes_count = 0 | .last_sync = "'$(date -Iseconds)'"' "${state_file}" > "${tmp_file}" && \
        mv "${tmp_file}" "${state_file}" || {
        log_error "Failed to reset changes count"
        rm -f "${tmp_file}"
        return ${EXIT_VALIDATION_ERROR}
    }
    
    return ${EXIT_SUCCESS}
}

# JSON output for hooks
output_json() {
    local json="${1}"
    echo "${json}"
}

output_system_message() {
    local message="${1}"
    output_json "{\"systemMessage\": \"${message}\"}"
}

output_error() {
    local message="${1}"
    output_json "{\"error\": \"${message}\"}"
}

# Mem0 API check (optional)
check_mem0_connectivity() {
    if [[ -z "${MEM0_API_KEY:-}" ]]; then
        log_warn "MEM0_API_KEY is not set, Mem0 features may not work"
        return ${EXIT_CONFIG_ERROR}
    fi

    # Basic API check could be added here
    return ${EXIT_SUCCESS}
}

# Add memory to Mem0 via direct API call
# Usage: add_memory_to_mem0 "content" "user_id" ["metadata_json"]
# Returns: memory_id on success, empty on failure
add_memory_to_mem0() {
    local content="${1}"
    local user_id="${2:-${CLAUDE_PROJECT_DIR_NAME:-default}}"
    local metadata="${3:-{}}"

    # Validate dependencies
    if ! require_curl || ! require_jq; then
        log_error "curl and jq are required for Mem0 API calls"
        return ${EXIT_DEPENDENCY_ERROR}
    fi

    # Check API key
    if [[ -z "${MEM0_API_KEY:-}" ]]; then
        log_error "MEM0_API_KEY is not set"
        return ${EXIT_CONFIG_ERROR}
    fi

    # Escape content for JSON
    local escaped_content=$(echo "${content}" | jq -Rs .)

    # Prepare request body
    local request_body=$(jq -n \
        --arg user_id "${user_id}" \
        --argjson content "${escaped_content}" \
        --argjson metadata "${metadata}" \
        '{
            messages: [{role: "user", content: $content}],
            user_id: $user_id,
            metadata: $metadata,
            infer: true
        }')

    log_debug "Mem0 API request: ${request_body}"

    # Make API call
    local response=$(curl -sf \
        -X POST \
        -H "Authorization: Token ${MEM0_API_KEY}" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d "${request_body}" \
        "https://api.mem0.ai/v1/memories/" 2>&1)

    local curl_exit_code=$?

    if [[ ${curl_exit_code} -ne 0 ]]; then
        log_error "Mem0 API call failed (curl exit code: ${curl_exit_code})"
        log_debug "Response: ${response}"
        return ${EXIT_MEM0_ERROR}
    fi

    # Extract memory ID from response
    local memory_id=$(echo "${response}" | jq -r '.[0].id // empty' 2>/dev/null)

    if [[ -z "${memory_id}" ]]; then
        log_error "Failed to extract memory ID from Mem0 response"
        log_debug "Response: ${response}"
        return ${EXIT_MEM0_ERROR}
    fi

    log_info "Memory added to Mem0: ${memory_id}"
    echo "${memory_id}"
    return ${EXIT_SUCCESS}
}

# Check if auto-add to Mem0 is enabled
is_auto_add_enabled() {
    local enabled=$(read_config "auto_add_to_mem0" "true")
    [[ "${enabled}" == "true" ]]
}
