---
description: "spec-driven development"
---

<purpose>
Claude Code を用いた spec-driven development を行う。5つのフェーズに従い、仕様を段階的に具体化して実装する。
</purpose>

<workflow>
  <phase name="事前準備">
    <step>ユーザーからタスクの概要を受け取る</step>
    <step>mkdir -p ./.cckiro/specs を実行する</step>
    <step>./cckiro/specs 内にタスク概要から適切な spec 名のディレクトリを作成する（例：「記事コンポーネントを作成する」なら ./.cckiro/specs/create-article-component）</step>
    <step>以降のファイルはこのディレクトリ内に作成する</step>
  </phase>

  <phase name="要件">
    <step>タスク概要に基づいて「要件ファイル」を作成する</step>
    <step>ユーザーに「要件ファイル」を提示し、問題がないかを尋ねる</step>
    <step>ユーザーのフィードバックに基づき修正を繰り返す</step>
    <step>ユーザーが問題なしと回答するまで繰り返す</step>
  </phase>

  <phase name="設計">
    <step>「要件ファイル」の要件を満たす「設計ファイル」を作成する</step>
    <step>ユーザーに「設計ファイル」を提示し、問題がないかを尋ねる</step>
    <step>ユーザーのフィードバックに基づき修正を繰り返す</step>
    <step>ユーザーが問題なしと回答するまで繰り返す</step>
  </phase>

  <phase name="実装計画">
    <step>「設計ファイル」に基づいて「実装計画ファイル」を作成する</step>
    <step>ユーザーに「実装計画ファイル」を提示し、問題がないかを尋ねる</step>
    <step>ユーザーのフィードバックに基づき修正を繰り返す</step>
    <step>ユーザーが問題なしと回答するまで繰り返す</step>
  </phase>

  <phase name="実装">
    <step>「実装計画ファイル」に基づいて実装を開始する</step>
    <step>「要件ファイル」「設計ファイル」に記載されている内容を守りながら実装する</step>
  </phase>
</workflow>

<constraints>
  <must>各フェーズでユーザーの承認を得てから次のフェーズに進む</must>
  <must>すべてのファイルは ./.cckiro/specs/{spec-name}/ 内に作成する</must>
  <avoid>ユーザーの承認なしにフェーズを飛ばすこと</avoid>
</constraints>
