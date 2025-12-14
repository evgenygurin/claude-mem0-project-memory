---
name: mem0-capture
description: Explicitly capture an important insight, decision, or pattern into Mem0 project memory. Use this command to permanently store key learnings, architectural decisions, patterns, or constraints that should be remembered across sessions.
argument-hint: "[insight, decision, or pattern to remember]"
allowed-tools:
  - MCP(mem0:*)
  - Read
---

# Mem0 Memory Capture

You are capturing important project knowledge into long-term Mem0 storage.

## When to Use

- User explicitly asks to remember something
- After making an important architectural decision
- When establishing a new pattern or best practice
- After solving a complex problem that should be documented

## Process

### 1. Parse Input

From `$ARGUMENTS`, extract:
- **What** changed or was learned
- **Why** it matters for this project
- **Context**: files, components, or decisions involved

### 2. Prepare Memory Entry

Create a concise summary (1-2 sentences) with metadata:

```json
{
  "content": "Clear description of the insight",
  "metadata": {
    "project": "<project name from basename of CLAUDE_PROJECT_DIR>",
    "timestamp": "<ISO 8601 timestamp>",
    "type": "decision|pattern|constraint|learning",
    "tags": ["relevant", "keywords"],
    "source": "file paths or references"
  }
}
```

**Note:** Extract project name using the last component of `${CLAUDE_PROJECT_DIR}` path.

### 3. Store in Mem0

- Use MCP `mcp__mem0__add_memory` tool to add the memory
- Use `mcp__mem0__search_memory` to check for similar existing memories first
- If a duplicate exists, ask user if they want to update or create separate
- Use the project name (from `basename ${CLAUDE_PROJECT_DIR}`) as the user_id for scoping

### 4. Confirm

Respond to the user with:
- Confirmation that memory was stored
- Brief summary of what was captured
- Memory ID for reference
- Suggestion to search related memories if relevant

## Examples

**User:** 
```
/mem0-capture We standardized error handling to always use Result<T, AppError> pattern for better type safety
```

**You should:**
1. Create memory with type="pattern"
2. Tag with: error-handling, rust, type-safety
3. Link to relevant files if discussed
4. Confirm: "✅ Captured error handling pattern to project memory [mem0:abc123]"

**User:**
```
/mem0-capture Authentication now uses JWT with 15min expiry - security team requirement
```

**You should:**
1. Create memory with type="decision"
2. Tag with: auth, jwt, security
3. Note the constraint (security requirement)
4. Confirm with decision rationale

## Edge Cases

- If input is too vague, ask for clarification
- If similar memory exists, ask if they want to update or create separate
- If Mem0 connection fails, save to local .claude/memory-backup.json
