# Refactoring Team Extensions

These patterns are useful in practice but are not presented here as Fowler core catalog entries.
Treat them as team conventions and heuristics layered on top of the core catalog.

## Test Code Refactoring

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Extract Test Fixture Factory** | Same object graph is constructed across many tests | Create a fixture factory with clear defaults |
| **Extract Test Helper** | Same setup or assertion sequence appears repeatedly | Introduce a helper with intention-revealing naming |
| **Move Oversized Integration Tests Out of Inline Test Modules** | One source file's test block becomes hard to navigate | Move integration-oriented tests into dedicated test files or directories |
| **Parameterize Test** | Test cases differ only by input and expectation | Use table-driven or parameterized tests |
| **Extract Availability Check** | Environment guards or skip conditions repeat | Centralize the availability check |
| **Extract Contract Assertion** | The same API contract assertions repeat across suites | Introduce a shared contract assertion helper |

## Post-GREEN Cleanup Patterns

| Pattern | Smell | Example Direction |
|---------|-------|-------------------|
| **Extract Higher-Order Helper** | Several flows share setup -> action -> teardown | Introduce a wrapper helper that parameterizes only the differing step |
| **Replace Hardcoded with Parameter** | Newly added behavior is blocked by literals or fixed assumptions | Push the varying part to a parameter or configuration boundary |
| **Remove Vestigial Method** | Old helpers remain after a better abstraction exists | Delete the obsolete entry point and inline callers if needed |
| **Extract Lookup from Conditional Mapping** | Long conditional tree just maps one value to another | Replace branch logic with a lookup table or data-driven mapping |
| **Collapse Incidental Abstraction** | A wrapper added during exploration no longer provides leverage | Inline and remove it |

## Migration-Safe Structural Work

These patterns often accompany refactoring around sensitive contracts.
They are not pure refactoring if the external contract changes, but they are useful compatibility techniques.

| Pattern | When to Use | Mechanics |
|---------|-------------|-----------|
| **Parallel Change** | Public contract needs to evolve without breaking callers | Introduce new shape, support both, migrate callers, then remove the old path |
| **Compatibility Wrapper** | Legacy callers must remain stable during internal cleanup | Add an adapter around the new structure |
| **Characterization Harness** | Legacy behavior is unclear but must be preserved | Add characterization tests before structural changes |

## Selection Notes

- Prefer a core pattern when a Fowler-aligned transformation already describes the change.
- Use team extensions to organize workflow, tests, and migration-safe cleanup around the core refactor.
- Do not label contract-breaking migration work as pure refactoring.
