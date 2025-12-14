***
name: mem0-search
description: Search project memory in Mem0 for relevant context, decisions, or patterns
argument-hint: "[search query]"
allowed-tools: ["MCP(mem0:*)"]
***

# Mem0 Memory Search

Search long-term project memory for relevant information.

## Process

1. **Parse query**: Extract search intent from `$ARGUMENTS`
   - Technical terms, component names
   - Problem domain or feature area
   - Time frame if mentioned

2. **Query Mem0**:
   - Use semantic search via MCP mem0 tool
   - Filter by project: ${CLAUDE_PROJECT_DIR_NAME}
   - Retrieve top 5-10 most relevant memories

3. **Present results**:
   - Group by type (decisions, patterns, constraints)
   - Show relevance score if available
   - Include metadata (date, tags, source)
   - Format for readability

4. **Actionable output**:
   - Suggest applying relevant patterns
   - Highlight any conflicts with current approach
   - Offer to update memory if outdated

## Example Usage

```
/mem0-search error handling patterns
/mem0-search authentication decisions
/mem0-search database migration approach
```
