
###################################################################################################################
############################### completion stuff ##################################################################
###################################################################################################################

hosts=("${(s: :)${(s:   :)${${(f)$(</etc/hosts)}%%\#*}#*[       ]*}}")

groups=( "${${(f)$(</etc/group)}%%:*}" )



zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo candidate for: %d%b'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

compctl -D -f + -H 0 '' -X '(No file found; using history)'
compctl -o setopt
compctl -v echo export
compctl -z -P '%' bg
compctl -j -P '%' fg jobs disown
compctl -j -P '%' + -s '`ps -x | tail +2 | cut -c1-5`' wait
compctl -A shift


zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:processes-names' command 'ps -e -o comm='
zstyle ':completion:*' verbose yes

zstyle ':completion:*' completer _expand _complete
zstyle :compinstall filename $HOME'/.zshrc'

zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

#function _cr_commands(){
#  echo $*
#  cr_commands=(`cd ~/Sources; cr help | grep '*' | awk '{print $2}'`)
#}

#compdef _cr_commands cr

