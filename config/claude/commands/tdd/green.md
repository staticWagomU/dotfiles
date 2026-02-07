---
description: Complete the GREEN phase - Make the test pass with minimal code
---

<purpose>
TDD GREEN フェーズ：失敗しているテストを最小限のコードでパスさせる。
</purpose>

<rules priority="critical">
  <rule>このフェーズはサイクルごとに正確に1回実行される</rule>
  <rule>不要な機能を追加しないこと</rule>
  <rule>コード品質は一時的に無視する。それは REFACTOR フェーズで行う</rule>
</rules>

<rules priority="standard">
  <rule>Fake It：実装方法が不明な場合。テストをパスさせる定数を返す。Triangulation で段階的に定数を変数に置き換える</rule>
  <rule>Obvious Implementation：解決策が明確で確信がある場合。実際の実装を直接入力する。失敗した場合は Fake It に戻る</rule>
  <rule>Triangulation：Fake It の後に一般化が必要な場合。フェイクを壊す2つ目のテストを追加して実際のロジックを強制する</rule>
</rules>

<workflow>
  <phase name="strategy-selection">
    <step>Fake It を使う：実装に2つ以上の新関数が必要、アルゴリズムが不明確、複数の条件分岐が必要、または Obvious Implementation が既に失敗した場合</step>
    <step>Obvious Implementation を使う：単一の式や文で十分、コードベースの既存コードとパターンが一致、実装がテストの直接的な翻訳の場合</step>
    <step>Triangulation を使う：Fake It の後に一般化が必要、抽象化がまだ明確でない、テストを通じて設計を発見したい場合</step>
  </phase>

  <phase name="implement">
    <step>選択した戦略に基づいてテストをパスさせる最小限のコードを書く</step>
    <step>すべてのテストを実行してパスすることを確認する</step>
    <step>実装が最小限であること（余分な機能がないこと）を確認する</step>
  </phase>

  <phase name="commit">
    <step>GREEN = SAFE。常に戻れる動作するチェックポイントができた</step>
    <step>/git:commit を実行してこの振る舞いの変更をコミットする</step>
    <step>コミットタイプ：feat:（新機能）、fix:（バグ修正）、test:（テスト追加）</step>
  </phase>
</workflow>

<constraints>
  <must>テストがパスすることを確認してからコミットする</must>
  <must>信頼度に応じた適切な戦略を使用する</must>
  <avoid>GREEN フェーズ中のリファクタリング。まずグリーンにし、コミットし、それからコードを改善する</avoid>
</constraints>

<output>
  <format>コミット後、/tdd:refactor に進んでテストをグリーンに保ちながらコード品質を改善する</format>
</output>
