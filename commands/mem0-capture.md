***
name: mem0-capture
description: Explicitly capture an important insight, decision, or pattern into Mem0 project memory
argument-hint: "[context] [detail]"
allowed-tools: ["MCP(mem0:*)", "Read", "Write"]
***

# Mem0 Memory Capture

You are capturing important project knowledge into long-term Mem0 storage.

## Process

1. **Parse input**: Extract from `$ARGUMENTS`:
   - What changed or was learned
   - Why it matters for this project
   - Relevant context (files, components, decisions)

2. **Prepare memory entry**:
   - Create concise summary (1-2 sentences)
   - Add metadata:
     - `project`: ${CLAUDE_PROJECT_DIR_NAME}
     - `timestamp`: current ISO timestamp
     - `type`: one of [decision, pattern, preference, constraint, learning]
     - `tags`: relevant keywords (language, framework, component names)
     - `source`: file paths or PR references if applicable

3. **Store in Mem0**:
   - Use MCP mem0 tool to add memory
   - Check for similar existing memories
   - If duplicate exists, update/merge instead of creating new

4. **Confirm**:
   - Print memory ID
   - Show summary of what was stored
   - Suggest related searches if relevant

## Example Usage

```
/mem0-capture We standardized error handling to always use Result<T, AppError> pattern for better type safety
/mem0-capture Authentication now uses JWT with 15min expiry and refresh tokens - decided after security review
```
