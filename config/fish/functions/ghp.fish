function ghp --description 'gh + peco + ghq'
  gh repo list --json url -q '.[].url + ".git"' | peco | ghq get
end
