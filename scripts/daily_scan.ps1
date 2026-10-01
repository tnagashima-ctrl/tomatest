# 日次走査（Windows）: Claude Code をヘッドレスで起動し、TASKS.md と daily/ を更新する。
$ErrorActionPreference = "Stop"

$Root  = Split-Path -Parent $PSScriptRoot
$WS    = Join-Path $Root "workspace"
$Today = Get-Date -Format "yyyy-MM-dd"
$LogDir = Join-Path $Root "logs"
$Log   = Join-Path $LogDir "$Today.log"
New-Item -ItemType Directory -Force -Path $LogDir, (Join-Path $WS "daily") | Out-Null

# コネクタ名は環境で異なる場合がある。`claude` 内で /mcp を実行して確認し、必要なら修正する。
$Allowed = @(
  "Read", "Write", "Edit", "Glob", "Grep",
  "mcp__claude_ai_Notion__notion-search",
  "mcp__claude_ai_Notion__notion-fetch",
  "mcp__claude_ai_Notion__notion-query-data-sources",
  "mcp__claude_ai_Gmail__search_threads",
  "mcp__claude_ai_Gmail__get_thread",
  "mcp__claude_ai_Gmail__get_message",
  "mcp__claude_ai_Slack__slack_search_public_and_private",
  "mcp__claude_ai_Slack__slack_read_channel",
  "mcp__claude_ai_Slack__slack_read_thread",
  "mcp__claude_ai_Slack__slack_read_user_profile"
)

$Prompt = "今日は $Today。CLAUDE.md の運用ルールに従い、Notion・Gmail・Slack を走査して TASKS.md を更新し、daily/$Today.md を作成せよ。完了済みで30日以上経過した行は archive/ に移す。最後に新規・変更・要返信の件数を1行で出力する。"

Set-Location $WS
$env:PYTHONUTF8 = "1"
& claude -p $Prompt --allowedTools $Allowed --permission-mode acceptEdits --output-format text *>> $Log
"done: $Today" | Out-File -Append -Encoding utf8 $Log
