# Claude Mem0 Project Memory Plugin

🧠 Intelligent long-term memory management for Claude Code using Mem0

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-blue)](https://code.claude.com)
[![Mem0](https://img.shields.io/badge/Mem0-Powered-purple)](https://mem0.ai)

## Features

- ✅ **Auto-Capture**: Automatically captures decisions, patterns, and learnings during coding sessions
- 🔍 **Semantic Search**: Find relevant context from past work using natural language
- 🔄 **Smart Sync**: Keeps your CLAUDE.md updated with important patterns
- 🎯 **Project-Scoped**: Memory is organized per-project with semantic tagging
- 🧠 **Agent Skill**: Claude automatically recalls relevant memories when needed
- 🛠️ **Explicit Control**: Slash commands for manual memory management
- 🪝 **Hook-Based**: Automated workflows via SessionStart, SessionEnd, and PostToolUse hooks

## Installation

### Prerequisites

1. **Mem0 Account**: Sign up at [mem0.ai](https://mem0.ai) and get your API key
2. **Node.js**: Required for `@mem0/mcp-server` 
3. **jq**: For JSON processing in hooks (`brew install jq` / `apt install jq`)

### Setup

#### 1. Clone this repository

```bash
git clone https://github.com/evgenygurin/claude-mem0-project-memory.git
cd claude-mem0-project-memory
```

#### 2. Make scripts executable

```bash
chmod +x scripts/*.sh
```

#### 3. Install in your project

```bash
cd /path/to/your/project
mkdir -p .claude/plugins
cp -r /path/to/claude-mem0-project-memory .claude/plugins/
```

#### 4. Configure environment

Add to your shell profile or `.env`:

```bash
export MEM0_API_KEY="your-mem0-api-key"
export MEM0_USER_ID="your-user-id"  # optional, defaults to project name
```

#### 5. Enable in Claude Code

```
/settings plugins
# Enable claude-mem0-project-memory
```

## Usage

### 🤖 Automatic Mode

Once enabled, the plugin automatically:

1. **Initializes** at session start
2. **Tracks changes** as you edit code
3. **Recalls memories** when relevant context exists (via agent skill)
4. **Captures insights** at session end
5. **Notifies** when sync threshold is reached

### 📝 Manual Commands

#### Capture Memory
```bash
/mem0-capture We standardized error handling to always use Result<T, AppError> pattern
```

#### Search Memory
```bash
/mem0-search error handling patterns
/mem0-search database migration decisions
```

#### Sync to CLAUDE.md
```bash
/mem0-sync              # Sync all memories
/mem0-sync decisions    # Sync only decisions
```

#### Reflect on Sessions
```bash
/mem0-reflect           # Analyze last 5 sessions
/mem0-reflect 10        # Analyze last 10 sessions
```

## Configuration

Edit `.claude/plugins/claude-mem0-project-memory/config/memory-config.json`:

```json
{
  "auto_capture": true,           // Capture at session end
  "sync_to_claude_md": true,      // Auto-sync to CLAUDE.md
  "auto_load_context": false,     // Load memories at session start
  "reflection_threshold": 5,      // Changes before suggesting sync
  
  "skill_settings": {
    "auto_recall_enabled": true,  // Enable automatic memory recall
    "recall_threshold": 0.75,     // Minimum relevance for auto-recall
    "max_context_memories": 5     // Max memories to load per recall
  },
  
  "hook_settings": {
    "session_start_init": true,   // Initialize at session start
    "track_tool_usage": true,     // Track Write/Edit events
    "log_mem0_calls": false,      // Debug logging (verbose)
    "min_changes_for_capture": 3  // Minimum edits before capture
  }
}
```

## Architecture

```
┌───────────────────────────┐
│     Claude Code Agent      │
│   (with Sonnet 4.5)       │
└───────────┬────────────────┘
            │
            ├─── Skills (automatic)
            │    └── recall-project-memory
            │
            ├─── Commands (user-invoked)
            │    ├── /mem0-capture
            │    ├── /mem0-search
            │    ├── /mem0-sync
            │    └── /mem0-reflect
            │
            ├─── Hooks (event-driven)
            │    ├── SessionStart
            │    ├── SessionEnd
            │    ├── PostToolUse (Write|Edit)
            │    └── Stop
            │
            ↓
┌───────────────────────────┐
│      MCP Server              │
│    (@mem0/mcp-server)       │
└───────────┬────────────────┘
            │
            ↓
┌───────────────────────────┐
│   Mem0 API (Cloud/Self)    │
│  Long-term Semantic Memory │
└───────────────────────────┘
```

## How It Works

### 1. 🎯 Capture

**Automatic**:
- SessionEnd hook analyzes transcript
- Extracts decisions, patterns, errors, solutions
- Stores significant insights to Mem0

**Manual**:
- Use `/mem0-capture` to explicitly save important context

### 2. 💾 Store

Memories stored with:
- **Semantic embeddings** for similarity search
- **Project scope** (user_id = project name)
- **Rich metadata**: type, tags, timestamp, source
- **Memory types**: decision, pattern, constraint, learning

### 3. 🔍 Retrieve

**Automatic (Agent Skill)**:
- Claude detects when task might benefit from memory
- Automatically searches Mem0
- Applies relevant patterns/constraints
- Maintains consistency with past decisions

**Manual**:
- `/mem0-search <query>` for explicit searches
- Returns grouped, relevance-scored results

### 4. 🔄 Sync

Important patterns synced to CLAUDE.md:
- Auto-generated section updated periodically
- Manual guidelines preserved
- Threshold-based notifications
- Traceable with memory IDs

## Project Memory Structure

In your `CLAUDE.md`:

```markdown
## Project Memory

### Manual Guidelines
<!-- manual -->
[Your hand-written rules - never auto-modified]
<!-- /manual -->

### Auto-Discovered Patterns
<!-- BEGIN AUTO-GENERATED FROM MEM0 - Last synced: 2025-12-14 -->

#### Architecture Decisions
- **[2025-12-14]** Using Result<T, E> for error handling [[mem0:abc123]]
- **[2025-12-10]** PostgreSQL chosen for JSONB support [[mem0:def456]]

#### Code Patterns  
- **[2025-12-13]** API routes follow /api/v1/{resource} structure [[mem0:ghi789]]
- **[2025-12-11]** Builder pattern for complex configs [[mem0:jkl012]]

#### Constraints
- **[2025-12-12]** JWT tokens: 15min expiry (security requirement) [[mem0:mno345]]

#### Key Learnings
- **[2025-12-09]** Database indexes critical for query performance [[mem0:pqr678]]

<!-- END AUTO-GENERATED FROM MEM0 -->
```

## Roadmap

- [ ] **v0.3**: LLM-powered transcript summarization (vs simple heuristics)
- [ ] **v0.4**: Team memory sharing across projects
- [ ] **v0.5**: Memory analytics dashboard
- [ ] **v0.6**: Integration with Linear/GitHub issues
- [ ] **v0.7**: Smart memory pruning and archival
- [ ] **v0.8**: Conflict resolution for CLAUDE.md updates
- [ ] **v0.9**: Memory versioning and diff visualization
- [ ] **v1.0**: Production-ready with comprehensive tests

## Contributing

Contributions welcome! Please:

1. Fork the repo
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the official Claude Code plugin spec
4. Add tests if applicable
5. Update documentation
6. Submit PR with clear description

## License

MIT License - see [LICENSE](LICENSE) file

## Support

- **Issues**: [GitHub Issues](https://github.com/evgenygurin/claude-mem0-project-memory/issues)
- **Docs**: [SETUP.md](SETUP.md), [CHANGELOG.md](CHANGELOG.md)
- **Claude Code**: [docs.code.claude.com](https://code.claude.com/docs)
- **Mem0**: [docs.mem0.ai](https://docs.mem0.ai/)

## Credits

Built with:
- [Claude Code](https://claude.com/code) by Anthropic
- [Mem0](https://mem0.ai/) for long-term semantic memory
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)

---

**Made with ❤️ by [@evgenygurin](https://github.com/evgenygurin)**
