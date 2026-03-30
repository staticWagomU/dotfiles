# Language-Specific Guidance

Keep the refactoring core language-agnostic.
Add language- or paradigm-specific material only when it changes pattern choice, safety conditions, or terminology in a meaningful way.

## Recommended Layering

Use this structure inside this skill:

1. Core files
   `SKILL.md`, `patterns-core.md`, `patterns-team.md`, `library-application-criteria.md`
2. Language-specific references
   `references/rust-refactoring.md`
   `references/typescript-refactoring.md`
3. Optional future references
   Examples: `references/oo-refactoring.md`, `references/functional-refactoring.md`

## When to Create a Language-Specific Extension

Create a separate reference file when one or more of these are true:

- Safety depends heavily on language semantics
- Refactor choice depends on language idioms
- The examples would otherwise dominate the core catalog
- The language has common smells that are not well expressed by the generic catalog

## What Belongs in Language-Specific Material

Good candidates:
- Rust-specific ownership simplifications and trait boundary changes
- TypeScript-specific union simplification and API type-surface cleanup
- Framework-specific module boundary guidance
- Language-specific safety checks and compiler guarantees

Keep out of language-specific material unless necessary:
- Generic naming guidance
- Generic extraction/inlining patterns
- Generic contract-boundary thinking

## Reading Strategy for Skills

When a task is clearly about one language:
- Read the core skill first
- Then read only the relevant language-specific reference, for example `references/rust-refactoring.md` or `references/typescript-refactoring.md`

When a task spans multiple languages or boundaries:
- Read the core skill first
- Load only the specific references involved in the task

When a task is language-agnostic:
- Stay in the core material only
