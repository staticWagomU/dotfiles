---
description: Tidy After - Clean up code after completing a behavioral change
---

<purpose>
Tidy After モード：振る舞いの変更（feat/fix）を完了した後に、コード構造を改善する機会を見つけてクリーンアップする。
</purpose>

<rules priority="critical">
  <rule>振る舞いの変更が既にコミットされていること（feat:/fix:）</rule>
  <rule>振る舞いの変更は行わない。構造的な変更のみ</rule>
  <rule>各整頓コミットは小さく保つ：変更行数 20行未満、1コミットにつき1つの整頓</rule>
  <rule>タイムボックスを設定する（例：10-15分）。最も価値のある整頓から行い、時間切れまたは価値が低下したら停止する</rule>
</rules>

<workflow>
  <phase name="identify">
    <step>振る舞い変更後によくある整頓の機会を探す：共通コードの抽出（コピペでテストをパスさせた場合）、より良い命名（ドメインの理解が深まった場合）、条件分岐の簡素化（実装を通じてロジックが明確になった場合）、足場の除去（開発中の一時的なコード）、凝集度の改善（関連コードが散在してしまった場合）</step>
  </phase>

  <phase name="tidy-step">
    <step>1つの小さな整頓の機会を特定する</step>
    <step>構造的な変更を行う（振る舞いの変更なし）</step>
    <step>テストを実行して何も壊れていないことを確認する</step>
    <step>/git:commit で refactor: タイプのコミット</step>
  </phase>

  <phase name="iterate">
    <step>さらに整頓が必要な場合は identify フェーズに戻る</step>
    <step>残りの機会は /tidy:later で記録する</step>
    <step>満足したら次の作業に移る</step>
  </phase>
</workflow>

<constraints>
  <must>振る舞いの変更が既にコミット済みであること</must>
  <must>変更は純粋に構造的であること</must>
  <must>テストがパスし続けること</must>
  <avoid>Tidy After を先延ばしにすること。タイムボックスを設定して出荷する</avoid>
</constraints>

<output>
  <format>クリーンアップに満足したら：次のタスクに移る、または該当する場合は /tdd:red で次の TDD サイクルを開始する</format>
</output>
