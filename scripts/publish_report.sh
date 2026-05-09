#!/usr/bin/env bash
# レポートをリポジトリにコミット・プッシュするスクリプト
set -euo pipefail

SESSION_ID="${1:?使い方: $0 <session-id>}"
REPORT_DIR="reports/${SESSION_ID}"

if [[ ! -d "${REPORT_DIR}" ]]; then
  echo "エラー: ${REPORT_DIR} が見つかりません" >&2
  exit 1
fi

# 免責事項の存在確認
for f in "${REPORT_DIR}/clinical_report.md" "${REPORT_DIR}/patient_summary.md"; do
  if [[ -f "${f}" ]] && ! grep -q "医療情報の提供を目的" "${f}"; then
    echo "エラー: ${f} に免責事項が見つかりません。発行を中止します。" >&2
    exit 1
  fi
done

TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
git add "${REPORT_DIR}/"
git commit -m "report: ${SESSION_ID} (${TIMESTAMP})"
git push -u origin "$(git rev-parse --abbrev-ref HEAD)"

echo "発行完了: ${REPORT_DIR}"
echo "コミット: $(git rev-parse --short HEAD)"
