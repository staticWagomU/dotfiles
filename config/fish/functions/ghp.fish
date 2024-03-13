function ghp
  gh repo list --json url -q '.[].url + ".git"' | peco | ghq get
end
