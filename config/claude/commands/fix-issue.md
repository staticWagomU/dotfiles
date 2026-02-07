---
allowed-tools: Bash(gh issue view:*), Bash(git switch -c:*)
description: Find and fix an issue in the codebase by following a strict process.
argument-hint: [issueNumber]
---

<purpose>
Issue を理解し、完了要件を満たす修正を実装する。
</purpose>

<rules priority="critical">
  <rule>YOUR_ISSUE_TO_FIX: $ARGUMENTS</rule>
  <rule>Issue がオープンであることを最初に確認する: gh issue view $ARGUMENTS --json state -q .state (must be "OPEN")</rule>
  <rule>確認後、即座にブランチを作成する: git switch -c fix-issue-$ARGUMENTS（他の作業より前に実行すること）</rule>
  <rule>コミットメッセージは conventional commit format を使用する</rule>
</rules>

<workflow>
  <phase name="preparation">
    <step>Issue がオープンか確認: gh issue view $ARGUMENTS --json state -q .state</step>
    <step>即座にブランチを作成: git switch -c fix-issue-$ARGUMENTS</step>
  </phase>

  <phase name="investigation">
    <step>Issue の詳細を読む: gh issue view $ARGUMENTS</step>
    <step>コードベース内の関連コードを特定する</step>
    <step>必要に応じて context7 等のツールで関連コード、ドキュメント、例を検索する</step>
  </phase>

  <phase name="implementation">
    <step>根本原因に対処する修正を実装する</step>
    <step>必要に応じて適切なテストを追加する</step>
    <step>conventional commit format で変更をコミットする</step>
    <step>修正を説明する簡潔な PR description を準備する</step>
  </phase>
</workflow>

<constraints>
  <must>ブランチ作成（step 2）は Issue がオープンであることを確認した直後に行う。main ブランチへの誤コミットを防止するため</must>
  <avoid>プッシュや PR の作成。これらはユーザーが行う</avoid>
</constraints>
