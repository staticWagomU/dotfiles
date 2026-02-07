---
description: Execute the REFACTOR phase - Improve code quality while keeping tests green
---

<purpose>
TDD REFACTOR フェーズ：すべてのテストをパスさせたまま、コード品質を改善する。
</purpose>

<rules priority="critical">
  <rule>すべてのテストがパスしている場合のみリファクタリングする（GREEN 状態であること）</rule>
  <rule>小さな変更のたびにテストを実行する（最後だけではない）</rule>
  <rule>このフェーズは繰り返し可能。必要に応じて複数のリファクタリングを行う</rule>
  <rule>成功したリファクタリングごとにコミットする</rule>
  <rule>振る舞いの変更は行わない</rule>
</rules>

<rules priority="standard">
  <rule>主な目的はテストコードとプロダクションコード間の重複を除去すること</rule>
  <rule>各リファクタリングコミットは小さく焦点を絞る：変更行数 20行未満、理想的には1ファイルのみ</rule>
  <rule>テストが失敗した場合は即座にリバートする（git checkout -- .）</rule>
</rules>

<workflow>
  <phase name="identify">
    <step>重複したロジック、マジックナンバー/文字列、類似コードパターン、意図を隠す不明瞭な命名を探す</step>
    <step>1つの小さな改善を特定する</step>
  </phase>

  <phase name="refactor-step">
    <step>変更を行う（差分を小さく保つ）</step>
    <step>すべてのテストを実行する</step>
    <step>テストがパスした場合：/git:commit で refactor: タイプのコミット</step>
    <step>テストが失敗した場合：即座にリバートし、より小さなステップを取る</step>
  </phase>

  <phase name="iterate">
    <step>さらに改善が必要な場合は identify フェーズに戻る</step>
    <step>満足したら次の TDD サイクルを /tdd:red で開始する</step>
  </phase>
</workflow>

<constraints>
  <must>許可される操作：明確さのためのリネーム、関数/メソッドの抽出、重複の除去、式の簡素化</must>
  <must>変更は純粋に構造的であること（振る舞いの変更なし）</must>
  <avoid>新機能の追加（次の RED フェーズで行う）</avoid>
  <avoid>バグ修正（まず失敗するテストを書く）</avoid>
  <avoid>いかなる方法での振る舞いの変更</avoid>
</constraints>

<output>
  <format>重複が除去されコードがクリーンになったら：さらに TDD を行う場合は /tdd:red、より広範なクリーンアップには /tidy:after</format>
</output>
