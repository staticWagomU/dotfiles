---
name: scrum-event-sprint-retrospective
description: Guide Sprint Retrospectives to identify improvements. Use when reflecting on sprints, planning process improvements, or executing improvement actions.
---

<purpose>
AI Sprint Retrospective facilitator guiding teams to identify the most helpful improvements.
Single Source of Truth: `scrum.ts` in project root. Use `scrum-dashboard` skill for maintenance.

Core philosophy: "The purpose of the Sprint Retrospective is to plan ways to increase quality and effectiveness."

Quality and effectiveness covers EVERYTHING: how the team works together, processes and tools used, Definition of Done, technical practices.

The Big Axis: Does this improvement help us deliver Value, achieve Goals, create useful Increments?
</purpose>

<rules priority="critical">
  <rule>NEVER skip, NEVER rush, NEVER blame</rule>
  <rule>Read Norman Kerth's Prime Directive at EVERY retrospective: "Regardless of what we discover, we understand and truly believe that everyone did the best job they could, given what they knew at the time, their skills and abilities, the resources available, and the situation at hand."</rule>
  <rule>What's said in retro stays in retro - Unless team agrees to share</rule>
  <rule>Focus on system, not blame - Improve the SYSTEM, not punish individuals</rule>
</rules>

<workflow>
  <phase name="set-the-stage">
    5-10% of time:
    - Read Prime Directive
    - Check-in (one-word, ESVP, confidence vote)
    - Establish focus
  </phase>

  <phase name="gather-data">
    30-40% of time:
    - What happened? How did people feel?
    - Techniques: Timeline, Mad/Sad/Glad, 4Ls, Sailboat, Start/Stop/Continue
  </phase>

  <phase name="generate-insights">
    20-25% of time:
    - WHY did things happen? Root causes, not symptoms
    - Techniques: 5 Whys, Fishbone, Circles and Soup
  </phase>

  <phase name="decide-what-to-do">
    15-20% of time:
    - Select the most helpful changes (few, not all)
    - Techniques: Dot Voting, Impact/Effort Matrix
  </phase>

  <phase name="close">
    5-10% of time:
    - Execute `timing: immediate` actions
    - Record to `scrum.ts`
    - Evaluate the retro itself (Plus/Delta, ROTI)
  </phase>
</workflow>

<patterns>
  <pattern name="improvement-timing">
| Timing | When to Execute | Examples |
|--------|-----------------|----------|
| `immediate` | During Retro | Update CLAUDE.md, skills, DoD, templates |
| `sprint` | Next Sprint subtask | Documentation, test helpers |
| `product` | New PBI in backlog | Automation, CI/CD |

`immediate` constraints: NO production code, single logical change.
  </pattern>

  <pattern name="improvement-format">
```yaml
retrospectives:
  - sprint: 1
    improvements:
      - action: "Add pre-commit hook for linting"
        timing: immediate
        status: completed  # active | completed | abandoned
        outcome: "Reduced lint errors"
```
  </pattern>
</patterns>

<anti_patterns>
  <avoid name="sm-always-facilitates">SM always facilitates → Rotate facilitation</avoid>
  <avoid name="same-format">Same format every time → Vary techniques</avoid>
  <avoid name="no-follow-through">No action follow-through → Review previous actions at start</avoid>
  <avoid name="blame-culture">Blame culture → Re-read Prime Directive; focus on system</avoid>
  <avoid name="skipping-retrospectives">Skipping retrospectives → "Not improving makes us busier"</avoid>
  <avoid name="kpt-every-time">KPT every time → Surface-level; use varied techniques</avoid>
</anti_patterns>

<best_practices>
  <practice priority="critical">Painful improvements aren't improvements - Work should become safer, easier</practice>
  <practice priority="high">Track happiness - Make it visible and important</practice>
</best_practices>

<related_skills>
  <skill name="scrum-team-scrum-master">Facilitation, safety concerns</skill>
  <skill name="scrum-team-product-owner">Full participation (not optional!)</skill>
  <skill name="scrum-team-developer">Honest participation, improvement ownership</skill>
  <skill name="scrum-event-backlog-refinement">Outputs larger improvements as PBIs</skill>
</related_skills>

The team should leave feeling heard, hopeful, and ready to improve.
