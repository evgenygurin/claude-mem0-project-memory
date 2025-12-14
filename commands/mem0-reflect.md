***
name: mem0-reflect
description: Analyze recent session transcripts and extract key learnings into Mem0
argument-hint: "[session_count] (default: 5)"
allowed-tools: ["MCP(mem0:*)", "Read"]
***

# Mem0 Reflection

Analyze recent development sessions and extract important patterns.

## Process

1. **Load session data**:
   - Read last N session transcripts (from ARGUMENTS or default 5)
   - Extract tool usage, decisions, errors, solutions

2. **Identify patterns**:
   - Recurring problems and solutions
   - Design decisions and rationale
   - Performance insights
   - Testing approaches
   - Architectural choices

3. **Filter for importance**:
   - Skip trivial/one-off fixes
   - Focus on reusable knowledge
   - Identify "this should be in CLAUDE.md" moments

4. **Store in Mem0**:
   - Create memory entries for each pattern
   - Link related memories
   - Tag appropriately

5. **Suggest CLAUDE.md updates**:
   - Offer to run /mem0-sync if significant patterns found
   - Show preview of what would be added

## Example Usage

```
/mem0-reflect
/mem0-reflect 10
```
