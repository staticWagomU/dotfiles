# Claude 4 Best Practices for CLAUDE.md

Anthropic公式ドキュメント（2025年版）に基づくClaude 4モデル固有のベストプラクティス。

## 1. Be Explicit with Instructions

Claude 4は明確で明示的な指示に優れた応答を示す。「以前のモデルで見られた"above and beyond"な振る舞い」を期待する場合は、明示的に要求する必要がある。

### Before (Less Effective)
```
Create an analytics dashboard
```

### After (More Effective)
```
Create an analytics dashboard. Include as many relevant features and interactions as possible. Go beyond the basics to create a fully-featured implementation.
```

**CLAUDE.mdへの適用**:
- 「良いコードを書く」→「読みやすく、テスト可能で、単一責任原則に従うコードを書く」
- 修飾語を活用: "as many as possible", "go beyond the basics", "fully-featured"

## 2. Add Context to Improve Performance

ルールの背後にある理由（なぜ）を説明すると、Claudeは意図を理解し、適切に一般化できる。

### Before (Less Effective)
```
NEVER use ellipses
```

### After (More Effective)
```
Your response will be read aloud by a text-to-speech engine, so never use ellipses since the text-to-speech engine will not know how to pronounce them.
```

**CLAUDE.mdへの適用**:
- 「console.logを使わない」→「本番コードではconsole.logを避ける。デバッグ情報が漏洩し、パフォーマンスに影響するため」
- 制約には常に「なぜなら」を添える

## 3. Avoid Over-Engineering

Claude 4（特にOpus 4.5）は過度なエンジニアリング傾向がある。明示的な抑制指示が効果的。

### Recommended CLAUDE.md Section
```
Avoid over-engineering. Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused.

Don't add features, refactor code, or make "improvements" beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability.

Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs).

Don't create helpers, utilities, or abstractions for one-time operations. Don't design for hypothetical future requirements. The right amount of complexity is the minimum needed for the current task.
```

## 4. Tool Usage Patterns

Claude 4は指示に忠実。「suggest changes」と言うと提案のみ、「make changes」と言うと実際に変更する。

### Proactive Action（デフォルトで実行）
```xml
<default_to_action>
By default, implement changes rather than only suggesting them. If the user's intent is unclear, infer the most useful likely action and proceed, using tools to discover any missing details instead of guessing.
</default_to_action>
```

### Conservative Action（デフォルトで提案）
```xml
<do_not_act_before_instructions>
Do not jump into implementation or change files unless clearly instructed. When the user's intent is ambiguous, default to providing information, doing research, and providing recommendations rather than taking action.
</do_not_act_before_instructions>
```

## 5. Formatting Control

Claude 4の出力形式を制御する効果的な方法:

1. **何をしないかではなく、何をするかを指示**
   - Bad: "Do not use markdown"
   - Good: "Your response should be composed of smoothly flowing prose paragraphs"

2. **XMLタグで形式を指定**
   ```
   Write prose sections in <smoothly_flowing_prose_paragraphs> tags.
   ```

3. **プロンプトスタイルを出力スタイルに合わせる**
   - Markdownを減らしたい → プロンプト自体のMarkdownを減らす

### Minimize Excessive Markdown
```xml
<avoid_excessive_markdown_and_bullet_points>
When writing long-form content, write in clear, flowing prose using complete paragraphs. Reserve markdown primarily for `inline code`, code blocks, and simple headings. Avoid **bold**, *italics*, and bullet lists unless truly necessary.

Instead of listing items with bullets, incorporate them naturally into sentences.
</avoid_excessive_markdown_and_bullet_points>
```

## 6. Code Exploration

Claude Opus 4.5は保守的になりがち。コードを読まずに提案することがある。

### Encourage Thorough Exploration
```
ALWAYS read and understand relevant files before proposing code edits. Do not speculate about code you have not inspected. If the user references a specific file/path, you MUST open and inspect it before explaining or proposing fixes.

Be rigorous and persistent in searching code for key facts. Thoroughly review the style, conventions, and abstractions of the codebase before implementing new features.
```

## 7. Minimize Hallucinations
```xml
<investigate_before_answering>
Never speculate about code you have not opened. If the user references a specific file, you MUST read the file before answering. Make sure to investigate and read relevant files BEFORE answering questions about the codebase. Never make any claims about code before investigating unless you are certain of the correct answer.
</investigate_before_answering>
```

## 8. Parallel Tool Execution

Claude 4は並列ツール実行に優れている。明示的に指示すると100%に近い成功率。

```xml
<use_parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies between the tool calls, make all of the independent tool calls in parallel. Maximize use of parallel tool calls where possible to increase speed and efficiency.
</use_parallel_tool_calls>
```

## 9. Frontend Design Quality

Claude 4は「AIスロップ」的な汎用デザインに収束しがち。明示的な指示で回避。

```xml
<frontend_aesthetics>
Avoid generic "AI slop" aesthetics. Make creative, distinctive frontends.

Focus on:
- Typography: Avoid generic fonts (Arial, Inter). Choose distinctive fonts.
- Color: Dominant colors with sharp accents. Draw from IDE themes for inspiration.
- Motion: Use animations for high-impact moments.
- Backgrounds: Create atmosphere with gradients and patterns.

Avoid: Overused fonts, purple gradients on white, predictable layouts.
</frontend_aesthetics>
```

## 10. Test-Focused Development Warning

Claude 4はテストを通すことに過度に集中することがある。

```
Write high-quality, general-purpose solutions. Do not hard-code values or create solutions that only work for specific test inputs. Tests verify correctness, not define the solution.

If tests are incorrect, inform me rather than working around them.
```

## Reference

Source: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices
