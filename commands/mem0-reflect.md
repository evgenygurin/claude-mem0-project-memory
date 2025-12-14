---
name: mem0-reflect
description: Analyze recent development sessions to identify and capture recurring patterns, important decisions, and key learnings. Best used after completing a sprint, solving complex issues, or reaching milestones.
argument-hint: "[number of sessions to analyze, default: 5]"
allowed-tools:
  - MCP(mem0:*)
  - Read
---

# Mem0 Reflection

Analyze recent development sessions to extract and store important patterns.

## When to Use

- At end of sprint/milestone to capture learnings
- After resolving a complex issue across multiple sessions
- Weekly review of accumulated knowledge
- Before starting similar work to avoid repeating mistakes

## Process

### 1. Load Session Data

- Read last N session transcripts (from `$ARGUMENTS` or default to 5)
- Look in `${CLAUDE_TRANSCRIPT_PATH}` or session history
- Extract:
  - Tool usage patterns
  - Decisions made and rationale
  - Errors encountered and solutions
  - Performance insights
  - Testing approaches

### 2. Identify Patterns

Analyze for:

**Recurring Problems & Solutions**
- Same error fixed multiple times → Document solution
- Pattern emerges across sessions → Create best practice

**Design Decisions**
- Why certain architectures were chosen
- Trade-offs considered
- Rejected alternatives and why

**Performance Insights**
- Bottlenecks discovered
- Optimization strategies that worked
- Benchmarking results

**Testing Approaches**
- Test strategies that caught bugs
- Edge cases discovered
- Useful test patterns

**Architectural Choices**
- Module boundaries
- Dependency decisions
- Technology selections

### 3. Filter for Importance

**Skip:**
- One-off fixes unlikely to recur
- Trivial style changes
- Session navigation/setup

**Capture:**
- Reusable knowledge
- "This should be in CLAUDE.md" moments
- Hard-won insights
- Team-relevant patterns

### 4. Store in Mem0

For each significant pattern:
- Create memory entry with appropriate type
- Link related memories if applicable
- Tag with relevant keywords
- Include source session IDs

### 5. Suggest CLAUDE.md Updates

- If significant patterns found (≥3), offer to run `/mem0-sync`
- Show preview of what would be added:

```
Found 5 significant patterns:
- Decision: Switched to async error handling (session_7)
- Pattern: Use builder pattern for complex configs (sessions 5-7)
- Learning: Database indexes critical for query X (session_6)

Run /mem0-sync to add these to CLAUDE.md?
```

## Examples

**User:**
```
/mem0-reflect
```

**You should:**
1. Analyze last 5 sessions
2. Extract 3-10 key patterns
3. Store in Mem0
4. Suggest sync if valuable patterns found

**User:**
```
/mem0-reflect 10
```

**You should:**
1. Analyze last 10 sessions (broader retrospective)
2. Look for longer-term trends
3. Focus on strategic patterns

## Edge Cases

- No sessions available: Inform user gracefully
- Sessions too old (>30 days): Ask if they want to proceed
- Too many patterns (>20): Prioritize by impact, ask user to review
- No significant patterns: Report "No new patterns found, sessions were routine"
