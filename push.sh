#!/bin/bash
# CARAS メインLP（Wixから移設）デプロイスクリプト
# 使い方: bash push.sh "更新内容のメモ"
# GitHub へ push すると Cloudflare が自動でビルド・デプロイする
MSG="${1:-update}"
cd "$(dirname "$0")"

# --- 公開前セルフチェック（.gitignore のホワイトリストが効いているか） ---
EXTRA=$(git status --porcelain --untracked-files=all \
  | grep -vE '(public/assets/.*\.webp|public/index\.html|push\.sh|\.gitignore|wrangler\.jsonc)$' || true)
if [ -n "$EXTRA" ]; then
  echo "🚫 想定外のファイルが対象に入っています。中断しました："
  echo "$EXTRA"
  echo "→ 不要なら削除するか、.gitignore を確認してください。"
  exit 1
fi

git add -A
git commit -m "$MSG"
git push origin main
echo "✅ GitHub push 完了"
echo "🌐 Cloudflare が自動デプロイを開始します"
