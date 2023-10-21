[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")

$input = [Microsoft.VisualBasic.Interaction]::InputBox("take a memo", "Take Obsidian Memos")
$memo = $input -replace ' ', '%20'
$now = Get-Date
$current_time = $now.ToString("HH:mm")

Start-Process "obsidian://advanced-uri?vault=MyLife&daily=true&mode=append&data=-%20$current_time%20$memo"
