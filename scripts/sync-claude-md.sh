#!/usr/bin/env bash
# DEPRECATED: This script is replaced by track-change.sh
# Kept for backward compatibility

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

log_warn "sync-claude-md.sh is deprecated. Use track-change.sh instead."
exit 0
