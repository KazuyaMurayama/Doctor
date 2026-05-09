# /consult — 新規医療相談を開始する

## 使い方
```
/consult 40代男性、3日前から続く高熱と乾いた咳。倦怠感あり。
/consult 5歳の子供、昨日から38.5℃の発熱と下痢。
/consult 70代女性（母）、急に頭が痛いと言っている。今すぐ救急に行くべきか？
```

## 実行フロー

1. **セッション初期化**
   - UUID を生成して session-id とする
   - sessions/<session-id>/ ディレクトリを作成
   - sessions/<session-id>/state.json を作成（status: "safety_check"）
   - 入力を intake.schema.json に従い sessions/<session-id>/intake.json に保存

2. **Safety Net チェック（agents/00_safety_net.md）**
   - レッドフラグ検出 → 固定の緊急誘導文を返して終了
   - クリア → 次のステップへ

3. **トリアージ（agents/01_triage_gp.md）**
   - need_more_info の場合 → 質問を返してユーザー入力を待つ（/followup で継続）
   - ready の場合 → 専門医エージェントへ

4. **専門医（agents/02_specialist_md.md）**

5. **EBMレビュー（agents/03_ebm_reviewer.md）**
   - qa_status: "retry" の場合 → agents/02〜03 を再実行（max 2回）
   - qa_status: "needs_review" の場合 → セッションを needs_review フラグで保存して終了
   - qa_status: "pass" → 次のステップへ

6. **レポート統合（agents/04_report_composer.md）**

7. **患者向け翻訳（agents/05_patient_translator.md）**

8. **完了**
   - state.json を "done" に更新
   - reports/<session-id>/ の内容をユーザーに提示
   - （GITHUB_TOKEN が設定されている場合）scripts/publish_report.sh を実行してリポジトリにプッシュ

## エラーハンドリング
- 各エージェント完了後に state.json を保存（チェックポイント）
- 中断時は /continue <session-id> で再開可能
- needs_review フラグが立った場合はその旨をユーザーに通知

## 注意事項
- 「診断」「処方」という語を出力に含めない
- 全出力の末尾に免責事項を付与
- セッション1件あたりのエージェント総ターン数上限：90（1エージェント×15ターン×6）
