# TypeScript Refactoring Guidance

Use this file only for TypeScript- and JavaScript-specific pattern selection after reading the core `refactoring` skill.

## Priorities

- Prefer explicit domain types and discriminated unions over primitive flags and stringly typed branching
- Prefer module boundaries that make dependencies visible
- Keep runtime validation and static typing aligned
- Use tests, type checks, and schema checks as the safety net

## Common TypeScript-Specific Refactoring Moves

| Situation | Prefer |
|----------|--------|
| Options objects with many booleans | Remove flag argument, introduce parameter object, replace primitive with object |
| Repeated union narrowing logic | Extract function, introduce special case, encapsulate record |
| Async functions mix fetch, parse, validate, and map | Split phase, extract function, combine functions into transform |
| Public package surface is sprawling | Change function declaration carefully, move function, hide delegate, extract module boundary |
| Repeated ad hoc object reshaping | Encapsulate record, combine functions into transform |
| Tests repeat fixtures and API expectations | Fixture factory, parameterized test, contract assertion helper |

## Observable Behavior Checklist for TypeScript

Treat these as external behavior when applicable:

- Package exports, entrypoints, and emitted module paths
- Public type surfaces that other packages compile against
- JSON, HTTP, GraphQL, form, and config payload shapes
- Runtime validation schemas and serialization behavior
- Browser or Node-facing CLI/service contracts

## Smell-to-Pattern Hints

| Smell | Good First Moves |
|------|------------------|
| `any` or wide object types spread across the codebase | Encapsulate record, replace primitive with object, introduce parameter object |
| Same `if`/`switch` narrowing in many places | Extract function, replace conditional with polymorphism, introduce special case |
| Async pipeline is hard to follow | Split phase, move statements into function, replace inline code with function call |
| Package API drift and overload confusion | Change function declaration, remove flag argument, preserve whole object |
