.PHONY: help serve build new clean auto-commit

# デフォルトタスク
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# 開発サーバー
serve: ## ローカル開発サーバーを起動 (ドラフト含む)
	hugo server -D

serve-prod: ## 本番環境と同じ設定でサーバーを起動
	hugo server --environment production

# ビルド
build: ## サイトをビルド
	hugo

build-prod: ## 本番環境用にビルド (minify付き)
	hugo --environment production --minify

# コンテンツ作成
new: ## 今日の日付で新しい投稿を作成
	hugo new posts/$$(date +%Y%m%d).md

new-tomorrow: ## 明日の日付で新しい投稿を作成
	hugo new posts/$$(date -v+1d +%Y%m%d).md

# クリーンアップ
clean: ## ビルド成果物を削除
	rm -rf public resources

# Git操作
auto-commit: ## 自動コミットスクリプトを実行
	./scripts/auto-commit.sh

status: ## Git状態を確認
	git status

# 検証
check-links: ## リンク切れをチェック (要: muffet)
	@echo "Checking broken links..."
	@hugo server &
	@sleep 2
	@muffet http://localhost:1313 || true
	@pkill -f "hugo server"

validate: ## HTML検証 (要: html-proofer)
	hugo
	htmlproofer ./public --allow-hash-href --disable-external

# 統計情報
stats: ## 投稿の統計情報を表示
	@echo "=== 投稿統計 ==="
	@echo "総投稿数: $$(find content/posts -name '*.md' | wc -l)"
	@echo "今月の投稿数: $$(find content/posts -name "$$(date +%Y%m)*.md" | wc -l)"
	@echo "今年の投稿数: $$(find content/posts -name "$$(date +%Y)*.md" | wc -l)"
	@echo ""
	@echo "=== 最近の投稿 ==="
	@ls -lt content/posts/*.md | head -5 | awk '{print $$9}'

# ワークフロー
today: new serve ## 今日の投稿を作成して開発サーバーを起動

deploy-check: build validate ## デプロイ前の確認 (ビルド＋検証)