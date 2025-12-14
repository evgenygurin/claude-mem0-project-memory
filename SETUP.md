# Setup Instructions

## Adding GitHub Topics

To make the repository more discoverable, add the following topics:

### Via GitHub UI

1. Go to https://github.com/evgenygurin/claude-mem0-project-memory
2. Click the ⚙️ (gear) icon next to "About" in the top right
3. Add these topics:
   - `memory`
   - `claude-code`
   - `mem0`
   - `mcp`
   - `ai-memory`
   - `plugin`
   - `automation`
   - `semantic-search`
4. Click "Save changes"

### Via GitHub CLI

If you have GitHub CLI installed:

```bash
gh repo edit evgenygurin/claude-mem0-project-memory \
  --add-topic memory \
  --add-topic claude-code \
  --add-topic mem0 \
  --add-topic mcp \
  --add-topic ai-memory \
  --add-topic plugin \
  --add-topic automation \
  --add-topic semantic-search
```

### Via REST API

Using curl:

```bash
curl -X PUT \
  -H "Accept: application/vnd.github.mercy-preview+json" \
  -H "Authorization: Bearer YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/evgenygurin/claude-mem0-project-memory/topics \
  -d '{"names":["memory","claude-code","mem0","mcp","ai-memory","plugin","automation","semantic-search"]}'
```

## Initial Setup for Development

### 1. Clone the Repository

```bash
git clone https://github.com/evgenygurin/claude-mem0-project-memory.git
cd claude-mem0-project-memory
```

### 2. Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### 3. Set Up Environment Variables

Create a `.env` file (not committed to git):

```bash
MEM0_API_KEY=your_mem0_api_key_here
MEM0_USER_ID=your_user_id  # optional
```

### 4. Test Locally

**Option A: Via Local Marketplace (Recommended)**

```bash
# Create development marketplace structure (already done in ../claude-mem0-marketplace)
cd /path/to/claude-mem0-marketplace
# marketplace.json already configured

# In Claude Code:
/plugin marketplace add /path/to/claude-mem0-marketplace
/plugin install claude-mem0-project-memory@mem0-dev-marketplace
```

**Option B: Direct Installation**

```bash
cd /path/to/test/project
mkdir -p .claude/plugins
cp -r /path/to/claude-mem0-project-memory .claude/plugins/
```

### 5. Validate Configuration

Check that all required files exist:

```bash
# From plugin root
ls -la .claude-plugin/plugin.json
ls -la .mcp.json
ls -la hooks/hooks.json
ls -la config/memory-config.json
ls -la commands/*.md
ls -la scripts/*.sh
```

## Testing the Plugin

### Manual Testing

1. Open Claude Code in your test project
2. Enable the plugin: `/settings plugins`
3. Try commands:
   ```
   /mem0-capture Test memory capture
   /mem0-search test
   /mem0-sync
   ```

### Hook Testing

Trigger hooks manually:

```bash
# Test session initialization
CLAUDE_PLUGIN_ROOT=/path/to/plugin \
CLAUDE_PROJECT_DIR=/path/to/project \
./scripts/init-session.sh /path/to/project

# Test change tracking
CLAUDE_PLUGIN_ROOT=/path/to/plugin \
CLAUDE_PROJECT_DIR=/path/to/project \
./scripts/track-change.sh /path/to/project

# Test session summary
CLAUDE_PLUGIN_ROOT=/path/to/plugin \
CLAUDE_PROJECT_DIR=/path/to/project \
./scripts/summarize-session.sh /path/to/project
```

## Publishing

### To Claude Plugin Marketplace

1. Ensure all files are valid:
   ```bash
   jq empty .claude-plugin/plugin.json
   jq empty hooks/hooks.json
   jq empty config/memory-config.json
   jq empty .mcp.json
   bash -n scripts/*.sh
   ```
2. Create release tag: `git tag v0.2.0 && git push origin v0.2.0`
3. Submit to marketplace following [official guidelines](https://code.claude.com/docs/en/plugin-marketplaces)

### To Smithery (MCP Registry)

If publishing the MCP server component:

```bash
# Follow Smithery submission guidelines
# https://smithery.ai/submit
```

## Continuous Integration

### TODO: Add CI/CD

Create `.github/workflows/validate.yml`:

```yaml
name: Validate Plugin

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate plugin.json
        run: |
          jq empty .claude-plugin/plugin.json
          jq empty .mcp.json
          jq empty hooks/hooks.json
          jq empty config/memory-config.json
      - name: Check scripts
        run: |
          bash -n scripts/*.sh
      - name: Validate markdown
        uses: articulate/actions-markdown-lint@v1
```

## Documentation Updates

### Adding Examples

Create `examples/` directory with:
- Example CLAUDE.md with memory sections
- Sample memory entries
- Usage scenarios

### Screenshots

Add to `docs/images/`:
- Command usage
- CLAUDE.md structure
- Memory search results

## Support Channels

- **Issues**: [GitHub Issues](https://github.com/evgenygurin/claude-mem0-project-memory/issues)
- **Discussions**: Enable GitHub Discussions for Q&A
- **Discord**: Consider creating community server

## Environment Variables Reference

### Official Claude Code Variables (Used by Plugin)
- `CLAUDE_PLUGIN_ROOT` - Absolute path to plugin directory (set by Claude Code)
- `CLAUDE_PROJECT_DIR` - Absolute path to project root (set by Claude Code)

### Plugin-Specific Variables (Set by User)
- `MEM0_API_KEY` - Your Mem0 API key (required)
- `MEM0_USER_ID` - User identifier for Mem0 (optional, defaults to project name)
- `DEBUG` - Set to "1" for verbose logging (optional)

### Variables NOT Used (Removed in v0.2.0)
- ❌ `CLAUDE_SESSION_ID` - Not officially documented, removed
- ❌ `CLAUDE_TRANSCRIPT_PATH` - Not officially documented, removed

## Compliance Checklist

Before publishing, ensure:

- [x] Plugin manifest contains only metadata
- [x] Hooks use only official environment variables
- [x] All scripts have input validation
- [x] All scripts have proper error handling
- [x] Commands have complete frontmatter
- [x] JSON files are valid
- [x] Bash scripts have valid syntax
- [x] All scripts are executable
- [x] Documentation is up-to-date
- [x] Follows [official plugin specifications](https://code.claude.com/docs/en/plugins)

## Next Steps

1. ✅ Repository created with full structure
2. ✅ Full refactoring for Claude Code compliance (v0.2.0)
3. 🔲 Add GitHub topics via UI or CLI
4. 🔲 Test plugin in real Claude Code environment with local marketplace
5. 🔲 Add usage examples and screenshots
6. 🔲 Set up CI/CD for validation
7. 🔲 Create issue templates
8. 🔲 Publish to official plugin marketplace
9. 🔲 Share on social media and forums
