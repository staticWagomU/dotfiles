---
name: tip-javascript-typescript
description: This skill should be used when writing or refactoring TypeScript/JavaScript code. It provides coding patterns and best practices aligned with the user's preferred development style, typescript language usage patterns, and library-specific tips.
---

<purpose>
Apply the user's preferred TypeScript/JavaScript coding techniques automatically when writing or refactoring code. This skill encapsulates coding patterns, best practices, and architectural decisions to ensure consistency with the user's mental model and development philosophy.
</purpose>

<rules priority="critical">
  <rule>Apply these techniques proactively as the default approach when writing or refactoring TypeScript/JavaScript code</rule>
</rules>

<patterns>
  <pattern name="when-to-use">
    <description>Scenarios where this skill applies automatically</description>
    <triggers>
      - Writing new TypeScript/JavaScript code
      - Refactoring existing TypeScript/JavaScript code
      - Planning improvements of code quality (reduce duplication, improve readability, enhance maintainability)
      - Reviewing code for improvements
      - Making architectural decisions in TypeScript/JavaScript projects
    </triggers>
  </pattern>

  <pattern name="reference-structure">
    <description>Coding techniques and tips organized into two categories</description>
    <categories>
      <category name="references/typescript/">
        Language-Level Patterns: TypeScript/JavaScript language syntax, patterns, and best practices.
        See `references/typescript/README.md` for details.
      </category>
      <category name="references/libraries/">
        Library-Specific Tips: Usage patterns, optimizations, and gotchas for specific libraries and frameworks.
        See `references/libraries/README.md` for details.
      </category>
    </categories>
  </pattern>

  <pattern name="adding-new-patterns">
    <description>How to add new patterns to this skill</description>
    <steps>
      1. READ each reference categories' README to find file place / naming conventions
      2. Follow DOs and DON'Ts specified in each README
      3. Use the tip file template (see below)
    </steps>
    <template>
```markdown
# [Topic Name]

## Overview
[Brief description and why these tips are needed]

## Basic Patterns
### [Pattern Name]
**When to use**: [Description of use case]
**Example**: (code)
**Anti-pattern to avoid**: (code)
**Notes**: [Additional context, edge cases, considerations]

## Common Issues and Solutions
### [Issue Title]
**Problem**: [What goes wrong]
**Solution**: (code)

## Performance Optimization
[If applicable]

## Type Usage
[TypeScript type patterns for this library]

## References
- Official docs: [URL]
- Related articles: [URL]
```
    </template>
  </pattern>
</patterns>

<best_practices>
  <practice priority="critical">Load and apply patterns from the relevant reference files automatically when writing TypeScript/JavaScript</practice>
  <practice priority="high">Reference files contain template sections for adding new patterns as they emerge</practice>
</best_practices>
