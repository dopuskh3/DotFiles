GERRIT_SERVER='gerrit'
GERRIT_STANDARD_BRANCH='origin'

function gerrit_remote_tracking () {
  git rev-parse --abbrev-ref --symbolic-full-name @{u}
}

function review () {
  local tmplog=`mktemp`
  local remote_tracking=$(gerrit_remote_tracking)
  local remote_branch=$(echo ${remote_tracking} | cut -d'/' -f2-)
  if [ "$1" = "-a" ]; then
    zlog "Pushing all reviews:"
    git --no-pager log --format='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' ${remote_tracking}..HEAD
    git push origin HEAD:refs/publish/${remote_branch} > $tmplog 2>&1
    ret=$?
  elif [ $# -gt 0 ]; then
    for i in $*; do
      zlog "Pushing $i:"
      zlog "  `git log -1 --format="%s" $i`"
      git push origin $i\:refs/publish/${remote_branch} > $tmplog 2>&1
      ret=$?
    done
  else
      zlogerr "Not commit selected"
      return
  fi
  if [ $ret != 0 ]; then
    zlogerr "Error: "
    cat $tmplog
  else
    zlog "OK"
  fi
  rm $tmplog
  return $ret
}

function lsr () {
  for branch in `git branch | sed 's/*//'`; do
    l=`git log --pretty=oneline --abbrev-commit $(gerrit_remote_tracking)..$branch`
    if [ ${#l} -eq 0 ]; then
      continue;
    fi;
    echo "$branch :";
    echo $l | sed 's/^/  /g';
    echo ;
  done
}


function review-stats () {
  local comment_req
  local review_req

  comment_req="select count(*) as comment_count, preferred_email from patch_comments left join accounts on accounts.account_id = patch_comments.author_id group by accounts.preferred_email order by comment_count desc;"
  review_req="select count(*) as review_count, preferred_email from changes left join accounts on accounts.account_id = changes.owner_account_id group by accounts.preferred_email order by review_count desc;"

  echo $comment_req | gerrit gsql
  echo $review_req | gerrit gsql
}

function gerrit(){
  if [ "$1" = "" ]; then
    x-www-browser ${GERRIT_SERVER}
  else
    ssh -p 29418 $GERRIT_SERVER "gerrit $*"
  fi
}

function rstart() {
  echo -n "Feature name: "
  read feature_name
  branch_name=`echo $feature_name | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | sed 's/_*$//g'`
  git checkout -b  ${branch_name} --track ${GERRIT_STANDARD_BRANCH}

}

alias gerrit-install-hook="scp -P 29418  ${GERRIT_SERVER}:hooks/commit-msg .git/hooks/"
alias rpush="git review "
alias dpush="git review --draft"
alias rlist="git review --list"
alias rpull="git review --download"
alias rpick="git review --cherrypick"
