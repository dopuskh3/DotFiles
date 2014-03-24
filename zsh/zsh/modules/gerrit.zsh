GERRIT_SERVER='review.criteois.lan'

function review () {
  local tmplog=`mktemp`
  local ret
  if [ $# = 0 ]; then
    zlog "Pushing all reviews:"
    git --no-pager log --format='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' gerrit/master..HEAD
    git push gerrit HEAD:refs/publish/master > $tmplog 2>&1
    ret=$?
  else
    for i in $*; do
      zlog "Pushing $i:"
      zlog "  `git log -1 --format="%s" $i`"
      git push gerrit $i\:refs/publish/master > $tmplog 2>&1
      ret=$?
    done
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
    l=`git log --pretty=oneline --abbrev-commit gerrit/master..$branch`
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
    ssh -p 29418 $USER@$GERRIT_SERVER "gerrit $*"
  fi
}

alias gerrit-install-hook="scp -P 29418  ${GERRIT_SERVER}:hooks/commit-msg .git/hooks/"
