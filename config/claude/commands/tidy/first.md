---
description: Tidy First - Make structural improvements before a behavioral change
---

<purpose>
Tidy First モード：今後の振る舞い変更をより容易かつ安全にするための小さな構造的改善を行う。
</purpose>

<rules priority="critical">
  <rule>振る舞いの変更は行わない。構造的な変更のみ</rule>
  <rule>各整頓コミットは小さく保つ：変更行数 20行未満、1コミットにつき1つの整頓、数分で完了</rule>
  <rule>整頓に時間がかかりすぎる場合は /tidy:later を使う</rule>
</rules>

<workflow>
  <phase name="identify">
    <step>変更対象のコードが理解しにくい、密結合、命名が不適切、重複がある、その他整理が必要な状態かを確認する</step>
    <step>整頓カタログから1つの小さな改善を選ぶ：Guard Clauses（深いネスト条件分岐）、Dead Code Removal（未使用コード）、Normalize Symmetries（見た目が異なる類似コード）、Extract Helper（1つの識別可能な処理の塊）、Inline（助けにならない抽象化）、Rename（意図を示さない名前）、Reorder（散在する関連コード）、Explaining Variable（複雑な式）、Explaining Constant（コンテキストのないマジックナンバー/文字列）</step>
  </phase>

  <phase name="tidy-step">
    <step>構造的な変更を行う（振る舞いの変更なし）</step>
    <step>テストを実行して何も壊れていないことを確認する</step>
    <step>/git:commit で refactor: タイプのコミット</step>
  </phase>

  <phase name="iterate">
    <step>さらに整頓が必要な場合は identify フェーズに戻る</step>
    <step>振る舞い変更の準備ができたら整頓モードを終了する</step>
  </phase>
</workflow>

<constraints>
  <must>変更は純粋に構造的であること</must>
  <must>テストがパスし続けること</must>
  <must>差分は小さく焦点を絞ること</must>
  <avoid>過剰な整頓。摩擦を減らすのに十分なだけ行う</avoid>
</constraints>

<output>
  <format>コードが振る舞い変更の準備ができたら：整頓モードを終了し、feat: または fix: の変更を行い、コミット後に任意で /tidy:after を使用する</format>
</output>
