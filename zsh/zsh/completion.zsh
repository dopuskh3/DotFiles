
###################################################################################################################
############################### completion stuff ##################################################################
###################################################################################################################

hosts=("${(s: :)${(s:   :)${${(f)$(</etc/hosts)}%%\#*}#*[       ]*}}")

groups=( "${${(f)$(</etc/group)}%%:*}" )

fpath=($fpath ~/.zsh/completion)

autoload -U compinit
compinit

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

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}

compctl -K _pip_completion pip


function _ninja() {
  reply=(`(ninja -t targets all 2&>/dev/null) | awk -F: '{print $1}'`)
}

compctl -K _ninja ninja



