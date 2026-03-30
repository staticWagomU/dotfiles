# Refactoring Catalog Index

This file is the stable entry point for the refactoring catalog.

Use the documents in this order:

1. `patterns-core.md`
   Language-agnostic, Fowler-aligned refactoring patterns.
2. `patterns-team.md`
   Team-specific extension patterns that are useful in practice but are not presented as Fowler core catalog entries.
3. `language-specific-guidance.md`
   Guidance for deciding when to load language- or paradigm-specific refactoring material.
4. `references/rust-refactoring.md` or `references/typescript-refactoring.md`
   Load only the language-specific reference that matches the task.

## Quick Map

| Need | Start Here |
|------|------------|
| Definition of refactoring | `SKILL.md` |
| Fowler-aligned patterns | `patterns-core.md` |
| Team conventions and extensions | `patterns-team.md` |
| Public/external contract boundaries | `library-application-criteria.md` |
| Rust / TypeScript / OO / functional split guidance | `language-specific-guidance.md` |
| Rust-specific guidance | `references/rust-refactoring.md` |
| TypeScript/JavaScript-specific guidance | `references/typescript-refactoring.md` |

## Notes

- `patterns-core.md` should be treated as the canonical catalog for general-purpose refactoring guidance in this skill.
- `patterns-team.md` intentionally contains higher-level or team-specific heuristics and should not be confused with the Fowler core catalog.
- Keep language-specific examples and rules out of the core catalog unless they are genuinely language-agnostic.
- Load only the relevant file under `references/` when a task is language-specific.
