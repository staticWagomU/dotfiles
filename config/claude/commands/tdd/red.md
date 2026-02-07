---
description: Start the RED phase - Write a small, focused failing test
---

<purpose>
TDD RED フェーズ：Kent Beck の TDD サイクルにおける RED フェーズに入り、1つの小さく焦点を絞った失敗するテストを書く。
</purpose>

<rules priority="critical">
  <rule>RED フェーズ中はコミットしない（安全な状態ではない）</rule>
  <rule>このフェーズはサイクルごとに正確に1回実行される</rule>
  <rule>1つの失敗するテストを書く、または既存テストに1つの失敗するアサーションを追加する</rule>
</rules>

<rules priority="standard">
  <rule>テスト名は振る舞いを説明するものにする（良い例：shouldAuthenticateValidUser, test_empty_input_returns_error / 悪い例：testAuth, test1）</rule>
  <rule>テストは1つの特定の振る舞いをテストする。「さらに...」と考えたら、それは2つ目のテストである</rule>
  <rule>テストは正しい理由で失敗しなければならない：実装の欠如（期待される）であり、構文エラーやタイポではない</rule>
</rules>

<workflow>
  <phase name="strategy-preview">
    <step>テストを書く前に、GREEN フェーズでどの戦略を使うか検討する</step>
    <step>不確実な場合：Fake It（定数を返してパスさせる）</step>
    <step>確信がある場合：Obvious Implementation（実際の解決策をそのまま実装する）</step>
    <step>一般化する場合：Triangulation（フェイクを壊すテストを追加する）</step>
  </phase>

  <phase name="write-test">
    <step>振る舞いを説明する記述的な名前のテストを作成する</step>
    <step>テストは小さく1つのことに焦点を当てる</step>
    <step>テストを実行して失敗を確認する</step>
    <step>失敗が正しい理由（実装の欠如）であることを確認する</step>
  </phase>

  <phase name="split-consideration">
    <step>異なる振る舞いをテストする場合は別のテスト関数の作成を検討する</step>
    <step>新しいアサーションが異なるセットアップを必要とする場合は分割する</step>
    <step>どのアサーションが最初に失敗するか不明な場合は分割する</step>
  </phase>
</workflow>

<constraints>
  <must>テストが正しい理由で失敗することを確認してから次に進む</must>
  <must>各 RED フェーズでは正確に1つの失敗するテストまたは1つの失敗するアサーションのみ追加する</must>
  <avoid>RED フェーズ中のコミット</avoid>
  <avoid>1回のフェーズで複数のテストを追加すること</avoid>
</constraints>

<output>
  <format>テストが正しい理由で失敗したら、/tdd:green に進む</format>
</output>
