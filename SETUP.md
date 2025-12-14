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

Install in a test project:

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
# Test session summary
CLAUDE_SESSION_ID=test-123 \
CLAUDE_TRANSCRIPT_PATH=/path/to/transcript.txt \
./scripts/summarize-session.sh

# Test sync check
CLAUDE_PROJECT_DIR=/path/to/project \
./scripts/sync-claude-md.sh
```

## Publishing

### To Claude Plugin Marketplace

1. Ensure `plugin.json` is valid
2. Create release tag: `git tag v0.1.0 && git push origin v0.1.0`
3. Submit to marketplace (URL TBD)

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

## Next Steps

1. ✅ Repository created with full structure
2. 🔲 Add GitHub topics via UI or CLI
3. 🔲 Test plugin in real Claude Code environment
4. 🔲 Add usage examples and screenshots
5. 🔲 Set up CI/CD for validation
6. 🔲 Create issue templates
7. 🔲 Publish to plugin marketplace
8. 🔲 Share on social media and forums
