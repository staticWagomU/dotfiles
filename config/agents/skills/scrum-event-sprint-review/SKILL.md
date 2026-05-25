---
name: scrum-event-sprint-review
description: Verify Definition of Done and acceptance criteria for Sprint increments. Use when completing sprints, running verification commands, or preparing for acceptance.
---

<purpose>
AI Sprint Review facilitator verifying increments and determining acceptance.
Single Source of Truth: `scrum.ts` in project root. Use `scrum-dashboard` skill for maintenance.
</purpose>

<rules priority="critical">
  <rule>Show the Increment above all else - Working software, not slides</rule>
  <rule>NEVER present incomplete work - Creates false expectations</rule>
  <rule>NEVER skip even with no completed Increment - Discuss the situation</rule>
  <rule>Sprint Review is NOT just a demo - It is a collaborative working session</rule>
</rules>

<rules priority="standard">
  <rule>Transparency: Show only completed Increments (meeting DoD)</rule>
  <rule>Inspection: Examine product, gather feedback</rule>
  <rule>Adaptation: Adjust Product Backlog based on feedback</rule>
</rules>

<patterns>
  <pattern name="achievement-vs-activity">
| Achievement (Present) | Activity (Do NOT Present) |
|----------------------|---------------------------|
| "Users can now reset passwords" | "We worked on password reset" |
| "API response time: 500ms → 100ms" | "We did performance work" |
| "Mobile checkout is complete" | "Mobile checkout is 80% done" |
  </pattern>
</patterns>

<workflow>
  <phase name="run-dod-checks">
    Run Definition of Done checks from scrum.ts:
    ```bash
    npm test
    npm run lint
    deno check scrum.ts
    ```
  </phase>

  <phase name="run-acceptance-verification">
    Each acceptance criterion has an executable command - run them all.
  </phase>

  <phase name="determine-acceptance">
    - All pass → Move PBI to `completed`
    - Any fail → Return with details
  </phase>

  <phase name="failure-handling-minor">
    Minor Fix Possible:
    ```yaml
    # Keep sprint.status = "in_progress"
    # Add fix subtask:
    subtasks:
      - test: "Fix [specific issue]"
        implementation: "Resolve the failure"
        type: behavioral
        status: pending
    # Re-run Review after fix
    ```
  </phase>

  <phase name="failure-handling-major">
    Sprint Goal Unachievable:
    1. Report to Product Owner
    2. Choose:
       - Scope reduction: Split PBI, complete achievable part
       - Sprint cancellation: Set `sprint.status = "cancelled"`, return PBI
    3. Always run Retrospective to analyze root cause
  </phase>

  <phase name="no-increment">
    Sprint Review STILL happens:
    - Acknowledge openly no Increment met DoD
    - Discuss why items weren't completed
    - Continue with environmental updates
    - Gather stakeholder input on priorities
    - Assess Product Goal impact
  </phase>
</workflow>

<best_practices>
  <practice priority="critical">Guide discussion: How does this Sprint contribute to Product Goal?</practice>
  <practice priority="high">Is Product Goal still achievable at current pace?</practice>
  <practice priority="medium">What is planned next toward the Goal?</practice>
</best_practices>

<related_skills>
  <skill name="scrum-team-product-owner">PBI completion status, acceptance decision</skill>
  <skill name="scrum-team-developer">Demo preparation, DoD verification</skill>
  <skill name="scrum-team-scrum-master">Facilitation, impediment identification</skill>
  <skill name="scrum-event-sprint-retrospective">Outputs Review outcomes for reflection</skill>
</related_skills>

Sprint Review is a collaborative working session for inspecting the product and adapting based on feedback. Transparency is paramount - show only what is truly complete.
