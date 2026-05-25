---
name: adr
description: Manage Architecture Decision Records and ADR-aligned development. Use when user says "we should use", "let's go with", asks "why did we choose X?", implements a feature that may have an ADR, updates ADR status, or needs to check alignment with existing decisions.
---

<purpose>
Manage Architecture Decision Records (ADRs) throughout their lifecycle: read existing decisions, write new ones, and ensure development aligns with documented decisions.
</purpose>

<rules priority="critical">
  <rule>Title must clearly state the decision (not the problem)</rule>
  <rule>Context must explain WHY this decision is needed now</rule>
  <rule>At least 2 options must be genuinely considered</rule>
  <rule>Consequences must include both positive AND negative impacts</rule>
</rules>

<rules priority="standard">
  <rule>See `template.md` for the MADR structure (status, context, drivers, options, consequences)</rule>
  <rule>See `operations.md` for directory discovery, naming conventions, commit integration, deprecation (`_` prefix), and ADR-aligned development workflow</rule>
  <rule>See `queries.md` for finding ADRs by topic, status, or relationship</rule>
</rules>

<patterns>
  <pattern name="read-mode">
    <description>Finding and understanding existing decisions</description>
    <trigger>"why did we choose X?", "what's our approach to Y?", "is there an ADR for Z?"</trigger>
    <steps>
      1. Discover ADR directory (see `operations.md`)
      2. Search for relevant ADRs by keyword/topic
      3. Summarize the decision and its rationale
      4. Note if the ADR is active, deprecated, or superseded
    </steps>
  </pattern>

  <pattern name="write-mode">
    <description>Creating new architecture decision records</description>
    <trigger>"we should use", "let's go with", "I've decided to", trade-off discussions</trigger>
    <steps>
      1. Check for existing ADRs on the topic (may need to supersede)
      2. Gather information through clarifying questions
      3. Draft ADR using `template.md`
      4. Save and commit (amend later if needed)
    </steps>
  </pattern>

  <pattern name="adr-aligned-development">
    <description>Ensuring development aligns with documented decisions</description>
    <trigger>Implementing features, making architectural changes, deviating from existing patterns</trigger>
    <steps>
      1. Before implementation: Check for relevant ADRs
      2. During implementation: Reference ADR in commits
      3. On completion: Update ADR status (proposed -> accepted)
      4. On deviation: Create superseding ADR, deprecate old one with `_` prefix
    </steps>
  </pattern>
</patterns>

<best_practices>
  <practice priority="critical">Decision drivers must link to actual project constraints</practice>
  <practice priority="high">Confirmation section must describe how to validate the decision</practice>
  <practice priority="high">Link to related ADRs when relevant</practice>
  <practice priority="medium">Update status when implemented or superseded</practice>
</best_practices>

<anti_patterns>
  <avoid name="Decision without options">
    <description>Recording a decision without documenting alternatives</description>
    <instead>Always document alternatives considered</instead>
  </avoid>
  <avoid name="Vague consequences">
    <description>Generic or unclear trade-offs</description>
    <instead>Be specific about trade-offs</instead>
  </avoid>
  <avoid name="Missing why">
    <description>ADR doesn't answer "why this, why now"</description>
    <instead>The ADR should answer "why this, why now"</instead>
  </avoid>
  <avoid name="Orphan ADRs">
    <description>ADRs not linked to related decisions</description>
    <instead>Link to related ADRs when relevant</instead>
  </avoid>
  <avoid name="Stale ADRs">
    <description>ADRs with outdated status</description>
    <instead>Update status when implemented or superseded</instead>
  </avoid>
  <avoid name="Undocumented deviation">
    <description>Deviating from an ADR without recording the change</description>
    <instead>If you deviate from an ADR, create a new one</instead>
  </avoid>
</anti_patterns>

<reference>Based on [MADR - Markdown Architectural Decision Records](https://adr.github.io/madr/) (Version 4.0, 2024)</reference>
