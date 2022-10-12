$appList=@(
  "7zip.7zip"
  "Lexikos.AutoHotkey"
  "Figma.Figma"
  "Figma.fonthelper"
  "GIMP.GIMP"
  "Git.Git"
  "Google.Chrome"
  "Logitech.Options"
  "Microsoft.PowerShell"
  "Microsoft.WindowsTerminal"
  "Notepad++.Notepad++"
  "JanDeDobbeleer.OhMyPosh"
  "Microsoft.OneDrive"
  "vim.vim"
  "WinMerge.WinMerge"
  "SlackTechnologies.Slack"
  "Microsoft.VisualStudioCode.Insiders"
  "GoLang.Go.1.19"
  "Microsoft.VisualStudioCode"
  "OpenJS.NodeJS.LTS"
  "Neovim.Neovim"
  "wez.wezterm"
  "Noetepad++.Notepad++"
)

function exec_winget($app)
{
  Write-Output "インストール開始：$app"
  & winget install $app
  if($LastExitCode -eq 0)
  {
    $result="インストール成功：$app"
  } else
  {
    $result="インストール失敗：$app"
  }
  Write-Output $result
  $script:exec_result+=$result
}

$exec_result=@()
foreach($app in $appList)
{
  exec_winget $app
}
Write-Output "インストールがすべて終了しました。"
Write-Output $exec_result
