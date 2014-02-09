# vim:set ft=zsh
#
# Global functions
#

function zlog() {
  local opt=""
  [ "$1" = "-n" ] && opt=$1 && shift
  echo $opt "$bg[black]$fg_bold[green]"▶ $*"$reset_color"
}

function zlogerr() {
  local opt=""
  [ "$1" = "-n" ] && opt=$1 && shift
  echo $opt "$bg[red]$fg_bold[white]"⬤ $*"$reset_color"
}

function swhich(){
  which $* > /dev/null
  return $?
}


# function to reload completion FIXME
function recomp {
	echo "Reloading zsh completion (compinit)"
	if [ -e $HOME/.zcompdump ]; then
		rm .zcompdump
	fi
	if [ -e $HOME/.zcompdump.$HOST ]; then
		rm .zcompdump.$HOST*
	fi
	unfunction compinit; autoload -U compinit;
}

# Used to update my
#D: precmd: used for precommand
#
precmd () {
	if [[ "$HOST" == "" ]]; then
		export HOST=$HOSTNAME
	fi
}

# replace less with vim, very usefull for syntax highligting
#D: myless: a wrapper for less
function myless () {
	if [[ $# -eq 0 ]] ; then
		vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' -
	else
	    vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' "$@"
	fi
}

function man () {
  command man $* | col -b | vim -c 'set ft=man' -c 'set nomod' -
}

# dummy function to make a web search
#D: google: search google for a word
function google () {

	for i in $@;do
		if [ "x$QUERY" != "x" ]; then
			QUERY="$QUERY+$i"
		else
			QUERY="$i"
		fi
	done

	if [[ "x$DISPLAY" == "x" ]]; then
		$TEXTBROWSER "http://www.google.com/search?q=$QUERY"
	else
		x-www-browser "http://www.google.com/search?q=$QUERY"
	fi
}

#D: archextract: try to extract an archive
function archextract () {
	if [[ "$1:e" == "gz" || "$1:e" == "tgz" ]]; then
		tararg="z"
	elif [[ "$1:e" == "tbz" || "$1:e" == "bz2" || "$1:e" == "bz" ]]; then
		tararg="j"
	else
		echo "Bad archive ? "
		exit 1
	fi

	if [[ "$2" == "-x" ]]; then
		tar xvf$tararg $1
	else
		tar tvf$tararg $1
	fi
}

#D: kil: kil a program trying multiple signals
function kil () {
    PID=$1
    RETVAL=0
    for signal in "TERM" "INT" "HUP" "KILL"; do
         kill -$signal $PID
          RETVAL=$?
         [ $RETVAL -eq 0 ] && break
         echo "warning: kill failed: pid=$PID, signal=$signal" >&2
         sleep 1
    done
return $RETVAL
}


#D: pkil: kill a program trying multiple signals
function pkil () {
    local PNAME=$1
    local RETVAL=0
    local signal

    for signal in "TERM" "INT" "HUP" "KILL"; do
         pkill -$signal $PNAME
         RETVAL=$?
         [ $RETVAL -eq 0 ] && break
         echo "warning: kill failed: pname=$PNAME, signal=$signal" >&2
         sleep 1
    done
return $RETVAL
}

#D: vigrep: grep pattern and edit files that match with vim
function vigrep () {
  local command=$(egrep -I $* | awk -F: '{print "vim "$1" +"$2";"}')
  tmpfile=$(mktemp)
  echo $command > $tmpfile
  echo $command
  echo "You will edit those files: "
  read
  sh $tmpfile

}

#D: tgzts <files>: Compress <files> into <files>-<timestamp>.tgz
function tgzts () {
    for directory in $@; do
        tar zcvf $directory-$(date +"%Y%m%d").tar.gz $directory
    done
}

#D: tgzts <files>: Compress <files> into <files>-<timestamp>.tar.bz2
function tbzts () {
    for directory in $@; do
        tar jcvf $directory-$(date +"%Y%m%d").tar.bz2 $directory
    done
}

#D: sshare <host> <path>: ssh mount host
function sshare () {
  local share_folder=$HOME/Shares
  local host=$1
  local hpath=$2
  local dest=$3
  if [ $# -ne 3 ]; then
    echo "Usage $0 <host> <remote_folder> <local_name>" 1>&2
    cd $share_folder
    return 1
  fi
  if [ "$hpath" = "" ]; then
    hpath="/"
  fi
  local dst=$share_folder/$dest
  mkdir -p $dst
  mount | grep "$dst" > /dev/null
  if [ $? -eq 0 ]; then
    zlog -n "Unmounting $dst..."
    fusermount -u $dst
    if [ $? -ne 0 ]; then
      zlogerr "Cannot umount $dst"
      return
    else
      zlog "OK"
    fi
  fi
  echo -n "Mounting $host:$hpath into $dst..."
  sshfs $host:$hpath $dst && echo "OK"
}

HELP="
    My zsh documentation
    -----------------------

zshrc aliases
--------------
    ./file.txt -> vim file.txt
    ./archive.(zip,tgz,tar.gz,tar.bz2) -> tar ztvf archive.xx
    ./archive.tgz -x -> tar zxvf
$(alias | awk -F= '{print "    "$1" -> "$2}')

tips and tricks
---------------

    globbing
    --------

    ls **                   recursive ls
    ls *c~[fp]*             all *.c and not begining with 'f' or 'p'
    ls rfc-<34-63>.txt      rfc from 34 to 63
    ls *(^/)                all but directorys
    ls **(^u[root])         all but root's files


"

#D: myhelp: Print builtins function documentation
function help () {
    echo
    echo "Personal builtin commands from zshrc: "
    echo
    grep "^#D: " $HOME/.zshrc $HOME/.zsh/* | awk -F"#D: " '{print "\t"$2""}' | sed 's/: /:\t/g' | less
    echo ""

    echo $HELP
}

function loadmodules () {
  local module
  user_modules=(~/.zsh/modules/*.zsh)
  zlog -n "Loading modules: "
  for module in $user_modules; do
    local modulebn=`basename $module`
    local modulename=${modulebn%.zsh}
    echo -n "$bg[black]$fg_bold[red]$modulename $reset_color"
    source $module
  done
  echo
}


