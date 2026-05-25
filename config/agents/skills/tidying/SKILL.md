---
name: tidying
description: Guide structural code improvements using Kent Beck's Tidy First methodology. Use when seeing messy code, before making behavioral changes, after completing features, or discussing when to clean up code.
---

<purpose>
Apply Kent Beck's "Tidy First?" philosophy: small, safe structural changes that improve code without changing behavior. Tidying is separate from feature work and gets its own commits.
</purpose>

<rules priority="critical">
  <rule>Tidyings are small: Minutes, not hours</rule>
  <rule>Tidyings are safe: Structure only, no behavior change</rule>
  <rule>Tidyings are optional: You choose when (or if) to tidy</rule>
  <rule>Tidyings are separate: Own commits, distinct from behavioral changes</rule>
  <rule>Every tidying gets its own commit: `refactor: &lt;what you tidied&gt;`</rule>
  <rule>Never mix tidying with behavioral changes: Separate commits</rule>
  <rule>Small commits: One tidying per commit when possible</rule>
</rules>

<patterns>
  <pattern name="tidy-first">
    <description>Tidy before making a behavioral change</description>
    <trigger>You need to change code that's hard to understand or modify</trigger>
    <use_when>
      - Reading code takes longer than it should
      - The change you need to make would be simpler if code were cleaner
      - Coupling makes the change risky
    </use_when>
    <example>
/tidy:first -> structural improvements -> /git:commit (refactor:)
           -> now make behavioral change -> /git:commit (feat:/fix:)
    </example>
  </pattern>

  <pattern name="tidy-after">
    <description>Tidy after completing a behavioral change</description>
    <trigger>You just finished a feature and see improvement opportunities</trigger>
    <use_when>
      - The working code revealed better structure possibilities
      - You added duplication to make tests pass (TDD GREEN phase)
      - You now understand the domain better
    </use_when>
    <example>
behavioral change -> /git:commit (feat:/fix:)
                 -> /tidy:after -> cleanup -> /git:commit (refactor:)
    </example>
  </pattern>

  <pattern name="tidy-later">
    <description>Defer tidying to the backlog</description>
    <trigger>Tidying would take too long or distract from current work</trigger>
    <use_when>
      - The tidying is substantial (more than a few minutes)
      - You're in flow on something else
      - The code works and tidying can wait
    </use_when>
    <example>
Note the opportunity -> add to backlog/TODO -> continue current work
    </example>
  </pattern>

  <pattern name="decision-framework">
    <description>When you encounter messy code, ask these questions in order</description>
    <steps>
      1. Does this code need to change for my current task?
         No  -> Tidy Later (or never)
         Yes -> Continue to 2
      2. Would tidying make my change easier/safer?
         No  -> Make behavioral change, then consider Tidy After
         Yes -> Continue to 3
      3. Is the tidying small (&lt; 15 minutes)?
         No  -> Tidy Later, make behavioral change anyway
         Yes -> Tidy First, then make behavioral change
    </steps>
  </pattern>
</patterns>

<best_practices>
  <practice priority="critical">Separate structural changes (refactor) from behavioral changes (feat/fix) in commits</practice>
  <practice priority="high">Guard Clauses: Replace nested conditionals with early returns</practice>
  <practice priority="high">Dead Code: Remove unused code (don't comment out - delete)</practice>
  <practice priority="high">Normalize Symmetries: Make similar code look similar</practice>
  <practice priority="medium">Extract Helper: Pull out a chunk that does one thing</practice>
  <practice priority="medium">Inline: Remove unhelpful abstraction</practice>
  <practice priority="medium">Rename: Make names reveal intent</practice>
  <practice priority="medium">Reorder: Put related code together</practice>
  <practice priority="medium">Chunk Statements: Add blank lines to group related statements</practice>
  <practice priority="medium">Explaining Variable: Replace complex expression with named variable</practice>
  <practice priority="medium">Explaining Constant: Replace magic number/string with named constant</practice>
</best_practices>

<anti_patterns>
  <avoid name="Big Bang Refactor">
    <description>Large, risky refactoring that is hard to review</description>
    <instead>Many small tidyings</instead>
  </avoid>
  <avoid name="Tidying + Feature">
    <description>Mixing tidying with behavioral changes obscures both</description>
    <instead>Separate commits</instead>
  </avoid>
  <avoid name="Speculative Tidying">
    <description>Tidying code that may change anyway is wasteful</description>
    <instead>Tidy what you're touching</instead>
  </avoid>
  <avoid name="Comment-Out Code">
    <description>Commenting out code creates noise</description>
    <instead>Delete it (git has history)</instead>
  </avoid>
  <avoid name="Tidying Forever">
    <description>Endless tidying is procrastination</description>
    <instead>Time-box, then ship</instead>
  </avoid>
</anti_patterns>

<constraints>
  <must>Tidying complements TDD's REFACTOR phase</must>
  <must>TDD REFACTOR removes duplication introduced during RED->GREEN</must>
  <must>Tidy First/After handles broader structural improvements not tied to a specific test</must>
</constraints>

<related_skills>
  <skill name="tdd">Tidying complements TDD's REFACTOR phase</skill>
  <skill name="git-commit">Every tidying gets its own commit</skill>
  <skill name="refactoring">Many refactoring patterns are tidying operations</skill>
</related_skills>

<reference>Based on: *Tidy First?* by Kent Beck (2023) - A practical guide to when and how to make structural improvements to code.</reference>
