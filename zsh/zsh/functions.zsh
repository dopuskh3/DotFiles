function mylog() {
  echo "$bg[grey]$fg[red]"$*"$reset_color"
}

function logscreens {
  sessions=`screen -ls | perl -ne 'print " * $1\n" if /^\s+(.+?)\s+\((.+?)\).+$/'`
  if [ "$sessions" != "" ]; then
    echo -n "$fg[green]"
    echo "Available screen sessions:    "
    echo "$sessions"
    echo -n "$reset_color"
  fi
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


function title {
    if [[ $TERM == "screen" ]]; then
        print -nR $'\033k'$1$'\033'\\\
        print -nR $'\033]0;'$2$'\a'
    elif [[ $TERM == "xterm" || $TERM == "rxvt" ]]; then
            print -nR $'\033]0;'$*$'\a'
    fi
}



# Used to update my 
#D: precmd: used for precommand 
#
precmd () {
	if [[ "$HOST" == "" ]]; then 
		export HOST=$HOSTNAME
	fi
	if [[ "$TERM" == "screen" ]]; then 
		echo -ne "\ek$USER@$HOST\e\\"
  #     title $HOST screensession
 #      title $HOST $PWD
	fi
#     echo -ne "\033]0;$HOME:$TERM\007"

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

#function man () {
#      command man $* | col -b | vim -c 'set ft=man' -c 'set nomod' -
#
#}

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
		$XBROWSER -remote "openurl(http://www.google.com/search?q=$QUERY)"
	fi
}

#D: archinfo: try to extract an arbitrary function
function archinfo () {
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

    PNAME=$1
    RETVAL=0

    for signal in "TERM" "INT" "HUP" "KILL"; do
         pkill -$signal $PNAME
          RETVAL=$?
         [ $RETVAL -eq 0 ] && break
         echo "warning: kill failed: pname=$PNAME, signal=$signal" >&2
         sleep 1
    done
return $RETVAL
}

#D: grev pattern and edit files that match with vim 
function vigrep () {
   
  command=$(egrep -I $* | awk -F: '{print "vim "$1" +"$2";"}') 
  tmpfile=$(mktemp)
  echo $command > $tmpfile
  echo $command
  echo "You will edit those files: "
  read 
  sh $tmpfile

}


#D: myhelp: Print builtins function documentation
function myhelp () {
    echo 
    echo "Personal builtin commands from zshrc: "
    echo 
    grep "^#D: " $HOME/.zshrc | awk -F"#D: " '{print "\t"$2""}' | sed 's/: /:\t/g'
    echo ""
    
    echo $HELP
}

function tgzts () {
    for directory in $@; do
        tar zcvf $directory-$(date +"%Y%m%d").tar.gz $directory
    done
}

function tbzts () {
    for directory in $@; do
        tar jcvf $directory-$(date +"%Y%m%d").tar.bz2 $directory
    done
}

#D: svnkwset: set basic svn keywords on a file
function svnkwset () {
    kw="LastChangedDate Author LastChangedRevision LastChangedBy HeadURL Id"
    echo "Setting the following keywords on $@: $kw"
    svn propset svn:keywords $kw $@
}

HELP="
    fv\'s zsh documentation 
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
