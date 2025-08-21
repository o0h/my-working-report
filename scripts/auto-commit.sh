#!/bin/bash

# スクリプトのディレクトリを取得して、プロジェクトルートに移動
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
cd "$PROJECT_ROOT"

# 変更があるかチェック
if [[ -z $(git status --porcelain) ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - No changes to commit" >> /tmp/auto-commit.log
    exit 0
fi

# 新規・変更されたファイルを追加
git add content/posts/*.md
git add static/images/posts/

# ステージングされた変更があるかチェック
if [[ -z $(git diff --cached --name-only) ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - No staged changes to commit" >> /tmp/auto-commit.log
    exit 0
fi

# 変更内容のサマリを取得
CHANGED_FILES=$(git diff --cached --name-only)
NEW_FILES=$(git diff --cached --name-only --diff-filter=A)
MODIFIED_FILES=$(git diff --cached --name-only --diff-filter=M)

# Claude Codeでコミットメッセージを生成
PROMPT="以下のファイル変更に基づいて、簡潔な日本語のコミットメッセージを1行で生成してください（絵文字付き）:

新規ファイル:
${NEW_FILES:-なし}

変更ファイル:
${MODIFIED_FILES:-なし}

このブログは日々の記録を書くためのものです。"

# Claude Codeを使ってコミットメッセージを生成
COMMIT_MSG=$(echo "$PROMPT" | claude-code --no-cache 2>/dev/null | tail -n 1)

# フォールバック（Claude Codeが失敗した場合）
if [[ -z "$COMMIT_MSG" ]] || [[ "$COMMIT_MSG" == *"error"* ]]; then
    COMMIT_MSG="📝 Update posts: $(date '+%Y/%m/%d')"
fi

# コミット
git commit -m "$COMMIT_MSG"

# プッシュ
git push origin main

echo "$(date '+%Y-%m-%d %H:%M:%S') - Committed with message: $COMMIT_MSG" >> /tmp/auto-commit.log