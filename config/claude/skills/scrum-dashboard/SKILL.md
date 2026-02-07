---
name: scrum-dashboard
description: Maintain scrum.ts dashboard following Agentic Scrum principles. Use when editing scrum.ts, updating sprint status, or managing Product Backlog.
---

<purpose>
Maintain the scrum.ts dashboard as the single source of truth for all Scrum artifacts.
</purpose>

<rules priority="critical">
  <rule>Single Source of Truth: All Scrum artifacts live in `scrum.ts`</rule>
  <rule>Git is History: No timestamps needed</rule>
  <rule>Order is Priority: Higher in `product_backlog` array = higher priority</rule>
  <rule>Schema is Fixed: Only edit the data section; request human review for type changes</rule>
</rules>

<patterns>
  <pattern name="validation">
```bash
deno check scrum.ts          # Type check after edits
deno run scrum.ts | jq '.'   # Query data as JSON
wc -l scrum.ts               # Line count (target: ≤300, hard limit: 600)
```
  </pattern>

  <pattern name="compaction">
After retrospective, prune if >300 lines:
- `completed`: Keep latest 2-3 sprints only
- `retrospectives`: Remove `completed`/`abandoned` improvements
- `product_backlog`: Remove `done` PBIs
  </pattern>
</patterns>

<related_skills>
  <skill name="scrum.template.ts">`/scrum:init` - Use as starting point for new dashboards</skill>
  <skill name="scrum-event-*">Deep facilitation for sprint events</skill>
</related_skills>
