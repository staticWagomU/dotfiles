---
name: tdd
description: Guide Test-Driven Development using Kent Beck's Red-Green-Refactor cycle. Use when writing tests, implementing features via TDD, or following plan.md test instructions.
---

<purpose>
Follow Kent Beck's TDD and Tidy First principles using the three-phase workflow:
RED -> GREEN -> REFACTOR.
</purpose>

<rules priority="critical">
  <rule>One test at a time: Each RED adds exactly ONE failing test</rule>
  <rule>Minimal code: GREEN phase writes just enough to pass</rule>
  <rule>Never skip REFACTOR: Every TDD cycle must complete all three phases</rule>
  <rule>Tidy First: Separate structural changes (refactor) from behavioral changes (feat/fix)</rule>
  <rule>Small commits: Commit after GREEN, commit after EACH refactor step</rule>
</rules>

<patterns>
  <pattern name="workflow">
    <description>The core TDD cycle</description>
    <steps>
      1. RED - `/tdd:red` - Write ONE small failing test
      2. GREEN - `/tdd:green` - Make it pass with minimal code, then commit
      3. REFACTOR - `/tdd:refactor` - Improve structure without changing behavior, commit each step
    </steps>
    <example>
/tdd:red -> write failing test -> /tdd:green -> pass test -> /git:commit
                                                                 |
       &lt;- next feature &lt;- /tdd:red &lt;- satisfied? &lt;- /tdd:refactor (repeat as needed)
    </example>
  </pattern>

  <pattern name="strategy-selection">
    <description>GREEN phase strategy selection based on confidence level</description>
    <strategies>
      <strategy confidence="low" name="Fake It">Return constant, generalize later</strategy>
      <strategy confidence="high" name="Obvious Implementation">Solution is clear</strategy>
      <strategy confidence="generalizing" name="Triangulation">Add test to break a fake</strategy>
    </strategies>
  </pattern>
</patterns>

<best_practices>
  <practice priority="critical">Run ALL tests after EVERY change</practice>
  <practice priority="high">Eliminate duplication between test and production code</practice>
  <practice priority="high">Express intent through clear naming</practice>
  <practice priority="medium">Keep methods small and focused</practice>
</best_practices>

<related_skills>
  <skill name="tidying">Tidy First complements TDD's REFACTOR phase</skill>
  <skill name="git-commit">Commit after GREEN and after each refactor step</skill>
  <skill name="refactoring">Patterns for the REFACTOR phase</skill>
</related_skills>
