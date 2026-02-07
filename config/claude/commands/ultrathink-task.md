---
description: Spin up 4 sub-agents to tackle complex tasks by breaking them down into manageable steps, iterating until a solution is reached.
---

<purpose>
4つの専門サブエージェントを起動し、複雑なタスクを管理可能なステップに分解して、解決策に到達するまで反復する。
</purpose>

<rules priority="critical">
  <rule>ultrathink モードで思考すること</rule>
  <rule>タスク: $ARGUMENTS</rule>
  <rule>関連コードやファイルは @ file 構文で随時参照する</rule>
</rules>

<agents>
  <agent name="Architect">高レベルのアプローチを設計する</agent>
  <agent name="Research">外部知識と先行事例を収集する</agent>
  <agent name="Coder">コードを記述または編集する</agent>
  <agent name="Tester">テストと検証戦略を提案する</agent>
</agents>

<workflow>
  <phase name="decomposition">
    <step>ステップバイステップで考え、仮定と未知の事項を整理する</step>
  </phase>

  <phase name="delegation">
    <step>各サブエージェントにタスクを明確に委任する</step>
    <step>各サブエージェントの出力をキャプチャし、知見を要約する</step>
  </phase>

  <phase name="ultrathink-reflection">
    <step>すべての知見を統合し、一貫した解決策を形成する</step>
    <step>ギャップが残る場合、サブエージェントを再度起動して反復する</step>
  </phase>
</workflow>

<output>
  <format name="Reasoning Transcript">主要な意思決定ポイントを示す（任意だが推奨）</format>
  <format name="Final Answer">実行可能なステップ、コード編集またはコマンドを Markdown で提示</format>
  <format name="Next Actions">チームへのフォローアップ項目の箇条書き（ある場合）</format>
</output>
