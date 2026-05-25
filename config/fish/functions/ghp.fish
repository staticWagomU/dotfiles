function ghp --description 'gh + fzf + ghq'
  # 自分とorg一覧をownerとしてxargs -Pで並列にrepo取得（直列だとorg数に比例して遅い）
  begin
    gh api user -q .login
    gh org list
  end | xargs -P 8 -I@ gh repo list @ -L 1000 --no-archived --json url -q '.[].url' | sort -u | fzf | ghq get
end
