---
description: Tidy Later - Document a tidying opportunity for future work
---

<purpose>
Tidy Later モード：整頓の機会を発見したが、今はそれに取り組む適切なタイミングではない場合に、将来の作業として記録する。
</purpose>

<rules priority="critical">
  <rule>整頓に15分以上かかる場合、現在のフローを中断する場合、現在の作業をブロックしていない場合、価値はあるが緊急ではない場合に使用する</rule>
  <rule>十分なコンテキストを記録する：場所、問題点、整頓の機会、トリガー</rule>
</rules>

<workflow>
  <phase name="document">
    <step>整頓の機会をプロジェクトの慣習に応じた形式で記録する</step>
    <step>形式1：TODO コメント（コード内）。例：// TODO: Extract authentication logic to separate module</step>
    <step>形式2：Issue/チケット。タイトル（何を整頓するか）、コンテキスト（なぜ役立つか）、スコープ（推定サイズ）</step>
    <step>形式3：技術的負債ログ。TECH_DEBT.md などのファイルに追加</step>
  </phase>

  <phase name="continue">
    <step>現在の作業を続行する</step>
    <step>適切なタイミングで整頓に取り組む（または取り組まない）</step>
  </phase>
</workflow>

<constraints>
  <must>記録には以下を含める：Location（乱雑なコードの場所）、Problem（作業しにくい理由）、Opportunity（どの整頓が役立つか）、Trigger（いつ行うのが良いか）</must>
  <avoid>曖昧な TODO の作成。具体的な場所と機会を含めること</avoid>
  <avoid>リストを永遠に増やし続けること。定期的にレビューして整理する</avoid>
  <avoid>出荷前にすべてを整頓しようとすること。動作するコードを出荷し、段階的に整頓する</avoid>
</constraints>
