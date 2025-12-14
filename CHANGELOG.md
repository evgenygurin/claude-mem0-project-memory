# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-12-14

### Added
- **Official Specification Compliance**: Fully aligned with Claude Code official docs
- **Agent Skill**: `recall-project-memory` for automatic context retrieval
- **SessionStart Hook**: Initialize plugin environment at session start
- **Enhanced Hooks**: Proper matcher patterns and JSON I/O per spec
- **Change Tracking**: Incremental counter with threshold-based notifications
- **JSON Output**: Hooks now output proper JSON for Claude consumption
- **System Messages**: User-visible notifications from hooks

### Changed
- **Hook Structure**: Updated to official spec format with `matcher` field
- **Commands**: Migrated from `***` to `---` YAML frontmatter
- **Scripts**: Enhanced with proper exit codes and JSON output
- **Configuration**: Added new sections for skills and hooks
- **Utils**: Added jq-based JSON parsing utilities

### Fixed
- **Hook Event Names**: Corrected to official names (SessionStart, SessionEnd, etc.)
- **Tool Matchers**: Proper regex patterns for tool filtering
- **Script Permissions**: All scripts properly marked as executable

### Deprecated
- `sync-claude-md.sh`: Replaced by `track-change.sh`

## [0.1.0] - 2025-12-14

### Added
- Initial plugin structure
- Basic commands: capture, search, sync, reflect
- Hook-based automation
- MCP integration with Mem0
- Documentation and examples
