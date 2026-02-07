---
name: refactoring
description: Guide code refactoring using Martin Fowler's catalog of behavior-preserving transformations. Use during TDD REFACTOR phase, when code smells are detected (duplication, long methods, feature envy), when discussing structural improvements, or before behavioral changes (Tidy First).
---

<purpose>
Apply behavior-preserving transformations to improve quality of any codes, including tests.
"Refactoring is a disciplined technique for restructuring an existing body of code, altering its internal structure without changing its external behavior." -- Martin Fowler
</purpose>

<rules priority="critical">
  <rule>Never refactor with failing tests</rule>
  <rule>One pattern at a time</rule>
  <rule>Commit after each successful refactor</rule>
  <rule>Revert immediately if tests fail</rule>
</rules>

<patterns>
  <pattern name="refactoring-workflow">
    <description>The standard refactoring workflow</description>
    <steps>
      1. Ensure tests pass (you need a safety net)
      2. Identify ONE smell to address
      3. Choose appropriate pattern from `patterns.md`
      4. Apply mechanically in small steps
      5. Run tests after each step
      6. Commit when green
    </steps>
  </pattern>
</patterns>

<constraints>
  <must>Renaming for clarity</must>
  <must>Extracting functions/methods</must>
  <must>Removing duplication</must>
  <must>Simplifying expressions</must>
  <must>Moving files/modules between directories</must>
  <must>Reorganizing module boundaries</must>
  <avoid>Adding new functionality during refactoring</avoid>
  <avoid>Fixing bugs during refactoring (write a failing test first instead)</avoid>
  <avoid>Changing observable behavior in any way</avoid>
</constraints>

<related_skills>
  <skill name="tdd">Refactoring is the third phase of the TDD cycle</skill>
  <skill name="tidying">Tidying is a subset of refactoring - small, safe structural changes</skill>
  <skill name="code-priority">Refactoring patterns target state and coupling improvements</skill>
  <skill name="git-commit">Commit after each successful refactor</skill>
</related_skills>

<reference>See `library-application-criteria.md` for public API constraints (libraries vs applications). See `patterns.md` for the full catalog of refactoring patterns.</reference>
