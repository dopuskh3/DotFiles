# vim:set ft=zsh
#
# Set various zsh options and variables
#


#### Shell prompt 
# PROMPT='%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $(git_prompt_info)%(!.#.>)'
PROMPT='%{$fg[green]%}%B%n%b%{$reset_color%}@%{$fg[blue]%}%B%m%b%{$reset_color%}:%{$fg[red]%}%B%c/%{$reset_color%}%(!.#.%%)%b '
# PS1="%B%n@%m%b(%(?:%{$fg[green]%}%?:%{$fg[red]%}%?)%{$reset_color%})~%% "

#### History variables
HISTSIZE=200000
SAVEHIST=200000
HISTFILE="$HOME/.zsh_history"


autoload -U colors 
autoload add-zsh-hook
colors


setopt printeightbit
setopt ALL_EXPORT
setopt CORRECT
setopt MENU_COMPLETE
setopt EXTENDED_GLOB
setopt AUTO_PARAM_SLASH
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
# setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt AUTO_CD
setopt autopushd 
setopt prompt_subst


# This makes the shell give immediate notice of 
# changes in job status, which is my preference.
setopt NOTIFY

setopt autopushd pushdminus pushdsilent
setopt pushdtohome 


