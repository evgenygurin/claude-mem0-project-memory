---
name: mem0-reflect
description: Analyze recent git commits and code changes to identify and capture recurring patterns, architectural decisions, and key learnings. Best used after completing a sprint, solving complex issues, or reaching milestones.
argument-hint: "[number of days to analyze, default: 7]"
allowed-tools:
  - MCP(mem0:*)
  - Bash(git:*)
  - Read
  - Grep
  - Glob
---

# Mem0 Reflection

Analyze recent git commits and code changes to extract and store important patterns.

## When to Use

- At end of sprint/milestone to capture learnings
- After resolving a complex issue across multiple commits
- Weekly review of accumulated knowledge
- Before starting similar work to avoid repeating mistakes

## Process

### 1. Load Git History

- Analyze git commits from last N days (from `$ARGUMENTS` or default to 7)
- Use git log with `--since` parameter
- Extract from commits and diffs:
  - Architectural decisions and their rationale
  - Code patterns and refactoring approaches
  - Bug fixes and their solutions
  - Performance optimizations
  - Testing strategies
  - Configuration changes

### 2. Identify Patterns

Analyze commit history for:

**Recurring Problems & Solutions**
- Same error fixed multiple times → Document solution
- Pattern emerges across commits → Create best practice
- Error handling patterns that evolved

**Design Decisions**
- Why certain architectures were chosen (from commit messages)
- Trade-offs considered (from PR descriptions)
- Rejected alternatives and why (from commit history)
- Migration strategies (from refactoring commits)

**Performance Insights**
- Bottlenecks discovered and fixed
- Optimization strategies that worked
- Configuration changes for performance

**Testing Approaches**
- Test strategies introduced
- Test coverage improvements
- CI/CD pipeline changes

**Architectural Choices**
- Module boundaries established
- Dependency updates and rationale
- Technology selections
- API design patterns

### 3. Filter for Importance

**Skip:**
- One-off fixes unlikely to recur
- Trivial style changes (formatting, typos)
- Dependency version bumps without rationale
- Merge commits without substance

**Capture:**
- Reusable architectural patterns
- "This should be in CLAUDE.md" decisions
- Hard-won insights from debugging
- Team-relevant best practices
- Breaking changes and migration paths
- Security fixes and their context

### 4. Store in Mem0

For each significant pattern:
- Use `mcp__mem0__add_memory` to store insights
- Include commit SHA references for traceability
- Add metadata:
  - `type`: "pattern", "decision", "learning", "fix"
  - `project`: Current project name (${CLAUDE_PROJECT_DIR} basename)
  - `timestamp`: When pattern was identified
  - `source`: Commit SHAs or file paths
- Tag with relevant keywords for future search

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
1. Run `git log --since="7 days ago"` to get recent commits
2. Analyze commit messages, diffs, and file changes
3. Extract 3-10 key patterns/decisions
4. Store each in Mem0 via MCP
5. Suggest `/mem0-sync` if valuable patterns found

**User:**
```
/mem0-reflect 14
```

**You should:**
1. Run `git log --since="14 days ago"` (broader retrospective)
2. Look for longer-term trends and evolution
3. Focus on strategic architectural patterns
4. Identify technology migrations or major refactorings

## Edge Cases

- No git commits in period: Inform user gracefully
- Too many commits (>100): Summarize by categories, focus on major changes
- Too many patterns (>20): Prioritize by impact, ask user which to capture
- No significant patterns: Report "No new patterns found, commits were routine"
- Not in a git repository: Inform user this command requires git history

## Implementation Notes

**Environment Variables Available:**
- `${CLAUDE_PROJECT_DIR}`: Project root directory
- `${CLAUDE_PLUGIN_ROOT}`: Plugin directory (not needed for this command)
- `$ARGUMENTS`: User-provided number of days (default: 7)

**Git Commands to Use:**
```bash
# Get commits from last N days
git log --since="N days ago" --pretty=format:"%H|%an|%ad|%s" --date=short

# Get detailed diff for commits
git show --stat <commit-sha>
git diff <commit-sha>~1..<commit-sha>

# Get files changed in period
git diff --name-status --since="N days ago" HEAD~N..HEAD
```

**MCP Mem0 Tools to Use:**
- `mcp__mem0__add_memory`: Add new memories
- `mcp__mem0__search_memory`: Check if similar patterns already captured
- `mcp__mem0__get_all_memories`: Review existing project memories
