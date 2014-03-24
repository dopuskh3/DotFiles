#D: g: git
alias g="git"

function grebi () {
  local reb
  reb=5
  if [ "$1" != "" ]; then
    reb=$1
  fi
  g rebase --interactive HEAD~$reb
}


function fixup() {
  local tofix;
  local histlen;
  if [ $# -lt 1 ]; then
    echo "Usage $0 <sha1>" 1>&2
    return 1
  fi
  tofix=$1
  shift
  histlen=10
  if [ $? -ne 0 -o $histlen -eq 0 ]; then
    echo "Cannot get history length." >&2
    return 1
  fi
  git commit --fixup=$tofix $*
  if [ $? -ne 0 ]; then
    echo "Failed to commit." >&2
    return 1
  fi
  git stash
  git -c core.editor=/bin/true rebase --autosquash --interactive HEAD~$histlen
  if [ $? -ne 0 ]; then
    echo "Failed to rebase." >&2
    return 1
  fi
  git stash pop
}

function fireview() {
  fixup $*
  review $1
}

function checkout_or_create_branch () {
  if [ $# = 0 ]; then
    git branch
    return $?
  fi

  if [ $# = 1 ]; then
    git checkout $1
    return $?
  fi

  if [ $# = 2 ]; then
    git checkout $1 --track $2
  fi
}

alias g="git"
alias gd="git diff"
alias gs="git stash"
alias gb="checkout_or_create_branch"
alias gc="git commit"
alias gp="git pull --rebase"
alias gl="git l"

