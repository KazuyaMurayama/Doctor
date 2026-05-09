# doctor-forge CLAUDE.md

## 目的
一流ドクターチームによる医療相談システム。症状入力 → 6エージェント連携 → レポート出力。

## コマンド
- `/consult [症状の説明]` : 新規相談を開始
- `/followup [追加情報]`  : 進行中セッションに情報追加
- `/urgent`              : レッドフラグチェックのみ即時実行
- `/continue [session-id]`: 指定セッションを再開

## エージェント実行順序
1. agents/00_safety_net.md      (Opus)   — レッドフラグ専用・最優先
2. agents/01_triage_gp.md       (Opus)   — 初期評価・緊急度・専門科決定
3. agents/02_specialist_md.md   (Sonnet) — 専門医診断・鑑別テーブル
4. agents/03_ebm_reviewer.md    (Sonnet) — エビデンス照合・QAルーブリック
5. agents/04_report_composer.md (Sonnet) — レポート統合（clinical + patient）
6. agents/05_patient_translator.md (Sonnet) — 患者向け平易語変換

## セッション管理
- セッション1件 = sessions/<session-id>/ ディレクトリ
- 中間ログ     = sessions/<session-id>/turns/NN-<agent>.json（追記専用）
- 現在状態     = sessions/<session-id>/state.json
- FSM状態: idle → safety_check → triage → specialist → ebm → integrate → translate → done

## スキルファイル参照
- トリアージ   → skills/triage_logic.md
- 鑑別診断     → skills/differential_dx.md
- 緊急判断     → skills/red_flags.md
- EBM評価      → skills/ebm_evaluation.md
- 家庭対処     → skills/home_care.md
- レポート形式 → skills/report_format.md
- GitHub発行   → skills/github_publish.md

## モデル使い分け
- Opus  : エージェント00（safety-net）・01（triage）
- Sonnet: エージェント02〜05（specialist・EBM・統合・翻訳）

## 絶対禁止事項
- 「診断」「処方」という語を出力に使用しない（医師法17条）
- 確定的断言禁止（必ず「可能性がある」「医師への受診を推奨」を付記）
- レッドフラグ検出時は他処理をスキップし固定文字列の緊急誘導を返す
- ブランチ作成禁止（main のみ運用）
- 1エージェントあたり最大15ターン

## QA基準（全項目pass必須）
- [ ] レッドフラグ確認済み
- [ ] 鑑別候補3つ以上
- [ ] エビデンスグレードA/B推奨が1つ以上
- [ ] 患者属性（年齢・性別）考慮済み
- [ ] 家庭対処法提示済み
- [ ] 免責事項付記済み
