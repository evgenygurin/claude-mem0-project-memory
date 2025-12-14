---
name: mem0-sync
description: Sync important patterns from Mem0 back into project CLAUDE.md
argument-hint: "[section] (optional: decisions|patterns|constraints|all)"
allowed-tools:
  - MCP(mem0:*)
  - Read
  - Write
---

# Mem0 to CLAUDE.md Sync

Synchronize key patterns and decisions from Mem0 into the project's CLAUDE.md file.

## When to Use

- After accumulating several important memories
- When onboarding new team members (ensure CLAUDE.md is current)
- Periodically (weekly/monthly) to keep documentation fresh
- After major architectural changes

## Process

### 1. Read Current CLAUDE.md

- Locate `CLAUDE.md` in `${CLAUDE_PROJECT_DIR}`
- Find or create "## Project Memory" section
- Preserve content inside `<!-- manual -->` tags (user-written)
- Identify auto-generated section boundaries

### 2. Query Mem0

- Fetch high-priority memories for `${CLAUDE_PROJECT_DIR_NAME}`
- Filter by types: `decisions`, `patterns`, `constraints`
- Sort by importance (number of references) and recency
- Limit to top 20-30 most relevant

### 3. Generate Updates

Format as Markdown:

```markdown
## Project Memory

### Manual Guidelines
<!-- manual -->
[Existing user-written content - NEVER MODIFY]
<!-- /manual -->

### Auto-Discovered Patterns
<!-- BEGIN AUTO-GENERATED FROM MEM0 - Last synced: YYYY-MM-DD -->

#### Architecture Decisions
- **[YYYY-MM-DD]** Decision description with rationale [[mem0:id]](link-if-available)

#### Code Patterns
- **[YYYY-MM-DD]** Pattern description and when to use [[mem0:id]](link)

#### Constraints
- **[YYYY-MM-DD]** Constraint with reason [[mem0:id]](link)

#### Key Learnings
- **[YYYY-MM-DD]** What we learned and impact [[mem0:id]](link)

<!-- END AUTO-GENERATED FROM MEM0 -->
```

**Rules:**
- Deduplicate with existing content
- Keep descriptions concise (1-2 lines)
- Include memory ID for traceability
- Group by category
- Most recent first within each category

### 4. Write Back

- Replace only the auto-generated section
- Preserve manual guidelines
- Update "Last synced" timestamp
- Maintain proper Markdown formatting

### 5. Report

Confirm to user:
- Number of memories synced
- Categories updated
- Summary of most important additions
- Link to updated CLAUDE.md

## Examples

**User:**
```
/mem0-sync
```

**You should:**
1. Sync all memory types
2. Update CLAUDE.md
3. Report: "✅ Synced 15 memories to CLAUDE.md (8 decisions, 5 patterns, 2 constraints)"

**User:**
```
/mem0-sync decisions
```

**You should:**
1. Sync only decisions
2. Update only that section
3. Leave other sections unchanged

## Edge Cases

- CLAUDE.md doesn't exist: Create it with template
- No auto-generated section: Add it after manual section
- Mem0 unavailable: Inform user, suggest trying later
- Manual section has no markers: Add markers to wrap existing content
