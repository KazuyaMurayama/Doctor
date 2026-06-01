# CLAUDE.md

## 🚀 自動実行ポリシー

### 確認不要で即実行する操作
- 全ファイル操作（作成・編集・削除）
- 全シェルコマンド（PowerShell, Bash, git, gh, npm, node, python）
- Git操作: add / commit / push / pull / fetch / merge / branch -D / reset --hard
- GitHub操作: gh pr create / gh api 全般 / ブランチ削除
- パッケージ操作: npm install / pip install / Web検索・フェッチ

### 事前確認が必要な操作（例外のみ）
- `git push --force` を main / master ブランチに対して実行する場合
- `gh repo delete` 実行時

### 動作原則
- 計画提示（簡潔）→ 即実行 → 結果報告 のフロー厳守
- 事前確認文（「Should I run...?」等）を出力しない

## ドキュメント日付ルール

レポート系 .md ファイル新規生成時は H1 タイトル直下に必ず記載:
```
作成日: YYYY-MM-DD
最終更新日: YYYY-MM-DD
```
- 更新時は最終更新日のみ当日付に書き換え（作成日は変更しない）
- 除外: README.md / CLAUDE.md / FILE_INDEX.md / tasks.md / CHANGELOG.md

## 開発者情報

このリポジトリの開発者・所有者は **男座員也（Kazuya Oza / おざ かずや）** です。

- ドキュメント・コード・コミット等で開発者名を記載する際は必ず **男座員也** または **Kazuya Oza** を使用する
- 「Murayama」「村山」「Otokoza」「おとこざ」など誤表記は使用しない

### 開発者の作業環境
- **OS:** Windows 11（Macではない）。シェルは PowerShell 5.1 / Bash（WSL/Git Bash）。`brew` / `Cmd+` / Mac専用コマンドは使用不可。パッケージ管理は `winget` / `scoop`。
- **スマートフォン:** iPhone（iOS）。Android固有の手順・adb・Play Store等は不要。
- コマンド例はPowerShell構文（`;` 連結、`$env:VAR`）で提示。macOS専用ツールを回答に含めない。


## 作業品質ルール

### Git・ブランチ管理（絶対厳守）
- 作業前: `git branch --show-current` でブランチ確認 → main以外なら `git checkout main && git pull` してから開始。
- **デフォルト: mainへ直接コミット**。ブランチ作成はユーザーが明示的に指示した場合のみ。
- ブランチを作成した場合、必ず `main` へマージ → ブランチ削除 → push を完了してから作業完了とする。
- ブランチにファイルを置いたまま回答を完了することを禁止。「完了 = mainにマージ済み＆push済み」。
- ブランチが残存している場合は、次セッション開始時に `git branch -a` で確認し、即マージ・削除する。

### ファイル特定（編集前）
- ユーザー発話のキーワード全てをファイル名と照合してから編集。キーワード不完全一致・候補不確かなら必ず確認。

### 成果物報告
- ファイル作成・更新・push後は必ず3列表で報告: `| 成果物 | 説明 | リンク |`
- リンクは `/blob/<実ブランチ>/<パス>` 形式。報告前に `gh api repos/OWNER/REPO/contents/PATH?ref=BRANCH` で存在確認。push前はURL生成しない。

### ドキュメント品質
- UIパス・コマンド・設定名は公式ドキュメントで確認後に記載。確認不可なら「[要確認]」と明記。
- OS/環境制約（例: Windows専用）をタスク開始時に確認。完成後に `brew`/`Cmd`/`macOS` 等をgrepして除去。

## 他リポジトリ参照ルール
別リポジトリの内容を参照する必要が生じたら、必ず `.claude/cross-repo.md` を読み、その手順に従って `WebFetch` で取得する（「できない」と返さない）。

### 品質ルール（必読）
- ブランチ衛生・リサーチファクトチェックは `.claude/quality-rules.md` を参照し、ファイル生成前・push前に必ず適用する。
- Repo type: app

## ビジュアルルール（レポートMD生成時）
- レポート・成果物MDの新規作成／更新時は `.claude/visual-rules.md` を読み、図の種類判定（§2）と Mermaid 最適化（§3）を毎回適用する。
- 適用対象: `## ` 見出しが2つ以上ある構造化MD（調査結果・戦略レポート・設計書・PR説明など）。

## ファイル保存ルール
- 成果物・スクリプトは本リポジトリ内のみに保存。`C:\\Users\\user\\Desktop` への出力禁止（ユーザー明示指定時を除く）。

<!-- SKILLS_RULES_START -->
## Skill 起動ルール（v2.2 / 2026-06-01）
以下のスキルは **必須・スキップ禁止**。該当シーンでは SKILL.md を読んでから作業を開始すること。

- **新機能実装・設計を始める前に必ず** `.claude/skills/sp-brainstorming/SKILL.md` でアイデアを出し、`.claude/skills/sp-writing-plans/SKILL.md` で計画を作成してから着手する
- **複雑な多段タスクは** `.claude/skills/sp-executing-plans/SKILL.md` の手順で実行する
- **アーキ図・フロー図が必要な時は必ず** `.claude/skills/mermaid-agents365/SKILL.md` を読んでからダイアグラムを作成する
- **成果物の納品・コミット前、または品質チェック（QC）・レビューフェーズに入る時は必ず** `.claude/skills/sp-verification-before-completion/SKILL.md` のチェックリストを実行する
- **要件調査が真に必要な時のみ** `.claude/skills/research-deep/SKILL.md` を読んで Web リサーチを実行する
<!-- SKILLS_RULES_END -->

### モデル・サブエージェント
- 全タスク Opus（期間限定）。サブエージェントも `model: "opus"` を明示。
