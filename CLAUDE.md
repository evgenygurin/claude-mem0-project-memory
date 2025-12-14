# Claude Mem0 Project Memory Plugin

This plugin provides intelligent long-term memory management for Claude Code projects using Mem0.

## Architecture

- **MCP Integration**: Connects to Mem0 via Model Context Protocol
- **Auto-Capture**: Hooks capture important decisions and patterns automatically
- **Sync**: Periodically syncs key memories back into project CLAUDE.md
- **Commands**: Explicit memory management via slash commands

## Configuration

Edit `config/memory-config.json` to customize:

- `auto_capture`: Enable/disable automatic memory capture
- `sync_to_claude_md`: Enable/disable CLAUDE.md synchronization
- `reflection_threshold`: Number of changes before auto-sync triggers

## Environment Variables

**Available in hooks and commands:**
- `${CLAUDE_PLUGIN_ROOT}`: Plugin directory absolute path (use in hooks)
- `${CLAUDE_PROJECT_DIR}`: Project root directory absolute path
- `$ARGUMENTS`: Arguments passed to slash commands

**Required in `.mcp.json`:**
- `MEM0_API_KEY`: Your Mem0 API key
- `MEM0_USER_ID`: (Optional) User identifier, defaults to project name

**Deprecated (removed in v0.2.0):**
- ~~`${CLAUDE_SESSION_ID}`~~ - Not guaranteed by spec
- ~~`${CLAUDE_TRANSCRIPT_PATH}`~~ - Not guaranteed by spec
- Use git history and project state instead

## Commands

- `/mem0-capture [detail]`: Explicitly capture knowledge
- `/mem0-search [query]`: Search project memory
- `/mem0-sync`: Sync memories to CLAUDE.md
- `/mem0-reflect [days]`: Analyze last N days of git commits for patterns (default: 7)

## Hooks

- `SessionEnd`: Auto-captures session summary
- `PostToolUse`: Checks if sync needed after edits
- `Stop`: Quick capture on manual stop

## Development

### Memory Architecture

The plugin maintains memory in two places:

1. **Mem0 (primary)**: Semantic, searchable, cross-session
2. **CLAUDE.md (derived)**: Key patterns synced for quick reference

### Commands Implementation

Commands analyze **git history** and **project files**, NOT session transcripts:
- Use `git log --since="N days ago"` for reflection
- Use `git diff` and `git show` for detailed analysis
- Project state stored in `~/.claude/plugins/mem0/sessions/<project>-state.json`
- All commands use MCP tools: `mcp__mem0__add_memory`, `mcp__mem0__search_memory`

### Hooks Implementation

Hooks use bash scripts in `scripts/` directory:
- `init-session.sh`: Initialize session state
- `summarize-session.sh`: Capture summary via Mem0 API (direct curl)
- `track-change.sh`: Increment changes counter
- `utils.sh`: Shared functions for API calls and state management

Auto-generated sections in CLAUDE.md are marked with:

```markdown
<!-- BEGIN AUTO-GENERATED FROM MEM0 -->
...
<!-- END AUTO-GENERATED FROM MEM0 -->
```

Manual guidelines should be wrapped in:

```markdown
<!-- manual -->
...
<!-- /manual -->
```
