

function tmux-list () {
  tmux has-session 2> /dev/null
  if [ $? -eq 0 ]; then
    tmux list-sessions
  fi
}

#D: tmux-pair: Create a remote tmux session.
function tmux-pair () {
  local host session_path default_session_name
  host=$1
  session_path="/tmp/tmux-pair"
  default_session_name="pair"

  if [ $# -lt 2 ]; then
    session=$default_session_name
  else
    session=$2
  fi
  session_full_path="$session_path/$session"
  remote_command="mkdir -p $session_path &&
chmod 777 $session_path &&
if [ ! -e $session_full_path ]; then
  tmux -S $session_full_path new-session -d
fi
chmod 1777 $session_full_path &&
tmux -S $session_full_path attach-session
"
  ssh $host -t "$remote_command"
}

function tmx () {

  if [[ -z "$1" ]]; then
    echo "Specify session name as the first argument"
    return
  fi

  # Only because I often issue `ls` to this script by accident
  if [[ "$1" == "ls" ]]; then
    tmux ls
    return
  fi

  base_session="$1"
  # This actually works without the trim() on all systems except OSX
  tmux_nb=`tmux ls | grep "^$base_session" | wc -l | cut -f 1`
  if [[ "$tmux_nb" == "0" ]]; then
    echo "Launching tmux base session $base_session ..."
    tmux new-session -s $base_session
  else
    # Make sure we are not already in a tmux session
    if [[ -z "$TMUX" ]]; then
      # Kill defunct sessions first
      old_sessions=$(tmux ls 2>/dev/null | egrep "^[0-9]{14}.*[0-9]+\)$" | cut -f 1 -d:)
      for old_session_id in $old_sessions; do
        tmux kill-session -t $old_session_id
      done

      echo "Launching copy of base session $base_session ..."
      # Session is is date and time to prevent conflict
      session_id=`date +%Y%m%d%H%M%S`
      # Create a new session (without attaching it) and link to base session
      # to share windows
      tmux new-session -d -t $base_session -s $session_id
      # Create a new window in that session
      #tmux new-window
      # Attach to the new session
      tmux attach-session -t $session_id
      # When we detach from it, kill the session
      tmux kill-session -t $session_id
    fi
  fi

}

export PATH=$PATH
alias t=tmx
