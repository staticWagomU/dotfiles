---
name: implements
description: >
  Orchestrate full implementation lifecycle with sub-agent team delegation
  through 6 strict phases: Tidy First -> Implement -> TDD Red -> Green ->
  Refactor -> Tidy After. The leader gives instructions only; sub-agents
  do all research and coding. Use when user explicitly invokes /implements
  or says "実装して", "これを実装", "implement this". NOT for quick fixes,
  single-file edits, or tasks that don't warrant the full 6-phase ceremony.
---

<purpose>
Orchestrate implementation through a disciplined 6-phase workflow.
The leader (you) ONLY gives instructions and reviews results.
All research, coding, and test execution is delegated to sub-agents.
</purpose>

<core_principle>
You are the LEADER. You do NOT read files, write code, or run tests yourself.
You launch sub-agents for every action, review their results, and decide the next step.
The only tools you use directly are Agent (to delegate) and communication with the user.
</core_principle>

<rules priority="critical">
  <rule>NEVER write code yourself - always delegate to sub-agents</rule>
  <rule>NEVER skip phases - all 6 phases execute in strict order</rule>
  <rule>NEVER proceed to the next phase until the current phase is verified complete</rule>
  <rule>Each phase boundary requires a status check before advancing</rule>
  <rule>If a sub-agent reports failure, diagnose and re-delegate with improved instructions (max 2 retries per phase)</rule>
  <rule>After 2 failed retries, escalate to the user with diagnosis and options</rule>
</rules>

<!-- ============================================================
     CONTEXT BRIDGE
     Sub-agents do NOT share memory. The leader MUST pass context
     from each phase to the next via delegation prompts.
     ============================================================ -->
<context_bridge>
  <principle>Every delegation prompt MUST include relevant context from prior phases</principle>
  <what_to_pass>
    <item>Phase 1 -> 2: Target files, existing patterns, conventions discovered, constraints</item>
    <item>Phase 2 -> 3: Changed files, new/modified functions, intended behavior, edge cases identified</item>
    <item>Phase 3 -> 4: Test file path, test name, failure message, what the test expects</item>
    <item>Phase 4 -> 5: All modified files, test file paths, areas of duplication or complexity</item>
    <item>Phase 5 -> 6: Full list of changed files across all phases, overall change summary</item>
  </what_to_pass>
  <format>
    Include a "## Context from prior phases" section in every delegation prompt after Phase 1.
    Keep it concise: file paths, function names, key decisions - not full code dumps.
  </format>
</context_bridge>

<!-- ============================================================
     PLAN.MD INTEGRATION
     ============================================================ -->
<plan_integration>
  <rule>Before Phase 1, check if plan.md or todo.md exists in the working repository</rule>
  <rule>If plan.md exists, use it as the source of truth for what to implement in Phase 2</rule>
  <rule>If todo.md exists, update task checkboxes as phases complete</rule>
  <rule>If neither exists, proceed normally - the user's instruction is the specification</rule>
</plan_integration>

<workflow>
  <!-- ========================================
       PHASE 1: TIDY FIRST
       ======================================== -->
  <phase order="1" name="Tidy First" skill="/tidy:first">
    <description>Structural improvements before behavioral change</description>
    <no_work_rule>
      If the target is new code (new file, no existing code to tidy), acknowledge the phase:
      "Phase 1 (Tidy First): No existing code to tidy. Proceeding to Phase 2."
      Do NOT launch sub-agents for empty work.
    </no_work_rule>
    <leader_actions>
      <action>Launch Explore sub-agent to investigate the target code area</action>
      <action>Review findings and identify tidying opportunities</action>
      <action>If tidying needed: launch implementation sub-agent with specific instructions</action>
      <action>Verify no behavior changed via sub-agent running tests</action>
      <action>Delegate git commit (refactor: type) via sub-agent</action>
    </leader_actions>
    <delegate_prompt>
      Investigate [target area] for structural improvements.
      Apply Tidy First principles: guard clauses, dead code removal, rename for clarity, normalize symmetries.
      Structure only - NO behavior changes. Run all tests to confirm nothing broke.
      Commit each tidying as: refactor: [what you tidied]
    </delegate_prompt>
    <exit_criteria>All tests pass, tidying commits made (or no work needed), no behavioral changes</exit_criteria>
    <user_checkpoint>
      After Phase 1 completes, report structural changes to the user:
      "Phase 1 (Tidy First) complete. [summary of changes]. Phase 2 (Implement) に進みます。"
      If changes were significant, ask: "構造変更を確認しますか？問題なければ実装に進みます。"
    </user_checkpoint>
  </phase>

  <!-- ========================================
       PHASE 2: IMPLEMENT
       ======================================== -->
  <phase order="2" name="Implement" skill="behavioral change">
    <description>Make the behavioral change (feature/fix) - the happy path</description>
    <leader_actions>
      <action>Check for plan.md/todo.md and include relevant sections in delegation</action>
      <action>Launch Explore sub-agent to deeply research what needs to change</action>
      <action>Review research and formulate implementation instructions</action>
      <action>Launch implementation sub-agent with precise change instructions</action>
      <action>Review the result via sub-agent before proceeding to TDD</action>
    </leader_actions>
    <delegate_prompt>
      ## Context from prior phases
      [Files examined, patterns found, constraints identified in Phase 1]

      ## Task
      Implement [specific behavioral change] based on research findings.
      Follow existing patterns and conventions found in the codebase.
      Write minimal, focused code that achieves the HAPPY PATH.
      Do NOT write tests yet - that comes in the next phase.
      Do NOT handle edge cases exhaustively - TDD will drive those.
    </delegate_prompt>
    <exit_criteria>Implementation complete, code compiles/loads without errors</exit_criteria>
  </phase>

  <!-- ========================================
       PHASE 3-5: TDD LOOP
       Red -> Green -> Refactor, repeat for each behavior
       ======================================== -->
  <tdd_loop>
    <description>
      Phases 3-5 form a LOOP. After Phase 2 implements the happy path,
      the TDD loop hardens the implementation by targeting:
      - Edge cases not yet handled
      - Boundary conditions
      - Error scenarios
      - Integration points
      Each iteration: Red (write failing test) -> Green (fix it) -> Refactor (clean up)
      Loop until the leader judges all important behaviors are covered.
    </description>
    <loop_control>
      <first_iteration>Target the most critical untested behavior</first_iteration>
      <continue_when>Important edge cases, error paths, or boundary conditions remain untested</continue_when>
      <stop_when>All significant behaviors are tested, diminishing returns reached</stop_when>
      <max_iterations>5 (prevent infinite loops; escalate to user if more needed)</max_iterations>
    </loop_control>
  </tdd_loop>

  <phase order="3" name="TDD Red" skill="/tdd:red">
    <description>Write ONE small failing test targeting an uncovered behavior</description>
    <rationale>
      Since Phase 2 already implemented the happy path, Red tests target what is NOT yet working:
      edge cases, boundary conditions, error handling, and integration points.
      If a test passes immediately, the behavior is already covered - pick a harder case.
    </rationale>
    <leader_actions>
      <action>Identify the next uncovered behavior to test (edge case, error path, boundary)</action>
      <action>Instruct sub-agent to write exactly ONE failing test for that behavior</action>
      <action>Verify the test fails for the RIGHT reason via sub-agent</action>
      <action>If test passes: the behavior is already handled - pick the next uncovered behavior</action>
    </leader_actions>
    <delegate_prompt>
      ## Context from prior phases
      [Changed files, implemented behavior, what IS and IS NOT yet tested]

      ## Task
      Write ONE failing test targeting this specific uncovered behavior:
      [describe the edge case / boundary condition / error scenario]

      Run the test and confirm it FAILS for the expected reason.
      If it passes, report back - that behavior is already covered.
      The failure message must clearly indicate what behavior is being tested.
    </delegate_prompt>
    <exit_criteria>Exactly one new test exists and it fails for the expected reason</exit_criteria>
  </phase>

  <phase order="4" name="TDD Green" skill="/tdd:green">
    <description>Make the failing test pass with minimal code</description>
    <leader_actions>
      <action>Instruct sub-agent to make the test pass with minimal changes</action>
      <action>Verify ALL tests pass (not just the new one) via sub-agent</action>
      <action>Delegate git commit (feat:/fix: type) via sub-agent</action>
    </leader_actions>
    <delegate_prompt>
      ## Context from prior phases
      [Test file, test name, failure message, what needs to change]

      ## Task
      Make the failing test pass with the MINIMUM code change needed.
      Run ALL tests to confirm nothing is broken.
      Commit as: feat: [or fix:] [what behavioral change was made]
    </delegate_prompt>
    <exit_criteria>All tests pass, behavioral change committed</exit_criteria>
  </phase>

  <phase order="5" name="TDD Refactor" skill="/tdd:refactor">
    <description>Improve code quality while keeping all tests green</description>
    <no_work_rule>
      If code is already clean after Green, acknowledge and skip:
      "Phase 5 (TDD Refactor): Code is clean, no refactoring needed this iteration."
    </no_work_rule>
    <leader_actions>
      <action>Launch sub-agent to identify duplication, complexity, or naming issues</action>
      <action>If issues found: instruct sub-agent to refactor one thing at a time</action>
      <action>Verify tests stay green after each refactoring step via sub-agent</action>
      <action>Delegate git commit (refactor: type) for each step via sub-agent</action>
      <action>LOOP CHECK: Are there more uncovered behaviors to test? If yes, return to Phase 3</action>
    </leader_actions>
    <delegate_prompt>
      ## Context from prior phases
      [All modified files, test files, areas of concern]

      ## Task
      Review the implementation and test code for:
      - Duplication between test and production code
      - Unclear naming that could be improved
      - Overly complex logic that could be simplified
      Refactor ONE thing at a time. Run ALL tests after each change.
      Commit each refactoring step as: refactor: [what you improved]
    </delegate_prompt>
    <exit_criteria>All tests pass, code quality improved (or no work needed), refactor commits made</exit_criteria>
    <loop_decision>
      After Phase 5 completes, the leader evaluates:
      - Are there important uncovered behaviors? -> Return to Phase 3 (Red)
      - Are all significant behaviors tested? -> Proceed to Phase 6 (Tidy After)
      Report to user: "TDD iteration [N] complete. [summary]. [continuing/proceeding to Tidy After]."
    </loop_decision>
  </phase>

  <!-- ========================================
       PHASE 6: TIDY AFTER
       ======================================== -->
  <phase order="6" name="Tidy After" skill="/tidy:after">
    <description>Clean up code after behavioral change is complete</description>
    <no_work_rule>
      If code is already clean after TDD Refactor iterations, acknowledge:
      "Phase 6 (Tidy After): Code is well-structured from TDD iterations. No additional tidying needed."
    </no_work_rule>
    <leader_actions>
      <action>Launch sub-agent to review the FULL change set across all phases</action>
      <action>Instruct sub-agent to apply post-implementation tidying</action>
      <action>Verify tests stay green via sub-agent</action>
      <action>Delegate git commit (refactor: type) via sub-agent</action>
    </leader_actions>
    <delegate_prompt>
      ## Context from prior phases
      [Complete list of all files changed across all phases, overall summary]

      ## Task
      Review the full change set. Now that the feature is complete, look for:
      - Better structure that is now apparent
      - Duplication introduced across files
      - Abstractions that make more sense now
      Apply tidying changes. Structure only - no new behavior.
      Run ALL tests. Commit as: refactor: [what you tidied]
    </delegate_prompt>
    <exit_criteria>All tests pass, post-implementation tidying committed (or no work needed)</exit_criteria>
  </phase>
</workflow>

<!-- ============================================================
     ERROR RECOVERY
     ============================================================ -->
<error_recovery>
  <strategy name="retry-with-better-instructions">
    <trigger>Sub-agent reports failure or produces incorrect result</trigger>
    <steps>
      <step>Analyze the failure: What went wrong? Missing context? Wrong approach?</step>
      <step>Improve the delegation prompt: Add missing context, clarify expectations, constrain approach</step>
      <step>Re-delegate to a NEW sub-agent (fresh context avoids compounding errors)</step>
    </steps>
    <max_retries>2 per phase</max_retries>
  </strategy>
  <strategy name="escalate-to-user">
    <trigger>2 retries exhausted for the same phase</trigger>
    <steps>
      <step>Present diagnosis to user: what was attempted, what failed, why</step>
      <step>Offer options: adjust approach, simplify scope, provide additional context</step>
      <step>Wait for user guidance before re-attempting</step>
    </steps>
  </strategy>
  <strategy name="test-failure-in-green">
    <trigger>Existing tests break during TDD Green phase</trigger>
    <steps>
      <step>Instruct sub-agent to identify which existing tests broke and why</step>
      <step>Fix the implementation to satisfy BOTH new and existing tests</step>
      <step>If impossible: escalate to user - the new behavior may conflict with existing behavior</step>
    </steps>
  </strategy>
</error_recovery>

<leader_report_format>
  After completing all phases, present a summary:

  ## Implementation Complete

  ### Phase Results
  | Phase | Status | Commits | TDD Iterations |
  |-------|--------|---------|----------------|
  | 1. Tidy First | done/skipped | refactor: ... | - |
  | 2. Implement | done | - | - |
  | 3-5. TDD Loop | done | feat/fix: ..., refactor: ... | N iterations |
  | 6. Tidy After | done/skipped | refactor: ... | - |

  ### TDD Coverage
  - Iteration 1: [behavior tested]
  - Iteration 2: [behavior tested]
  - ...

  ### Key Decisions
  - [decisions made during implementation]

  ### Notes
  - [anything the user should know]
</leader_report_format>

<delegation_patterns>
  <pattern name="research">
    <agent_type>Explore</agent_type>
    <when>Understanding code, finding patterns, identifying what to change</when>
  </pattern>
  <pattern name="implementation">
    <agent_type>general-purpose</agent_type>
    <when>Writing code, modifying files, running tests, making commits</when>
  </pattern>
  <pattern name="parallel-research">
    <description>Launch multiple Explore agents in parallel when researching independent areas</description>
    <when>Multiple unrelated code areas need investigation</when>
  </pattern>
</delegation_patterns>

<anti_patterns>
  <avoid name="Leader writes code">
    <description>The leader directly edits files or runs commands</description>
    <instead>Always delegate to a sub-agent</instead>
  </avoid>
  <avoid name="Skipping phases">
    <description>Jumping from Implement to Tidy After, skipping TDD</description>
    <instead>Execute all 6 phases in strict order; acknowledge and pass through if no work</instead>
  </avoid>
  <avoid name="Big bang delegation">
    <description>Delegating all 6 phases to a single sub-agent</description>
    <instead>Delegate phase by phase, reviewing results at each boundary</instead>
  </avoid>
  <avoid name="Fixing sub-agent failures yourself">
    <description>When a sub-agent fails, the leader writes the fix</description>
    <instead>Diagnose, improve instructions, re-delegate (max 2 retries then escalate)</instead>
  </avoid>
  <avoid name="Context-free delegation">
    <description>Delegating to a sub-agent without passing prior phase context</description>
    <instead>Always include "Context from prior phases" section in delegation prompts</instead>
  </avoid>
  <avoid name="Infinite TDD loop">
    <description>Endlessly adding tests without converging</description>
    <instead>Max 5 TDD iterations; focus on significant behaviors, not exhaustive coverage</instead>
  </avoid>
</anti_patterns>

<best_practices>
  <practice priority="critical">Review sub-agent results at every phase boundary before proceeding</practice>
  <practice priority="critical">Separate structural commits (refactor:) from behavioral commits (feat:/fix:)</practice>
  <practice priority="critical">Pass context between phases - sub-agents have no shared memory</practice>
  <practice priority="high">Use Explore agents for research, general-purpose agents for implementation</practice>
  <practice priority="high">Launch parallel sub-agents when investigating independent code areas</practice>
  <practice priority="high">TDD Red targets uncovered edge cases - not already-working happy paths</practice>
  <practice priority="medium">Keep delegation prompts specific - include file paths, function names, exact expectations</practice>
  <practice priority="medium">Acknowledge phases with no work rather than launching empty sub-agents</practice>
</best_practices>

<related_skills>
  <skill name="tidying">Phases 1 and 6 apply Tidy First / Tidy After principles</skill>
  <skill name="tdd">Phases 3-5 follow Kent Beck's Red-Green-Refactor cycle</skill>
  <skill name="git-commit">Every phase produces appropriately typed commits</skill>
  <skill name="refactoring">Phase 5 uses Martin Fowler's refactoring patterns</skill>
  <skill name="code-priority">State > Coupling > Complexity > Code guides all design decisions</skill>
  <skill name="research-plan-todo">If plan.md exists, Phase 2 uses it as implementation specification</skill>
</related_skills>
