# Doctor — doctor-forge 医療相談 AI システム

> ユーザーの症状入力から、複数の医療エージェントが連携して**緊急度評価・鑑別診断・EBMレビュー・患者向け説明**までを生成する Claude Code ベースの医療相談支援システム。

作成日: 2026-06-02
最終更新日: 2026-06-02

⚠️ **本システムは医学的助言を提供する完成品ではありません**。最終的な診断・治療判断は必ず医療従事者に委ねてください。

---

## 📋 概要

`doctor-forge` は症状入力を受け取り、6つの専門エージェント・パイプラインで段階的に医療相談レポートを生成します：

| # | エージェント | 役割 |
|---|---|---|
| 00 | `safety_net` | 雷鳴頭痛などの**緊急度スコア5**を検出し即時医療誘導 |
| 01 | `triage_gp` | プライマリケア医視点で緊急度（1〜5）と鑑別候補を提示 |
| 02 | `specialist_md` | 専門医視点で鑑別精緻化・追加検査推奨 |
| 03 | `ebm_reviewer` | エビデンスベース医療（EBM）の観点でレビュー |
| 04 | `report_composer` | `reports/clinical_report.md` を生成 |
| 05 | `patient_translator` | `reports/patient_summary.md` を生成（患者向け平易な言葉） |

---

## 🚀 セットアップ

### 必要環境
- Claude Code CLI（VSCode 拡張版 or Web版）
- Python 3.x（スクリプト実行用）
- GitHub Token（任意：レポート自動公開時のみ）

### 環境変数
`.env` を `.env.example` から作成：

```bash
# レポートを GitHub に自動発行したい場合のみ設定（任意）
GITHUB_TOKEN=your_token_here
GITHUB_REPO=KazuyaMurayama/doctor
```

---

## 💬 使い方

### コマンド: `/consult`

Claude Code で本リポを開き、以下のように症状を入力：

```
/consult 40代男性、3日前から続く高熱と乾いた咳。倦怠感あり。基礎疾患なし。
```

→ 緊急度評価 → 鑑別候補 → 臨床レポート → 患者向けサマリーまでが自動生成され、`reports/` に保存されます。

### 動作確認シナリオ

1. **発熱・咳（中等度）**:
   - 緊急度スコア 3（数日以内受診）が出るか
   - 鑑別3候補（インフルエンザ・COVID-19・肺炎など）が出るか
2. **雷鳴頭痛**: 「突然の激しい頭痛、今まで経験したことのない痛み」
   - safety-net がスコア 5 検出 → 固定緊急誘導文のみ返すか
   - 後続エージェントが起動しないか
3. **小児発熱**: 「5歳の子供、38℃の発熱と咳（2日目）」
   - 小児向け注意事項（アスピリン禁忌・年齢別用量）が含まれるか
4. **情報不足**: 「頭が痛い」
   - `need_more_info` → 追加質問が返るか

---

## 📁 ディレクトリ構成

```
Doctor/
├── CLAUDE.md                     # Claude Code 運用ルール
├── README.md                     # このファイル
├── tasks.md                      # 進捗管理
├── .env.example                  # 環境変数テンプレート
├── .claude/
│   └── commands/
│       └── consult.md            # /consult コマンド定義
├── agents/                       # 6つの医療エージェント
│   ├── 00_safety_net.md
│   ├── 01_triage_gp.md
│   ├── 02_specialist_md.md
│   ├── 03_ebm_reviewer.md
│   ├── 04_report_composer.md
│   └── 05_patient_translator.md
├── medical/                      # 医学的知識ベース
│   ├── differential_dx.md
│   ├── ebm_evaluation.md
│   ├── home_care.md
│   ├── red_flags.md
│   ├── report_format.md
│   └── triage_logic.md
├── schemas/                      # JSON Schema
│   ├── intake.schema.json
│   ├── report.schema.json
│   └── triage.schema.json
├── scripts/
│   └── publish_report.sh         # GitHub 自動発行スクリプト
├── reports/                      # 生成レポート出力先
└── sessions/                     # セッション履歴（gitignore対象）
```

---

## 📊 ステータス

- [x] ディレクトリ構造・エージェント・スキーマ・コマンド整備完了
- [x] 初回 GitHub push 完了
- [ ] `ANTHROPIC_API_KEY` 動作確認
- [ ] `GITHUB_TOKEN` 動作確認
- [ ] `/consult` コマンド 動作テスト

Phase 2 候補：
- drug-interaction-check スキル（常用薬入力時の自動起動）
- prior-consultation-search スキル（過去レポートの RAG 検索）
- 人間医師レビューキュー（`needs_review` セッション一覧 UI）
- メトリクス集計（リトライ率・トークンコスト）

---

## ⚖️ 免責事項

本システムは **教育・研究用途** を想定した AI による情報提供ツールです。

- 提供される情報は**医学的助言ではありません**
- 緊急時は即座に救急医療機関（日本国内では #7119、救急時 119）へ連絡してください
- 最終的な診断・治療判断は必ず医療従事者に委ねてください
- 入力された個人健康情報は `sessions/` に保存されますが、`gitignore` により公開リポにはコミットされません

---

## 開発者

**男座員也（Kazuya Oza / おざ かずや）**

GitHub: [@KazuyaMurayama](https://github.com/KazuyaMurayama)

---

## ライセンス

未定（本リポは個人プロジェクト）。利用・引用時は事前にご相談ください。
