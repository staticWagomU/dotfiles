---
name: scrum-event-backlog-refinement
description: Transform PBIs into ready status for AI execution. Use when refining backlog items, writing acceptance criteria, splitting stories, or ensuring Definition of Ready.
---

<purpose>
AI Backlog Refinement facilitator transforming PBIs into `ready` status where AI agents can execute them autonomously.
Single Source of Truth: `scrum.ts` in project root. Use `scrum-dashboard` skill for maintenance.
</purpose>

<rules priority="critical">
  <rule>Ready = AI can complete it without asking humans</rule>
  <rule>A PBI is `ready` when: AI can complete without human input, User Story format (role, capability, benefit), acceptance criteria have executable verification commands, dependencies are resolved, INVEST principles are satisfied</rule>
  <rule>Every acceptance criterion must have an executable verification command</rule>
</rules>

<patterns>
  <pattern name="invest-principles">
| Principle | AI-Agentic Interpretation |
|-----------|---------------------------|
| **Independent** | Can reprioritize freely, AND no human dependencies |
| **Negotiable** | Clear outcome, flexible implementation |
| **Valuable** | User Story format makes value explicit |
| **Estimable** | All information needed is available |
| **Small** | Smallest unit delivering user value |
| **Testable** | Has executable verification commands |
  </pattern>

  <pattern name="backlog-granularity">
```
┌─────────────────┐
│  FINE-GRAINED   │  ← Ready for upcoming sprints (1-5 points)
├─────────────────┤
│    MEDIUM       │  ← Next 2-3 sprints, may need splitting
├─────────────────┤
│ COARSE-GRAINED  │  ← Future items, Just-in-Time refinement
└─────────────────┘
```

When items move up in priority, split to sprint-sized pieces. Don't refine everything upfront.
  </pattern>

  <pattern name="3c-principle">
Ron Jeffries' 3C Principle:
- Card: Story on card with estimates (intentionally brief)
- Conversation: Details drawn out through PO discussion
- Confirmation: Acceptance tests confirm correct implementation
  </pattern>
</patterns>

<workflow>
  <phase name="autonomous-refinement">
    Explore codebase, propose acceptance criteria, identify dependencies.
  </phase>

  <phase name="ai-can-fill-gaps">
    If AI can fill all gaps → Update status to `ready`.
  </phase>

  <phase name="story-too-big">
    If story is too big → Split into smaller stories (see `splitting.md`).
  </phase>

  <phase name="story-lacks-value">
    If story lacks value alone → Merge with adjacent PBI (see `splitting.md` Anti-Patterns).
  </phase>

  <phase name="needs-human-help">
    If needs human help → Keep as `refining`, document questions.
  </phase>
</workflow>

<related_skills>
  <skill name="splitting.md">When to split large PBIs AND when to merge small ones</skill>
  <skill name="anti-patterns.md">Common PBI mistakes to avoid</skill>
  <skill name="scrum-team-product-owner">Product Goal alignment, value prioritization</skill>
  <skill name="scrum-team-developer">Technical feasibility, effort estimation</skill>
  <skill name="scrum-team-scrum-master">Definition of Ready enforcement</skill>
</related_skills>
