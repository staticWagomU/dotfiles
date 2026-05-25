---
name: research-plan-todo
description: Boris Tane's structured 3-phase workflow for non-trivial tasks: Research → Plan → Todo → Implement. Use when starting a new feature, refactoring, bug investigation, or any task where you want to plan deeply before coding. Creates research.md, plan.md, and todo.md as shared artifacts for iterative refinement. DO NOT write code until the plan is explicitly approved. Trigger when user says "研究して", "計画を立てて", "research and plan", "plan before coding", or starts a complex task that benefits from upfront analysis.
---

<purpose>
  Implement Boris Tane's "Read deeply, write a plan, annotate the plan until it's right, then let Claude execute the whole thing without stopping" workflow.
  The three markdown files serve as shared mutable state between Claude and the developer, replacing ambiguous chat-based instructions with concrete, reviewable artifacts.
</purpose>

<core_principle>
  NEVER write implementation code until the plan is explicitly approved by the user.
  Each phase produces a document for human review. The annotation cycle is the heart of the workflow.
</core_principle>

<workflow>
  <phase name="1-research" file="research.md">
    <description>Deep codebase understanding before any planning</description>
    <prompt_style>Use emphatic language: "deeply", "in great details", "thoroughly". Surface-level reading leads to planning failures.</prompt_style>
    <steps>
      <step>Read all relevant files, not just entry points</step>
      <step>Trace data flows and dependency chains</step>
      <step>Identify existing patterns, conventions, and constraints</step>
      <step>Note potential conflicts or risks with the requested change</step>
      <step>Find reference implementations in the codebase if available</step>
      <step>Write findings to research.md in the working repository</step>
    </steps>
    <output_format>
      ## Task Overview
      [One-sentence description of what needs to be done]

      ## Codebase Understanding
      ### Relevant Files
      - [file]: [what it does, why it's relevant]

      ### Current Architecture
      [How the relevant parts currently work]

      ### Data Flows
      [How data moves through the affected system]

      ### Existing Patterns
      [Conventions and patterns to follow]

      ### Constraints and Risks
      [Technical constraints, potential breaking changes, edge cases]

      ### Reference Implementations
      [Similar implementations in codebase or linked open source examples]
    </output_format>
    <completion_signal>
      Present research.md summary to user and ask:
      "research.md を作成しました。内容を確認して問題なければ計画フェーズに進みます。修正点があればお知らせください。"
    </completion_signal>
  </phase>

  <phase name="2-planning" file="plan.md">
    <description>Implementation plan creation with iterative annotation cycle</description>
    <steps>
      <step>Base plan on research.md findings - never plan without research</step>
      <step>Structure plan as phases with clear boundaries</step>
      <step>Include specific file paths and function names from research</step>
      <step>Make scope explicit - list what is and is NOT included</step>
      <step>Write plan to plan.md in the working repository</step>
    </steps>
    <annotation_cycle>
      <description>The core refinement loop. Repeat 1-6 times until plan is right.</description>
      <developer_action>Open plan.md in editor and add inline comments/notes directly in the document</developer_action>
      <claude_prompt>"plan.md にメモを追加しました。すべてのメモに対応してドキュメントを更新してください。実装はまだしないでください。"</claude_prompt>
      <claude_action>Address every annotation, update plan.md, do NOT write any implementation code</claude_action>
      <annotation_examples>
        <example>Add domain knowledge: "マイグレーションは drizzle:generate を使うこと"</example>
        <example>Reject approach: "このセクションは削除してください"</example>
        <example>Fix specification: "PUT ではなく PATCH を使うこと"</example>
        <example>Add constraint: "既存テストを壊さないこと"</example>
        <example>Scope control: "v1 ではここまで。この機能は含めない"</example>
      </annotation_examples>
      <repeat_until>User explicitly approves: "これでいい" / "実装してください" / "LGTM"</repeat_until>
    </annotation_cycle>
    <output_format>
      ## Goal
      [What this plan achieves and why]

      ## Scope
      ### In Scope
      - [explicit list of what will be done]
      ### Out of Scope
      - [explicit list of what will NOT be done]

      ## Approach
      [High-level strategy and key decisions with rationale]

      ## Phases
      ### Phase 1: [Name]
      **Objective**: [What this phase achieves]
      **Files**: [Specific files to modify/create]
      **Changes**: [What will change and how]

      ### Phase 2: [Name]
      ...

      ## Technical Decisions
      | Decision | Choice | Rationale |
      |----------|--------|-----------|
      | [topic]  | [what] | [why]     |

      ## Risks and Mitigations
      - [risk]: [mitigation]
    </output_format>
    <completion_signal>
      After each annotation cycle update, ask:
      "plan.md を更新しました。追加のメモがあれば plan.md に記入してください。問題なければ「実装してください」とお知らせください。"
    </completion_signal>
  </phase>

  <phase name="3-todo" file="todo.md">
    <description>Granular task breakdown that serves as progress tracker during implementation</description>
    <trigger>Create AFTER plan.md is approved, BEFORE implementation starts</trigger>
    <steps>
      <step>Decompose each plan phase into atomic, checkable tasks</step>
      <step>Tasks should be small enough to complete in one focused action</step>
      <step>Order tasks to minimize broken states (tests pass at each step if possible)</step>
      <step>Write todo.md to the working repository</step>
    </steps>
    <output_format>
      ## Todo: [Feature/Task Name]

      ### Phase 1: [Name]
      - [ ] [Specific atomic task]
      - [ ] [Specific atomic task]
      - [ ] [Specific atomic task]

      ### Phase 2: [Name]
      - [ ] [Specific atomic task]
      - [ ] [Specific atomic task]

      ### Verification
      - [ ] All existing tests pass
      - [ ] [Feature-specific verification]
      - [ ] [Edge case verification]
    </output_format>
  </phase>

  <phase name="4-implementation">
    <description>Execution without strategy changes</description>
    <trigger>Only after todo.md is created and user confirms to proceed</trigger>
    <implementation_prompt>
      "すべてのタスクを実装してください。タスクまたはフェーズが完了したら plan.md と todo.md の該当項目を完了済みにマークしてください。すべてのタスクが完了するまで止まらないでください。"
    </implementation_prompt>
    <rules>
      <rule>Mark tasks complete in todo.md as you finish them</rule>
      <rule>Mark phases complete in plan.md when all phase tasks are done</rule>
      <rule>Do not change the strategy mid-implementation - that requires a new annotation cycle</rule>
      <rule>If blocked, note the blocker in plan.md and continue with unblocked tasks</rule>
      <rule>Run type checks and tests after each phase completes</rule>
    </rules>
  </phase>
</workflow>

<file_locations>
  <rule>Create all files in the working repository root (or a .claude/ subdirectory if preferred)</rule>
  <rule>research.md, plan.md, todo.md are project artifacts, not temporary files</rule>
  <rule>These files should be gitignored or committed based on team preference</rule>
</file_locations>

<quality_boosters>
  <tip name="reference_implementations">
    Providing open source examples of similar features dramatically improves plan quality.
    Ask: "このような実装の参考例はありますか？" when research reveals no internal references.
  </tip>
  <tip name="emphatic_research_language">
    Use "deeply" and "in great details" explicitly. Vague research instructions produce surface-level findings.
  </tip>
  <tip name="scope_control">
    Actively evaluate each plan item. Remove anything that isn't essential for the current task.
    The best plan maximizes removed scope, not added features.
  </tip>
  <tip name="single_session">
    Run Research → Planning → Implementation in one session.
    Context is preserved through automatic summarization; starting fresh loses research findings.
  </tip>
</quality_boosters>

<rules priority="critical">
  <rule>NEVER write implementation code before plan.md is approved</rule>
  <rule>NEVER skip the research phase - planning without understanding leads to rework</rule>
  <rule>NEVER implement during annotation cycles - only update plan.md</rule>
  <rule>Always create todo.md before starting implementation</rule>
</rules>

<rules priority="standard">
  <rule>Repeat annotation cycle until user explicitly approves</rule>
  <rule>Keep plan.md updated with completion status during implementation</rule>
  <rule>Make scope explicit in plan.md - what is NOT included is as important as what is</rule>
</rules>

<anti_patterns>
  <avoid name="premature_implementation">
    <description>Starting to write code while still discussing the approach</description>
    <instead>Complete the full annotation cycle until plan is approved, then create todo.md, then implement</instead>
  </avoid>
  <avoid name="shallow_research">
    <description>Reading only entry points or high-level files</description>
    <instead>Trace full data flows, read all relevant files, find existing patterns</instead>
  </avoid>
  <avoid name="scope_creep_in_plan">
    <description>Including "nice to have" features in the plan</description>
    <instead>Actively remove non-essential items; minimal scope = faster, safer implementation</instead>
  </avoid>
  <avoid name="chat_based_planning">
    <description>Discussing plan changes in chat instead of annotating plan.md</description>
    <instead>Add inline annotations directly to plan.md; then ask Claude to address them</instead>
  </avoid>
  <avoid name="ignoring_risks">
    <description>Not documenting constraints and potential breaking changes in research.md</description>
    <instead>Explicitly identify risks in research.md and address them in plan.md</instead>
  </avoid>
</anti_patterns>

<best_practices>
  <practice priority="critical">Research deeply before planning - the quality of research determines the quality of the plan</practice>
  <practice priority="critical">Use inline annotations in plan.md for all plan changes, not chat messages</practice>
  <practice priority="high">Include reference implementations when available to improve plan quality</practice>
  <practice priority="high">Make scope explicit - list both what IS and IS NOT included</practice>
  <practice priority="medium">Keep all three files updated throughout the workflow as living documents</practice>
</best_practices>

<related_skills>
  <skill name="tdd">Use TDD during implementation phase for test-first development</skill>
  <skill name="tidying">Apply Tidy First before behavioral changes during implementation</skill>
  <skill name="git-commit">Commit after each phase completion with WHY-focused messages</skill>
  <skill name="requirements-definition">Use for deeper requirements analysis if task requirements are unclear</skill>
</related_skills>
