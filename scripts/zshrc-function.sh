working-daily () {
    md="posts/$(date "+%Y%m%d").md"
    cd ~/src/github.com/o0h/my-working-report
    
    # 前回の変更をコミット・プッシュ
    bash scripts/auto-commit.sh
    
    # 新しい記事を作成
    hugo new $md
    open -a typora "content/$md"
}