# dot-files module
#

DOTFILE_PATH=$HOME/DotFiles
DOTFILE_REMOTE=git@github.com:dopuskh3/DotFiles
DOTFILE_REMOTE_BRANCH=master


function dot-setup () {
  if [ -d $DOTFILE_PATH ]; then
    datets=`date +"%Y%m%d-%Hh%M"`
    mv $DOTFILE_PATH $DOTFILE_PATH.bak-${datets}
  fi

  git clone $DOTFILE_REMOTE $DOTFILE_PATH
  pushd $DOTFILE_PATH
  git checkout -b $DOTFILE_REMOTE_BRANCH origin/$DOTFILE_REMOTE_BRANCH
  popd
}

function dot-check-sync () {
  pushd $DOTFILE_PATH
  local retcode

  retcode=0
  git diff-files --quiet
  if [ $? -ne 0 ]; then
    zlogerr "Warning: You have local uncommited changes in your dot files."
    popd
    return 1
  fi
  git fetch origin
  log_output=`git log --quiet --pretty=oneline --abbrev-commit origin/$DOTFILE_REMOTE_BRANCH..$DOTFILE_REMOTE_BRANCH 2>&1`
  if [ "$log_output" != "" ]; then
    zlogerr "Warning: The following local commit are not pushed to remote."
    echo $log_output
    retcode=1
  fi

  log_output=`git log --quiet --pretty=oneline --abbrev-commit $DOTFILE_REMOTE_BRANCH..origin/$DOTFILE_REMOTE_BRANCH 2>&1`
  if [ "$log_output" != "" ]; then
    zlogerr "Warning: The following remote changes are not pulled."
    echo $log_output
    retcode=1
  fi
  popd
  return $retcode
}

#D: dot-reinstall: Re-install dot files
function dot-reinstall (){
  pushd $DOTFILE_PATH
  ./install.sh
  popd
}

#D: dot-pull: Pull dot files
function dot-pull () {
  pushd $DOTFILE_PATH
  git pull origin $DOTFILE_REMOTE_BRANCH || return 1
  popd
}

#D: dot-sync: Pull/Commit/Reinstall dot-files
function dot-sync () {
  ret=0

  if dot-check-sync; then
    zlog "Your configs are up to date."
    return 0
  fi
  pushd $DOTFILE_PATH
  remote=origin
  branch=$DOTFILE_REMOTE_BRANCH
  datets=`date +"%Y%m%d-%Hh%M"`
  stashname=dot-resync-$datets
  localchanges=0
  zlog "Saving local changes"
  diff=`git diff`
  if [ "$diff" != "" ]; then
    localchanges=1
    git stash save $stashname
  else
    zlog "No local changes."
  fi
  zlog "Pulling from $remote..."
  dot-pull || echo "Pull fail."
  if [ $localchanges -gt 0 ]; then
    zlog "Re-applying stash $stashname"
    git stash pop -q
    if [ $? -ne 0 ]; then
      zlogerr "Stash failed to apply, please merge !"
      return 1
    else
      git commit -a -m "Dot re-sync $datets"
    fi
  fi
  zlog "Pushing dot files branch $branch to $remote"
  dot-push
  popd
  return $ret
}


#D: dot-status: Print status
function dot-status () {
  dot-check-sync
}

#D: dot-push: Push dot files to master
function dot-push () {
  pushd $DOTFILE_PATH
  git push origin $DOTFILE_REMOTE_BRANCH
  popd -
}

#D: dot-update: Pull and re-install dot files
function dot-update () {
  dot-pull
  dot-reinstall
}


if [ ! -d $DOTFILE_PATH ]; then
  zlogerr "Your dot-files are not installed. Please run dot-setup/dot-reinstall"
else
  dot-status
fi
