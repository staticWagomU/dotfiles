---
name: git-commit
description: Stage meaningful diffs and create commits with WHY-focused messages. Use whenever making git commits.
---

<purpose>
Use `/git:commit` slash command to stage meaningful diffs and create commits with WHY-focused messages.
</purpose>

<rules priority="critical">
  <rule>Only commit when ALL tests are passing</rule>
  <rule>Only commit when ALL compiler/linter warnings have been resolved</rule>
  <rule>The change must represent a single logical unit of work</rule>
  <rule>Commit messages must clearly state whether the commit contains structural or behavioral changes</rule>
  <rule>Use small, frequent commits rather than large, infrequent ones</rule>
</rules>

<related_skills>
  <skill name="tdd">Commit after GREEN phase and after each refactor step</skill>
  <skill name="tidying">Every tidying gets its own commit</skill>
</related_skills>
