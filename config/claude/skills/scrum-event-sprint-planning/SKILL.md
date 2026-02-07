---
name: scrum-event-sprint-planning
description: Guide Sprint Planning in AI-Agentic Scrum. Use when selecting PBI, defining Sprint Goal, or breaking into subtasks.
---

<purpose>
AI Sprint Planning facilitator guiding teams through effective Sprint Planning.
Single Source of Truth: `scrum.ts` in project root. Use `scrum-dashboard` skill for maintenance.
</purpose>

<rules priority="critical">
  <rule>1 Sprint = 1 PBI - Select the top `ready` item</rule>
  <rule>No capacity planning - AI agents have no velocity constraints</rule>
  <rule>Instant events - No time overhead</rule>
</rules>

<workflow>
  <phase name="select-pbi">
    Choose the top `ready` item from Product Backlog.

    Before selecting, verify Definition of Ready:
    - Clear user story with role, action, benefit
    - Acceptance criteria specific and testable
    - Dependencies identified and resolved
    - No blocking questions remaining
    - Has executable verification commands
  </phase>

  <phase name="define-sprint-goal">
    Based on the PBI's benefit statement.

    Characteristics:
    - Evaluable: Can clearly determine if achieved
    - Stakeholder-Understandable: Meaningful outside the team
    - Outcome-Focused: Value delivered, not tasks completed
    - Fixed: Does not change during Sprint

    Working backwards - ask:
    - "What do we want to demonstrate at Sprint Review?"
    - "What would make stakeholders excited?"
    - "What can we show as a working increment?"
  </phase>

  <phase name="break-into-subtasks">
    Each subtask = one TDD cycle.

    Subtask format in `scrum.ts`:
    ```yaml
    subtasks:
      - test: "What behavior to verify (RED phase)"
        implementation: "What to build (GREEN phase)"
        type: behavioral  # behavioral | structural
        status: pending   # pending | red | green | refactoring | completed
        commits: []
        notes: []
    ```

    Subtask types:
    - `behavioral`: New functionality (RED → GREEN → REFACTOR)
    - `structural`: Refactoring only (skips RED/GREEN, goes to refactoring)
  </phase>
</workflow>

<best_practices>
  <practice priority="critical">Keep subtasks small (completable in one TDD cycle)</practice>
  <practice priority="high">Order by logical dependency</practice>
  <practice priority="high">Each subtask independently testable</practice>
  <practice priority="medium">Update status immediately when completing</practice>
  <practice priority="medium">Mark `type`: `behavioral` or `structural`</practice>
</best_practices>

<anti_patterns>
  <avoid name="task-list-as-goal">"Complete all Sprint Backlog items" (not a goal)</avoid>
  <avoid name="output-focused-goal">"Finish Stories A, B, and C" (output-focused)</avoid>
  <avoid name="developer-only-goal">Goals only developers understand</avoid>
</anti_patterns>

<related_skills>
  <skill name="scrum-team-product-owner">Sprint Goal input, Product Backlog prioritization</skill>
  <skill name="scrum-team-developer">Task breakdown, technical feasibility</skill>
  <skill name="scrum-team-scrum-master">Facilitation, impediment removal</skill>
</related_skills>

A successful Sprint Planning produces shared understanding of WHY the Sprint matters, WHAT will be delivered, and HOW the team will achieve the Sprint Goal.
