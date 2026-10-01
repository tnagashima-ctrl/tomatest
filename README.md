# Claude 日次ワークスペース

Notion・Gmail・Slack を毎日走査し、`workspace/TASKS.md` を更新する。Claude Code をヘッドレス実行する構成。

## 構成
```
workspace/
  CLAUDE.md   運用ルール（Claudeが毎回読む）
  TASKS.md    タスク表
  daily/      日次ログ・返信案
  archive/    完了タスク退避
scripts/
  daily_scan.sh                      日次実行スクリプト
  com.local.claude-daily-scan.plist  macOS launchd 設定（毎日7:30）
```

## セットアップ
1. Claude Code をインストールし、`claude` でログイン。
2. claude.ai の設定 > コネクタで Notion / Gmail / Slack を接続（CLI にも同期される）。
3. `cd workspace && claude` を起動し `/mcp` で3つが connected か確認。
   ツール名が `scripts/daily_scan.sh` の `ALLOWED` と違う場合は合わせる。
4. 手動実行で動作確認: `./scripts/daily_scan.sh`
5. 自動実行（macOS）:
   ```
   sed "s#__REPO__#$(pwd)#g" scripts/com.local.claude-daily-scan.plist \
     > ~/Library/LaunchAgents/com.local.claude-daily-scan.plist
   launchctl load ~/Library/LaunchAgents/com.local.claude-daily-scan.plist
   ```
   Linux は cron: `30 7 * * * /path/to/scripts/daily_scan.sh`

## 随時利用
`cd workspace && claude` で起動すれば、`CLAUDE.md` と `TASKS.md` を前提に対話できる。
例: 「今日の優先順位をつけて」「T-0003 の返信案を作って」

## 注意
- 走査は読み取り専用。送信・投稿・編集系ツールは許可していない。
- Mac がスリープ中は launchd は実行されない。起床後に実行される。
- `daily/` と `logs/` はメール内容を含むため git 管理外。
