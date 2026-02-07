---
description: Go on with the next item in the plan
---

<purpose>
プロジェクトの状態に応じて、計画の次の項目を進める。
</purpose>

<workflow>
  <phase name="state-detection">
    <step>scrum.yaml と plan.md の両方が存在する場合、ユーザーにマイグレーション方針を確認する：scrum.yaml プロセスを継続するか、plan.md プロセスに移行するか</step>
    <step>scrum.yaml のみ存在する場合、scrum プロセスを実行する</step>
    <step>plan.md のみ存在する場合、plan.md プロセスを実行する</step>
    <step>どちらも存在しない場合、新規 plan.md を作成する</step>
  </phase>

  <phase name="scrum-process">
    <step>product backlog refinement を実施</step>
    <step>sprint planning を実施</step>
    <step>tdd skill を用いて sprint execution を実施</step>
    <step>sprint review を実施</step>
    <step>sprint retrospective を実施</step>
    <step>scrum.yaml compaction を実施</step>
    <step>リファイン可能な PBI がなくなるまで繰り返す</step>
  </phase>

  <phase name="plan-process">
    <step>次の未マークのテストを見つける</step>
    <step>テストを実装する</step>
    <step>そのテストをパスさせるのに十分なコードのみを実装する</step>
  </phase>

  <phase name="new-plan">
    <step>機能のために実装するテストのリストを含む新規 plan.md を作成する</step>
    <step>計画の最初のテストから開始する</step>
  </phase>
</workflow>

<constraints>
  <must>作業中にドキュメント内のタスクのステータスを更新する</must>
</constraints>
