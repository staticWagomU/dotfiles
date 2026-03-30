# Rust Refactoring Guidance

Use this file only for Rust-specific pattern selection after reading the core `refactoring` skill.

## Priorities

- Prefer ownership simplification over adding shared mutable state
- Prefer value objects and enums over primitive flags or stringly typed branching
- Prefer module and trait boundaries that make illegal states harder to represent
- Use the compiler, clippy, and tests as the primary safety net

## Common Rust-Specific Refactoring Moves

| Situation | Prefer |
|----------|--------|
| Too many clones to satisfy borrowing | Restructure ownership, extract smaller scopes, move data shaping earlier |
| Large `match` on enum behavior | Extract methods on the enum, helper functions, or trait-based dispatch where justified |
| One struct mixing data and orchestration | Extract pure value types, helper modules, or service-like collaborators |
| Deeply nested `Result` / `Option` handling | Split phase, extract function, use explicit conversion boundaries |
| Trait impl and module boundaries are tangled | Move function, extract trait, or separate data representation from behavior |
| Tests repeat large setup | Fixture factory, helper extraction, contract assertion helpers |

## Observable Behavior Checklist for Rust

Treat these as external behavior when applicable:

- Public crate exports and re-export paths
- Feature flags and cfg-gated public behavior
- Serialized shapes (`serde`, config, persisted files)
- Error enums, messages, and exit behavior when callers rely on them
- CLI and service contract surfaces implemented by the crate

## Smell-to-Pattern Hints

| Smell | Good First Moves |
|------|------------------|
| Borrow checker friction everywhere | Extract function, narrow scope, change value/reference boundary |
| Boolean flags in APIs | Remove flag argument, replace primitive with object, enum-based modeling |
| Long `impl` blocks with mixed concerns | Extract class/module, move function, extract trait |
| Primitive-heavy domain types | Replace primitive with object, encapsulate record, introduce parameter object |
| Manual data reshaping at many call sites | Combine functions into transform, move statements into function |
