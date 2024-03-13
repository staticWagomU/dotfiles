function ghp --description 'gh + peco + ghq'
  gh repo list --json url -q '.[].url' | peco | ghq get
end
