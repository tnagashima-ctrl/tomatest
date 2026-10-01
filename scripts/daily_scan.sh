#!/usr/bin/env bash
# 日次走査: Claude Code をヘッドレスで起動し、TASKS.md と daily/ を更新する。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WS="$ROOT/workspace"
TODAY="$(date +%F)"
LOG="$ROOT/logs/$TODAY.log"
mkdir -p "$ROOT/logs" "$WS/daily"

# コネクタ名は環境で異なる場合がある。`claude` 内で /mcp を実行して確認し、必要なら修正する。
ALLOWED=(
  "Read" "Write" "Edit" "Glob" "Grep"
  "mcp__claude_ai_Notion__notion-search"
  "mcp__claude_ai_Notion__notion-fetch"
  "mcp__claude_ai_Notion__notion-query-data-sources"
  "mcp__claude_ai_Gmail__search_threads"
  "mcp__claude_ai_Gmail__get_thread"
  "mcp__claude_ai_Gmail__get_message"
  "mcp__claude_ai_Slack__slack_search_public_and_private"
  "mcp__claude_ai_Slack__slack_read_channel"
  "mcp__claude_ai_Slack__slack_read_thread"
  "mcp__claude_ai_Slack__slack_read_user_profile"
)

PROMPT="今日は ${TODAY}。CLAUDE.md の運用ルールに従い、Notion・Gmail・Slack を走査して TASKS.md を更新し、daily/${TODAY}.md を作成せよ。完了済みで30日以上経過した行は archive/ に移す。最後に新規・変更・要返信の件数を1行で出力する。"

cd "$WS"
claude -p "$PROMPT" \
  --allowedTools "${ALLOWED[@]}" \
  --permission-mode acceptEdits \
  --output-format text >> "$LOG" 2>&1

echo "done: $TODAY" >> "$LOG"
