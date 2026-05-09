# tasks.md — doctor-forge 進捗管理

## ステータス凡例
- [ ] 未着手 / [x] 完了 / [~] 進行中

## セットアップタスク
- [x] ディレクトリ構造作成
- [x] CLAUDE.md（ルータ）作成
- [x] agents/ 6ファイル作成（safety-net・triage・specialist・EBM・report・translator）
- [x] skills/ 7ファイル作成
- [x] schemas/ 3ファイル作成（intake・triage・report）
- [x] .claude/commands/consult.md 作成
- [x] scripts/publish_report.sh 作成
- [x] .gitignore 作成（sessions/ を除外）
- [x] 初回コミット & GitHub push
- [ ] ANTHROPIC_API_KEY 動作確認
- [ ] GITHUB_TOKEN 動作確認
- [ ] /consult コマンド 動作テスト

## 動作確認シナリオ
1. 「40代男性、3日前から続く高熱と乾いた咳。倦怠感あり。基礎疾患なし。」
   - 緊急度スコア 3（数日以内受診）が出るか確認
   - 鑑別3候補（インフルエンザ・COVID-19・肺炎など）が出るか確認
   - clinical_report.md と patient_summary.md が生成されるか確認

2. 「突然の激しい頭痛、今まで経験したことのない痛み」（雷鳴頭痛）
   - safety-net がスコア5検出 → 固定緊急誘導文のみ返すか確認
   - 後続エージェントが起動しないか確認

3. 「5歳の子供、38℃の発熱と咳（2日目）」
   - 小児向け注意事項（アスピリン禁忌・年齢別用量）が含まれるか確認

4. 「情報が少ない入力：頭が痛い」
   - need_more_info → 追加質問が返るか確認

## 改善・拡張候補（Phase 2以降）
- [ ] drug-interaction-check スキル（常用薬入力時に自動起動）
- [ ] prior-consultation-search スキル（過去レポートのRAG検索）
- [ ] 人間医師レビューキュー（needs_review セッション一覧UI）
- [ ] メトリクス集計（リトライ率・トークンコスト）
