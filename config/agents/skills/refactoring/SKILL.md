---
name: refactoring
description: Guide behavior-preserving code refactoring with a language-agnostic core, Fowler-aligned catalog references, and team-specific extension patterns. Use during the TDD REFACTOR phase, when code smells are detected, when preparing for later behavior changes, or when discussing structural improvements.
---

<purpose>
Apply behavior-preserving transformations to improve the internal design of existing code, including tests.
"Refactoring is a disciplined technique for restructuring an existing body of code, altering its internal structure without changing its external behavior." -- Martin Fowler
</purpose>

<core-definition>
Refactoring is not "code cleanup" in the broad sense. It is a sequence of small, safe transformations that preserve observable behavior while improving readability, modularity, and changeability.

Do not mix these concepts:
- Refactoring: preserve behavior, improve structure
- Behavior change: intentionally change outputs, contracts, or side effects
- Operational workflow: commits, checkpoints, sequencing rules
</core-definition>

<observable-behavior>
Treat all external contracts as behavior, not only public function signatures.

Examples of observable behavior:
- Public APIs and exported types
- HTTP, RPC, CLI, and event contracts
- Database schemas and persisted data formats
- Error semantics and exception types
- Logs, metrics, and audit outputs when consumers depend on them
- Performance or concurrency guarantees when they are part of the contract

See `library-application-criteria.md` for boundary guidance.
</observable-behavior>

<rules priority="critical">
  <rule>Prefer small, behavior-preserving steps</rule>
  <rule>Use the strongest available safety net before changing structure</rule>
  <rule>Address one smell or structural problem at a time</rule>
  <rule>Separate refactoring from feature work and bug fixes</rule>
  <rule>Stop and reassess if an intended refactor changes an external contract</rule>
</rules>

<safety-net>
Do not assume that "all unit tests are green" is the only valid safety condition.

Acceptable safety nets include:
- Existing automated tests
- Characterization tests added before refactoring legacy code
- Compiler/type-system guarantees
- Contract tests, snapshot tests, or property tests
- Incremental rollout or compatibility layers when boundaries are sensitive
</safety-net>

<workflow>
  <step>1. Identify the smell, friction, or structural mismatch</step>
  <step>2. Identify the relevant external contracts and safety net</step>
  <step>3. Choose a pattern from `patterns-core.md` or `patterns-team.md`</step>
  <step>4. Apply the change mechanically in small steps</step>
  <step>5. Re-run the relevant checks after each meaningful step</step>
  <step>6. Only then make the intended behavior change, if any</step>
</workflow>

<catalogs>
Use the catalogs in this order:
1. `patterns-core.md` for language-agnostic, Fowler-aligned patterns
2. `patterns-team.md` for team-specific extension patterns
3. `language-specific-guidance.md` for selecting the relevant language-specific reference

Load language-specific references only when the task language clearly matters:
- Rust: `references/rust-refactoring.md`
- TypeScript / JavaScript: `references/typescript-refactoring.md`

`patterns.md` is kept as an index for compatibility and quick navigation.
</catalogs>

<constraints>
  <must>Keep refactoring separate from intentional behavior changes</must>
  <must>Prefer names and boundaries that encode understanding in the code</must>
  <must>Consider external contracts before reorganizing modules or APIs</must>
  <avoid>Calling a breaking API change "refactoring"</avoid>
  <avoid>Bundling multiple unrelated structural changes together</avoid>
  <avoid>Smuggling new features into refactoring-only work</avoid>
</constraints>

<related_skills>
  <skill name="tdd">Refactoring is the third phase of the TDD cycle</skill>
  <skill name="tidying">Tidying is a narrow subset of small, safe structural changes</skill>
  <skill name="code-priority">Use refactoring to reduce complexity and coupling before extending behavior</skill>
</related_skills>

<reference>
See `patterns-core.md` for the main catalog, `patterns-team.md` for team-specific extensions, `patterns.md` for a compact index, `library-application-criteria.md` for external-contract boundaries, `language-specific-guidance.md` for language-specific layering, and `references/` for language-specific reference files.
</reference>
