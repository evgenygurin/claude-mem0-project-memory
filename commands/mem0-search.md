---
name: mem0-search
description: Search project memory for relevant context, decisions, patterns, or past solutions using semantic search. Helps you find what was done before and why, avoiding repeated mistakes and maintaining consistency.
argument-hint: "[search query - e.g., 'error handling patterns', 'database decisions']"
allowed-tools:
  - MCP(mem0:*)
---

# Mem0 Memory Search

Search long-term project memory for relevant information using semantic search.

## When to Use

- User asks "how did we handle X?"
- Before making a decision, check for past decisions
- When stuck on a problem, find similar past solutions
- To verify current approach aligns with established patterns

## Process

### 1. Parse Query

From `$ARGUMENTS`, identify:
- **Technical terms**: component names, technologies, patterns
- **Problem domain**: what area/feature is this about?
- **Time context**: recent vs. historical (if mentioned)

### 2. Query Mem0

- Use semantic search via MCP `mem0` tool
- Filter by `project: ${CLAUDE_PROJECT_DIR_NAME}`
- Retrieve top 5-10 most relevant memories
- Set relevance threshold (default: 0.7)

### 3. Present Results

Group results by type:

#### 📝 Decisions
- [Date] Description [mem0:id]

#### 🔧 Patterns
- [Date] Description [mem0:id]

#### ⚠️ Constraints
- [Date] Description [mem0:id]

#### 💡 Learnings
- [Date] Description [mem0:id]

For each result:
- Show relevance score if available
- Include key metadata (tags, source files)
- Format clearly for readability

### 4. Actionable Output

- **Suggest applying** relevant patterns to current task
- **Highlight conflicts** with current approach
- **Offer to update** if memories seem outdated
- **Provide links** to source files/PRs if available

## Examples

**User:**
```
/mem0-search error handling patterns
```

**You should:**
1. Search for memories tagged with "error-handling", "patterns"
2. Display grouped results
3. Suggest: "Based on past decisions, consider using Result<T, E> pattern"

**User:**
```
/mem0-search How did we decide on the database?
```

**You should:**
1. Search for "database" + "decision" type
2. Show decision with rationale
3. Include any constraints or trade-offs noted

## Edge Cases

- No results: Suggest broader search terms
- Too many results: Offer to filter by type or date
- Mem0 unavailable: Gracefully fall back to local search
