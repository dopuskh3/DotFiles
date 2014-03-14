# vim:set ft=zsh
# Shell initialization functions
#

for i in $HOME/.zshrc_local $HOME/.zlocal; do
if [ -e $i ]; then
	zlog "Sourcing local zsh config $i"
	source $i
fi
done

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

# python
if [ -e ~/.pythonrc ]; then
  export PYTHONSTARTUP=~/.pythonrc
else
  zlog "No python startup file found."
fi


if swhich keychain; then
  keychain -q id_rsa
	host=`uname -n `
	[ -f $HOME/.keychain/$host-sh ] && source $HOME/.keychain/$host-sh
else
  zlog "Keychain not found."
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


if [ "$TERM" != "screen" ]; then
  tmux-list
fi




