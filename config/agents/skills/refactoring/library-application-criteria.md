# External Contract Criteria

Refactoring scope depends on the boundary between internal structure and externally observable behavior.

## The Core Distinction

| Context | External Consumers? | Boundary Refactorable? |
|--------|----------------------|------------------------|
| Library | Yes, often unknown | Internal only |
| Application | Often yes, but contract-specific | Internal only |
| Internal module | Usually controlled | Often yes, with local updates |

The key question is not "library or application?" alone.
The key question is: "What contracts exist outside the code I am editing?"

## Observable Behavior Checklist

Treat these as behavior when other systems, teams, or operators depend on them:

- Exported functions, types, module paths, and package structure
- HTTP, GraphQL, RPC, and webhook contracts
- CLI flags, subcommands, stdout formats, and exit codes
- Database schemas, migrations, persisted records, and cache keys
- Queue messages, event payloads, topic names, and ordering assumptions
- Error codes, exception types, retry behavior, and timeout semantics
- Logs, metrics, traces, and audit events when downstream tooling depends on them
- Performance, memory, and concurrency guarantees when they are part of an agreed contract

## Library Constraints

Libraries usually have the hardest external boundary because callers are not fully known.

Safe refactoring scope for libraries:
- Private functions and modules
- Internal data representation
- Internal call structure
- Internal naming and decomposition

Not refactoring for libraries unless compatibility is preserved:
- Renaming exported functions or types
- Changing exported signatures
- Removing or renaming public modules or re-export paths
- Changing documented defaults or externally visible semantics

## Application Constraints

Applications are not automatically free of external boundaries.
Even if you control the codebase, applications often expose stable contracts to users, operators, or other services.

Common application boundaries:
- Public HTTP or RPC endpoints
- CLI behavior used by scripts or operators
- Database schemas shared with analytics or other services
- Events consumed by external workers
- Config file formats or environment-variable contracts

Safe refactoring scope for applications:
- Internal service boundaries when all callers can be updated together
- Internal module names, function signatures, and directory structure
- Internal data flow and decomposition

Not refactoring unless compatibility is preserved:
- Breaking public endpoint payloads
- Changing persisted data formats without a migration strategy
- Changing operational interfaces that existing tooling depends on

## Hybrid Cases

Many projects contain multiple boundary types.

Example:

```text
my-project/
|- packages/sdk/      # library boundary
|- services/api/      # service boundary
|- apps/cli/          # operator-facing CLI boundary
\- internal/tools/    # mostly internal
```

Apply the strictest relevant contract rule to each area.

## Practical Decision Rule

Before calling something a refactor, ask:

1. Who can observe this change outside the edited module?
2. What contract are they relying on?
3. Is that contract preserved exactly, or only migrated?

If the contract changes, treat the work as behavior change, migration, or compatibility work, not pure refactoring.
