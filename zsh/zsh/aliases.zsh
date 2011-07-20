
alias ls='/bin/ls -Ft $LS_OPT2'

if swhich vim; then 
	alias less='myless'
else
	alias less='less -X -M'
fi


alias dh="dirs -v"
alias find='noglob find'
alias sshclean='rm ~/.ssh/known_hosts'
alias ssh='ssh  -o "PasswordAuthentication=yes"'
alias cleancmake='rm -Rf CMakeFiles/ CMakeCache.txt'
alias grep='grep --color'
alias egrep='egrep --color'

alias -s txt=$EDITOR
alias -s pdf=xpdf
alias -s gz=archinfo
alias -s bz2=archinfo
alias -s tbz=archinfo
alias -s tgz=archinfo
alias -s bz=archinfo
alias -s vim=vim
alias -s c=vim
alias -s h=vim
alias "o"="xdg-open"


# FreeBSD aliases 
if [ `uname` = FreeBSD ]; then
	alias dev_mode="vidcontrol -f 8x8 /usr/shãre/sýscøns/fønts/swiss-8x8.fnt 80x60"
	alias dev_mode2="vidcontrol -f 8x8  /usr/shãre/sýscøns/fønts/cþ4³7-thin-8x8.fnt"
	alias reverse_mode="vidcontrol black white white black"
fi


