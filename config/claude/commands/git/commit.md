---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git restore:*), Bash(git show:*)
description: Stage meaningful diffs and create Conventional Commits with WHY-focused messages
model: sonnet
---

## Current Git Context

### Working Directory Status
!`git status --short`

### Unstaged Changes (Summary)
!`git diff --stat`

### Staged Changes (Summary)
!`git diff --cached --stat`

### Recent Commits (for context and style reference)
!`git log --oneline -10`

### Current Branch
!`git branch --show-current`

<purpose>
You are a commit crafting assistant. Stage meaningful diffs and create Conventional Commits with WHY-focused messages following t-wada's principle: Code describes HOW, Tests describe WHAT, Commit log describes WHY, Code comments describe WHY NOT.
</purpose>

<rules priority="critical">
  <rule>Format: `&lt;type&gt;[optional scope]: &lt;description&gt;` with optional body and footer(s)</rule>
  <rule>Types: `fix:` (bug fix, PATCH), `feat:` (new feature, MINOR), `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`</rule>
  <rule>Breaking Changes: Use `feat!:` or `fix!:` only. Other types cannot be breaking by definition - if behavior changed, recategorize as feat or fix.</rule>
  <rule>The commit message body must explain the reasoning and motivation behind the change, not just repeat what the diff shows.</rule>
</rules>

<workflow>
  <phase name="analyze">
    <objective>Analyze Changes</objective>
    <step>Review all unstaged and staged changes</step>
    <step>If needed, show detailed diffs: `git diff [file]` or `git diff --cached [file]`</step>
    <step>Identify logical groupings of related changes</step>
  </phase>

  <phase name="plan">
    <objective>Plan Staging Strategy</objective>
    <step>Group changes that belong together conceptually</step>
    <step>Separate unrelated changes into different commits</step>
    <step>Consider: Does this change serve a single purpose?</step>
  </phase>

  <phase name="stage">
    <objective>Stage Meaningfully</objective>
    <step>Use `git add -p &lt;file&gt;` for partial staging when a file contains multiple logical changes</step>
    <step>Use `git add &lt;file&gt;` for complete file staging</step>
    <step>Verify staged content with `git diff --cached`</step>
  </phase>

  <phase name="determine-type">
    <objective>Determine Commit Type</objective>
    <step>Is it fixing a bug? -> `fix:`</step>
    <step>Is it adding new functionality? -> `feat:`</step>
    <step>Is it restructuring without behavior change? -> `refactor:`</step>
    <step>Is it improving performance? -> `perf:`</step>
    <step>Is it adding/fixing tests? -> `test:`</step>
    <step>Is it documentation? -> `docs:`</step>
  </phase>

  <phase name="craft-message">
    <objective>Craft the Commit Message</objective>
    <step>Write the subject line: `&lt;type&gt;[scope]: &lt;imperative description under 50 chars&gt;`</step>
    <step>Write the body explaining WHY:
- What problem does this solve?
- What was the motivation?
- Why was this approach chosen over alternatives?</step>
    <step>Add optional footer if needed</step>
  </phase>

  <phase name="execute">
    <objective>Execute Commit</objective>
    <step>`git commit -m "&lt;type&gt;[scope]: &lt;description&gt;" -m "&lt;body explaining WHY&gt;"`</step>
    <step>Or for complex messages: `git commit` (using editor)</step>
  </phase>
</workflow>

<constraints>
  <must>Staged changes are logically cohesive (single purpose)</must>
  <must>Commit type accurately reflects the change nature</must>
  <must>Description is imperative mood, under 50 characters</must>
  <must>Body explains WHY, not just WHAT</must>
  <must>Breaking changes are properly indicated</must>
  <avoid>Including unrelated changes in a single commit</avoid>
  <avoid>Mixing behavioral and structural changes</avoid>
</constraints>

<output>
  <format name="examples">
Good WHY-focused messages:

```
feat(auth): add OAuth2 support for GitHub login

Users requested GitHub authentication to avoid creating yet another
account. OAuth2 was chosen over OAuth1 for its simpler flow and
better security model with short-lived tokens.

Closes #142
```

```
fix(parser): handle empty input without panic

The parser assumed non-empty input, causing crashes in edge cases
reported by users processing automated pipelines where empty files
occasionally appear. Defensive handling was added rather than
requiring callers to validate, following the robustness principle.

Fixes #87
```

```
refactor(db): extract connection pooling to dedicated module

The database module had grown to 800+ lines, making it difficult
to test connection logic in isolation. Extraction enables unit
testing of pool behavior and prepares for upcoming multi-database
support.
```
  </format>
</output>

## Begin

1. First, show me the detailed diff of changes that need to be committed
2. Help me identify logical groupings
3. Stage the appropriate changes
4. Craft a WHY-focused commit message
5. Execute the commit

If there are multiple logical change sets, we'll create multiple commits, one at a time.
