# タスクスケジューラに毎朝7:30の実行を登録する。PowerShell で1回だけ実行する。
$Script = Join-Path $PSScriptRoot "daily_scan.ps1"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" `
  -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$Script`""
$Trigger = New-ScheduledTaskTrigger -Daily -At 7:30
# スリープ・電源オフで逃した場合は起動後に実行する
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries
Register-ScheduledTask -TaskName "ClaudeDailyScan" -Action $Action -Trigger $Trigger -Settings $Settings -Force
Write-Host "登録完了。確認: Start-ScheduledTask -TaskName ClaudeDailyScan"
