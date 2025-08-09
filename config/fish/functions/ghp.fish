function ghp --description 'gh + fzf + ghq'
  gh repo list --json url -q '.[].url' | fzf | ghq get
end
