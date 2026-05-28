# GitHub レポート発行手順

## 発行方法
git コマンドと gh CLI を使用して reports/ をリポジトリにプッシュする。
GitHub Contents API（HTTP PUT）は atomic な複数ファイル更新に不向きのため使用しない。

## 発行スクリプト
scripts/publish_report.sh を実行する。

## 環境変数（必須）
- GITHUB_TOKEN: GitHub Personal Access Token（repo スコープ）
- GITHUB_REPO: KazuyaMurayama/doctor

## 発行ファイル
- reports/<session-id>/clinical_report.md
- reports/<session-id>/patient_summary.md
- reports/<session-id>/citations.json

## 注意事項
- sessions/ ディレクトリは .gitignore で除外（PII保護）
- reports/ のみ公開（セッションIDと患者情報は紐付けない）
- 発行前に免責事項が全ファイルに含まれているか確認
