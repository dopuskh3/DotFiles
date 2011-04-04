
#### Shell prompt 
# PROMPT='%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $(git_prompt_info)%(!.#.>)'
PROMPT='%{$fg[green]%}%B%n%b%{$reset_color%}@%{$fg[blue]%}%B%m%b%{$reset_color%}:%{$fg[red]%}%B%c/%{$reset_color%}%(!.#.%%)%b '
# PS1="%B%n@%m%b(%(?:%{$fg[green]%}%?:%{$fg[red]%}%?)%{$reset_color%})~%% "

#### History variables
HISTSIZE=200000
SAVEHIST=200000
HISTFILE="$HOME/.zsh_history"


autoload -U colors 
colors
autoload -U compinit
compinit


#### Homedir 
#HOMEDIR=/home/fv

#### Dot file to backup 
# DOT_LIST=.zshrc .screenrc .gconf .vim .vimrc .fvwm* .screenrc .vimrc .ssh/id_rsa.pub
#MERGABLE_DOT_FILES=".zshrc .fluxbox/startup .vimrc"
#


#### favorite editor 
if swhich vim; then 
	EDITOR=vim 
else 
	EDITOR=vi
fi

#### favorite browser 

if swhich w3m; then 
	TEXTBROWSER=w3m
elif swhich elinks ; then 
	TEXTBROWSER=elinks
elif swhich links; then 
	TXTBROWSER=links
elif swhich lynx; then 
	TEXTBROWSER=lynx
fi

if swhich firefox; then 
	XBROWSER='firefox'
elif swhich mozilla; then 
	XOPENURL='mozilla'
fi

			
if swhich thunderbird;then
    XMAIL='thunderbird'
elif swhich 'mozilla-thunderbird'; then 
    XMAIL='mozilla-thunderbird'
fi

#### pager and manpager ( replaced with man function and myless function )

# path
if [ -d ~/bin ]; then 
  mylog -n "Optional bin path in ~/bin."
	PATH=$PATH:~/bin
fi
export PATH

# python

if [ -e ~/.pythonrc ]; then 
  mylog "Setting up python startup file..."
  export PYTHONSTARTUP=~/.pythonrc
fi


##### Some other dummy variables 

	####################
	##### linux ########
	####################
if [ `uname` = Linux ]; then
    if swhich vim; then 
		PAGER="less" 
        #"vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' "$@""
		# MANPAGER="col -b | vim  -c 'set ft=man nomod nolist' -"
        #runtime! macros/less.vim' -"
    fi
fi

	####################
	##### freebsd ######
	####################
if [ `uname` = FreeBSD ]; then
	export BLOCKSIZE=K
	export CLICOLOR=enable
    MANPAGER=""

fi
	####################
	##### openbsd ######
	####################
if [ `uname` = OpenBSD ]; then
	alias reverse_mode="vidcontrol black white white black"
	export BLOCKSIZE=K
	export CLICOLOR=enable
    MANPAGER=""
    # vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' -"
            
fi

export PS1 PAGER EDITOR SAVEHIST HISTFILE HISTSIZE MANPAGER
export LSCOLORS='cxgxhxhxbxhxhxbabacaca'




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


