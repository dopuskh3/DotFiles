# vim:set ft=zsh
# Global aliases
#
alias ls='/bin/ls -Ftr $LS_OPT2'

if swhich vim; then
	alias less='myless'
else
	alias less='less -X -M'
fi

alias v="vim"
alias dh="dirs -v"
alias find='noglob find'
alias ssh='ssh  -o "PasswordAuthentication=yes"'
alias cleancmake='rm -Rf CMakeFiles/ CMakeCache.txt'
alias grep='grep --color'
alias egrep='egrep --color'

alias -s txt=$EDITOR
alias -s pdf=xpdf
alias -s gz=archextract
alias -s bz2=archextract
alias -s tbz=archextract
alias -s tgz=archextract
alias -s bz=archextract
alias -s vim=vim
alias -s c=vim
alias -s h=vim
#D: open: use xdg-open
alias "o"="xdg-open"

#D: h: help
alias "h"="help"
#D: abspath: print absolute path
alias abspath="readlink -f"

# FreeBSD aliases
if [ `uname` = FreeBSD ]; then
	alias dev_mode="vidcontrol -f 8x8 /usr/shãre/sýscøns/fønts/swiss-8x8.fnt 80x60"
	alias dev_mode2="vidcontrol -f 8x8  /usr/shãre/sýscøns/fønts/cþ4³7-thin-8x8.fnt"
	alias reverse_mode="vidcontrol black white white black"
fi



