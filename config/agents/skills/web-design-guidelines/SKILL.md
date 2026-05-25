---
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
argument-hint: <file-or-pattern>
---

<purpose>
Review files for compliance with Web Interface Guidelines by fetching the latest rules from the source URL and checking code against them.
</purpose>

<rules priority="critical">
  <rule>Fetch fresh guidelines before each review from the source URL</rule>
  <rule>Apply all rules from the fetched guidelines</rule>
  <rule>Output findings in the terse `file:line` format specified in the guidelines</rule>
</rules>

<patterns>
  <pattern name="review-workflow">
    <description>How to perform a Web Interface Guidelines review</description>
    <steps>
      1. Fetch the latest guidelines from the source URL
      2. Read the specified files (or prompt user for files/pattern)
      3. Check against all rules in the fetched guidelines
      4. Output findings in the terse `file:line` format
    </steps>
  </pattern>
</patterns>

<constraints>
  <must>Use WebFetch to retrieve the latest rules from: https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md</must>
  <must>If no files specified, ask the user which files to review</must>
</constraints>
