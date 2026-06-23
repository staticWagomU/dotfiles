---
name: prepare-issue-pr
description: |
  Prepare issue or pull request content from repository templates.
  Detect whether the request is for an issue or PR, find the relevant template, and help fill it out without removing existing template content.
  Save the prepared content to a memo file for reference.
  Use when the user asks to create an issue, create a PR, or work from an issue/PR template.
allowed-tools: Read, Grep, Glob, Edit, Bash(fd:*), Bash(git diff-ancestor-commit:*), Bash(memo new:*)
---

<purpose>
Issue/PR Preparation Specialist - creates comprehensive and well-structured Issue and Pull Request descriptions that strictly adhere to repository templates and best practices.
</purpose>

<workflow>
  <phase name="type-detection">
    Automatically determine whether to prepare an Issue or Pull Request based on context:
    <rule>Issue indicators: "issue", "イシュー", "報告", "提案", "feature request", "bug report", "問題", etc.</rule>
    <rule>PR indicators: "PR", "pull request", "プルリク", "マージ", "review", "レビュー", "実装した", "finished implementing", etc.</rule>
    <rule>If unclear from context, ask the user which type they need</rule>
    <rule>Consider git status: if there are uncommitted changes or commits to push, likely a PR; otherwise, likely an Issue</rule>
  </phase>

  <phase name="template-discovery">
    Search for templates based on the detected type:
    <rule>For Pull Requests: `fd -H -e md --ignore-case -p 'pull_request_template'`</rule>
    <rule>For Issues: `fd -H -e md --ignore-case -p 'issue_template'`</rule>
    <rule>Combine results from both Issue search methods</rule>
  </phase>

  <phase name="template-selection">
    <rule>If multiple templates are found, present them to the user with clear descriptions and let them choose</rule>
    <rule>If only one template is found, proceed automatically with that template</rule>
    <rule>If no templates are found, inform the user and offer to create a basic PR structure</rule>
  </phase>

  <phase name="template-adherence">
    <rule>Read the selected template completely and understand every section and requirement</rule>
    <rule>NEVER delete or modify any existing content in the template</rule>
    <rule>Fill out every section that the template requires</rule>
    <rule>Preserve all formatting, checkboxes, and structural elements exactly as they appear</rule>
    <rule>If a section is optional or not applicable, clearly mark it as such rather than removing it</rule>
  </phase>

  <phase name="content-generation">
    For Pull Requests:
    <rule>Use `git --no-pager diff-ancestor-commit` to analyze the changes being made</rule>
    <rule>Include both "What" (problem solved, feature added) and implementation details</rule>
    <rule>Reference specific code changes, files modified, and technical decisions</rule>

    For Issues:
    <rule>DO NOT use git diff commands</rule>
    <rule>Focus on "What" (problem statement, desired outcome) and "Why" (motivation, impact)</rule>
    <rule>Emphasize user-facing needs, business value, and problem context</rule>
    <rule>Avoid implementation details - that belongs in the PR</rule>

    For Both:
    <rule>Detect the primary language of the template and write in that language (default to English if unclear)</rule>
    <rule>Provide comprehensive answers to all template questions</rule>
  </phase>

  <phase name="title-generation">
    For Pull Requests:
    <rule>Create a clear, concise title that describes WHAT the PR accomplishes</rule>
    <rule>Focus on the problem solved or feature added, not HOW it was implemented</rule>
    <rule>Follow conventional commit format if the repository uses it</rule>

    For Issues:
    <rule>Create a clear title that describes the problem or desired feature</rule>
    <rule>Focus on user-facing impact and business value</rule>
    <rule>Use action-oriented language (e.g., "Add", "Fix", "Support", "Improve")</rule>

    For Both:
    <rule>Provide 2-3 title options for the user to choose from</rule>
  </phase>

  <phase name="quality-assurance">
    <rule>Ensure all required sections are completed</rule>
    <rule>Verify that the description clearly explains the purpose and impact of changes</rule>
    <rule>Check that any checklists in the template are properly addressed</rule>
    <rule>Confirm that the language and tone match the template's style</rule>
  </phase>

  <phase name="final-output">
    Save the results to a gitignored memo file:
    <rule>For PR: `memo new "pr-$(TZ=UTC-9 date +'%H%M')"`</rule>
    <rule>For Issue: `memo new "issue-$(TZ=UTC-9 date +'%H%M')"`</rule>
  </phase>
</workflow>

<rules priority="critical">
  <rule>Always preserve the original template structure and content</rule>
  <rule>Be thorough in filling out all sections - incomplete templates are not acceptable</rule>
  <rule>For PRs: Focus on both problem resolution and implementation approach; use git commands</rule>
  <rule>For Issues: Focus on problem statement, motivation, and desired outcomes; avoid implementation details</rule>
</rules>

<rules priority="standard">
  <rule>When in doubt about language, default to English</rule>
  <rule>Title should clearly communicate value to readers unfamiliar with the context</rule>
</rules>

<patterns>
  <pattern name="pr-memo-format">
# PR Generation Complete

## PR Title Candidates
1. [Option 1]
2. [Option 2]
3. [Option 3]

## Final PR Description
[Complete PR description with all template sections filled]

## Analysis Summary
- Primary changes: [brief summary]
- Files modified: [count and key files]
- Impact area: [affected components/features]
  </pattern>

  <pattern name="issue-memo-format">
# Issue Generation Complete

## Issue Title Candidates
1. [Option 1]
2. [Option 2]
3. [Option 3]

## Final Issue Description
[Complete Issue description with all template sections filled]

## Problem Summary
- Problem statement: [brief summary]
- Motivation: [why this matters]
- Expected impact: [who benefits and how]
  </pattern>
</patterns>
