# Recall Project Memory - Reference Documentation

## Memory Types

### Decision
Architectural or technical decisions made by the team.
- **When to capture**: After evaluating options and choosing approach
- **Content**: What was decided, why, alternatives considered
- **Tags**: decision, architecture, design

### Pattern
Code patterns, best practices, or conventions established.
- **When to capture**: After standardizing on an approach
- **Content**: Description of pattern, when to use, examples
- **Tags**: pattern, best-practice, convention

### Constraint
Limitations, requirements, or rules that must be followed.
- **When to capture**: When external requirement is imposed
- **Content**: What constraint, why it exists, impact
- **Tags**: constraint, requirement, limitation

### Learning
Lessons learned from mistakes, bugs, or experiments.
- **When to capture**: After resolving difficult issue
- **Content**: Problem, solution, what we learned
- **Tags**: learning, lesson, retrospective

## Search Strategy

### Semantic Search Tips

1. **Use noun phrases**: "authentication method" not "how to authenticate"
2. **Include technology**: "postgres migration" not just "migration"
3. **Combine concepts**: "async error handling" better than "errors" or "async" alone
4. **Avoid questions**: "database choice" not "why did we choose this database?"

### Search Scope

```javascript
// Always scope to project
user_id: process.env.CLAUDE_PROJECT_DIR_NAME

// Adjust limit based on task complexity
limit: 5-10  // Most tasks
limit: 15-20 // Complex decisions or refactoring

// Filter by type when appropriate
filters: {
  type: ["decision", "pattern"]  // Skip learnings for implementation
}
```

### Relevance Threshold

- **0.8+**: Highly relevant, definitely use
- **0.7-0.8**: Relevant, consider applying
- **0.6-0.7**: Possibly related, mention if useful
- **<0.6**: Not relevant, ignore

## Integration Points

### With Commands

- **Before `/mem0-capture`**: Search to avoid duplicates
- **After `/mem0-search`**: User explicitly wants comprehensive results
- **During `/mem0-sync`**: Prioritize memories for CLAUDE.md

### With Hooks

- **SessionStart**: Consider loading high-priority memories into context
- **PostToolUse (Write/Edit)**: Optionally check if change conflicts with patterns

### With Other Skills

This skill complements:
- Code review skills (check against established patterns)
- Testing skills (apply known test patterns)
- Documentation skills (reference past decisions)

## Performance Considerations

- **Cache results**: Within same task, reuse search results
- **Lazy loading**: Only retrieve full memory content if needed
- **Throttle searches**: Don't search on every message
- **Batch queries**: Combine related searches when possible

## Privacy & Security

- Memories are scoped per project (user_id = project name)
- No cross-project memory leakage
- Sensitive information should be tagged and filtered
- Consider adding `.mem0ignore` for sensitive patterns

## Troubleshooting

### Skill Not Triggering

**Symptoms**: Memory not being recalled when it should

**Causes**:
- Description in SKILL.md not specific enough
- User query doesn't match trigger words
- Skill disabled in plugin config

**Solution**:
- Enhance description with more use case examples
- Test with explicit phrases
- Check `config/memory-config.json`

### Too Many False Positives

**Symptoms**: Retrieving irrelevant memories

**Causes**:
- Search query too broad
- Relevance threshold too low
- Memory tags not specific enough

**Solution**:
- Narrow search terms
- Increase threshold to 0.75+
- Improve memory tagging during capture

### Performance Issues

**Symptoms**: Slow responses when skill activates

**Causes**:
- Too many memories in project
- Network latency to Mem0 API
- Large memory content

**Solution**:
- Reduce search limit
- Implement caching
- Archive old memories
- Use summary-only retrieval

## Version History

- **v0.1.0** (2025-12-14): Initial skill implementation
