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

Required in `.mcp.json`:
- `MEM0_API_KEY`: Your Mem0 API key
- `MEM0_USER_ID`: (Optional) User identifier, defaults to "default"

## Commands

- `/mem0-capture [detail]`: Explicitly capture knowledge
- `/mem0-search [query]`: Search project memory
- `/mem0-sync`: Sync memories to CLAUDE.md
- `/mem0-reflect [n]`: Analyze last N sessions for patterns

## Hooks

- `SessionEnd`: Auto-captures session summary
- `PostToolUse`: Checks if sync needed after edits
- `Stop`: Quick capture on manual stop

## Development

The plugin maintains memory in two places:

1. **Mem0 (primary)**: Semantic, searchable, cross-session
2. **CLAUDE.md (derived)**: Key patterns synced for quick reference

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
