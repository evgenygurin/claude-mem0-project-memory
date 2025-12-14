# Changelog

All notable changes to the Claude Mem0 Project Memory plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- LLM-powered session transcript analysis  
- Team memory sharing across projects
- Memory analytics and insights dashboard
- Integration with GitHub Issues / Linear
- Advanced conflict resolution for CLAUDE.md updates
- Memory versioning and diff visualization

## [0.2.0] - 2025-12-14

### Changed
- **BREAKING**: Plugin manifest now contains only metadata (removed `hooks` and `config` sections)
- **BREAKING**: Scripts now use only official Claude Code environment variables
- **BREAKING**: Session state tracking changed from session-based to project-based
- Refactored all bash scripts for compliance with official plugin standards
- Updated hooks to use only documented environment variables (`CLAUDE_PLUGIN_ROOT`, `CLAUDE_PROJECT_DIR`)
- Enhanced command descriptions with detailed use cases
- Improved error handling in all scripts with proper exit codes

### Added
- Comprehensive input validation in all scripts
- Proper exit code definitions (SUCCESS, CONFIG_ERROR, DEPENDENCY_ERROR, VALIDATION_ERROR)
- Environment validation functions (`validate_plugin_env`, `validate_project_dir`)
- Dependency checks with helpful installation instructions
- Project-based state management functions
- Debug logging support (enable with `DEBUG=1`)
- Local testing marketplace (`claude-mem0-marketplace`)
- REFACTORING_SUMMARY.md with detailed compliance documentation
- Enhanced command frontmatter with comprehensive descriptions

### Improved
- Error messages are now more descriptive and actionable
- Scripts now gracefully degrade when optional dependencies are missing
- Better logging consistency across all scripts
- Atomic file operations with proper temp file handling
- Security: Input validation prevents path traversal and injection attacks
- Agent Skill structure and documentation
- Hook configurations with proper timeouts and throttling

### Fixed
- Removed usage of undocumented `${CLAUDE_SESSION_ID}` environment variable
- Removed usage of undocumented `${CLAUDE_TRANSCRIPT_PATH}` environment variable
- Fixed hook argument passing to use only available variables
- Fixed state tracking to persist across sessions properly
- Corrected `allowed-tools` lists in command frontmatter
- Plugin.json now properly structured per official specification

### Removed
- `sync-claude-md.sh` script (redundant/deprecated functionality)
- Non-standard environment variable references
- Duplicate configuration in `plugin.json`
- Hook reference from plugin manifest (moved to hooks/hooks.json where it belongs)

### Documentation
- Updated README with accurate installation and usage instructions
- Enhanced command frontmatter with detailed descriptions and examples
- Added comprehensive refactoring documentation (REFACTORING_SUMMARY.md)
- Updated all documentation to reflect official Claude Code standards
- Clarified environment variable requirements

## [0.1.0] - 2025-12-14

### Added
- Initial plugin structure
- Basic commands: `/mem0-capture`, `/mem0-search`, `/mem0-sync`, `/mem0-reflect`
- Session hooks: SessionStart, SessionEnd, PostToolUse, Stop
- Agent skill for automatic memory recall (`recall-project-memory`)
- MCP integration with Mem0 API via `@mem0/mcp-server`
- Auto-capture of decisions and patterns
- Threshold-based sync notifications
- Project-scoped memory management
- Configuration system (`memory-config.json`)
- Documentation: README, SETUP, CLAUDE.md
- Hook-based automation for memory capture
- Change tracking with counters
- System message output for user notifications

### Notes
- First public release
- Requires Mem0 API key from mem0.ai
- Dependencies: Node.js (for MCP server), jq, curl
- Not fully compliant with official Claude Code plugin specifications (fixed in v0.2.0)
- Used undocumented environment variables (corrected in v0.2.0)

---

**Migration Guide v0.1.0 → v0.2.0**:
- No action required for most users
- Session state now tracked per-project instead of per-session (transparent change)
- If you encounter issues, try reinstalling the plugin
- Configuration file format remains unchanged
- All commands and features work identically
