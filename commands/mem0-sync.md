***
name: mem0-sync
description: Sync important patterns from Mem0 back into project CLAUDE.md
argument-hint: "[section] (optional)"
allowed-tools: ["MCP(mem0:*)", "Read", "Write"]
***

# Mem0 to CLAUDE.md Sync

Synchronize key patterns and decisions from Mem0 into project CLAUDE.md.

## Process

1. **Read current CLAUDE.md**:
   - Locate or create "## Project Memory" section
   - Preserve existing content marked with `<!-- manual -->` tags

2. **Query Mem0**:
   - Get high-priority memories for ${CLAUDE_PROJECT_DIR_NAME}
   - Filter by type: decisions, patterns, constraints
   - Sort by importance/recency

3. **Generate updates**:
   - Format as concise bullet points
   - Group by category
   - Add metadata (last updated date)
   - Deduplicate with existing content

4. **Write back**:
   - Update auto-generated section in CLAUDE.md
   - Preserve manual entries
   - Use markers:
     ```markdown
     <!-- BEGIN AUTO-GENERATED FROM MEM0 -->
     ...
     <!-- END AUTO-GENERATED FROM MEM0 -->
     ```

5. **Report**:
   - Show what was added/updated
   - Confirm successful sync

## CLAUDE.md Structure

The plugin maintains this structure:

```markdown
## Project Memory

### Manual Guidelines
<!-- manual -->
[User-written rules that should never be auto-modified]
<!-- /manual -->

### Auto-Discovered Patterns
<!-- BEGIN AUTO-GENERATED FROM MEM0 -->
**Last synced**: 2025-12-14

#### Architecture Decisions
- [date] Decision detail [mem0:id]

#### Code Patterns
- [date] Pattern detail [mem0:id]

#### Constraints
- [date] Constraint detail [mem0:id]
<!-- END AUTO-GENERATED FROM MEM0 -->
```
