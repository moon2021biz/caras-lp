#!/bin/bash
# CARAS メインLP（Wixから移設）デプロイスクリプト
# 使い方: bash push.sh "更新内容のメモ"
# ※事前に GitHub リポジトリ連携＋Cloudflare Pages プロジェクト作成が必要
MSG="${1:-update}"
cd "$(dirname "$0")"

# --- 公開前セルフチェック（.gitignore のホワイトリストが効いているか） ---
EXTRA=$(git status --porcelain --untracked-files=all | grep -v '\.webp$' | grep -vE '(index\.html|push\.sh|\.gitignore)$' || true)
if [ -n "$EXTRA" ]; then
  echo "🚫 想定外のファイルが公開対象に入っています。中断しました："
  echo "$EXTRA"
  echo "→ 不要なら削除するか、.gitignore を確認してください。"
  exit 1
fi

git add .
git commit -m "$MSG"
git push origin main
echo "✅ GitHub push 完了"
echo "🌐 Cloudflare Pages が自動デプロイ開始します"
