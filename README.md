# Claude Mem0 Project Memory Plugin

🧠 Intelligent long-term memory management for Claude Code using Mem0

## Features

- ✅ **Auto-Capture**: Automatically captures decisions, patterns, and learnings during coding sessions
- 🔍 **Semantic Search**: Find relevant context from past work using natural language
- 🔄 **Smart Sync**: Keeps your CLAUDE.md updated with important patterns
- 🎯 **Project-Scoped**: Memory is organized per-project with semantic tagging
- 🛠️ **Explicit Control**: Slash commands for manual memory management

## Installation

### Prerequisites

1. **Mem0 Account**: Sign up at [mem0.ai](https://mem0.ai) and get your API key
2. **Node.js**: Required for @mem0/mcp-server (or Python for mem0ai/mem0-mcp)

### Setup

1. Clone this repository:
```bash
git clone https://github.com/evgenygurin/claude-mem0-project-memory.git
cd claude-mem0-project-memory
```

2. Install as Claude Code plugin:
```bash
# Option 1: Via marketplace URL
# (if published)

# Option 2: Local install
cd /path/to/your/project
mkdir -p .claude/plugins
cp -r /path/to/claude-mem0-project-memory .claude/plugins/
```

3. Configure environment:
```bash
export MEM0_API_KEY="your-mem0-api-key"
export MEM0_USER_ID="your-user-id"  # optional
```

4. Enable in Claude Code:
```
/settings plugins
# Enable claude-mem0-project-memory
```

## Usage

### Automatic Mode

Once enabled, the plugin automatically:
- Captures session summaries on completion
- Tracks important decisions and patterns
- Syncs to CLAUDE.md when threshold is reached

### Manual Commands

```bash
# Capture specific insight
/mem0-capture We decided to use PostgreSQL for better JSONB support

# Search memory
/mem0-search database decisions
/mem0-search error handling patterns

# Force sync to CLAUDE.md
/mem0-sync

# Analyze recent sessions
/mem0-reflect 10
```

## Configuration

Edit `config/memory-config.json`:

```json
{
  "auto_capture": true,           // Auto-capture on session end
  "sync_to_claude_md": true,      // Auto-sync to CLAUDE.md
  "reflection_threshold": 5,      // Changes before auto-sync
  "memory_sections": {
    "decisions": true,
    "patterns": true,
    "constraints": true,
    "learnings": true
  }
}
```

## How It Works

### 1. Capture
Hooks listen to development sessions and extract:
- Architectural decisions
- Code patterns that worked
- Lessons learned from bugs
- Performance insights

### 2. Store
Knowledge is saved to Mem0 with:
- Semantic embeddings for search
- Project/component tags
- Metadata (timestamp, type, source)

### 3. Retrieve
When you need context:
- Semantic search finds relevant memories
- Auto-injection into new sessions (optional)
- Manual search via `/mem0-search`

### 4. Sync
Important patterns are synced to CLAUDE.md:
- Keeps project memory accessible
- Preserves manual guidelines
- Updates auto-generated sections only

## Project Memory Structure

```markdown
## Project Memory

### Manual Guidelines
<!-- manual -->
[Your hand-written rules - never auto-modified]
<!-- /manual -->

### Auto-Discovered Patterns
<!-- BEGIN AUTO-GENERATED FROM MEM0 -->
#### Architecture Decisions
- [2025-12-14] Using Result<T, E> for error handling [mem0:abc123]

#### Code Patterns  
- [2025-12-13] API routes follow /api/v1/{resource} structure [mem0:def456]
<!-- END AUTO-GENERATED FROM MEM0 -->
```

## Architecture

```
┌─────────────────┐
│  Claude Code    │
│   (your IDE)    │
└────────┬────────┘
         │
         ├──► Hooks (SessionEnd, PostToolUse)
         │
         ├──► Commands (/mem0-*)
         │
         ↓
┌─────────────────┐
│  MCP Server     │
│  (@mem0/mcp)    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Mem0 API      │
│  (cloud/self)   │
└─────────────────┘
```

## Roadmap

- [ ] Vector similarity threshold configuration
- [ ] Team memory sharing
- [ ] Memory pruning/archival strategies
- [ ] Integration with Linear/GitHub issues
- [ ] Memory analytics dashboard
- [ ] Conflict resolution for CLAUDE.md updates

## Contributing

Contributions welcome! Please:
1. Fork the repo
2. Create feature branch
3. Add tests if applicable
4. Submit PR with clear description

## License

MIT License - see [LICENSE](LICENSE) file

## Support

- **Issues**: [GitHub Issues](https://github.com/evgenygurin/claude-mem0-project-memory/issues)
- **Docs**: [CLAUDE.md](CLAUDE.md)
- **Mem0**: [docs.mem0.ai](https://docs.mem0.ai/)

## Credits

Built with:
- [Claude Code](https://claude.com/code) by Anthropic
- [Mem0](https://mem0.ai/) for long-term memory
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)
