function pp --description 'cd to a github project directory'
  set -l DEVDIR ~/dev/github.com/
  set -l GITHUBUSER (ls $DEVDIR -1 | fzf)
  
  if test -n "$GITHUBUSER"
    set -l PROJECT (ls $DEVDIR/$GITHUBUSER -1 | fzf)
    
    if test -n "$PROJECT"
      cd $DEVDIR/$GITHUBUSER/$PROJECT
    else
      echo "No project selected."
    end
  else
    echo "No user selected."
  end
end
