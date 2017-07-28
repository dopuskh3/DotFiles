#
# Bootstrap zsh environement
source $HOME/.zsh/modules/antigen.zsh
antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle kennethreitz/autoenv
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle tarruda/zsh-autosuggestions

antigen theme bira

antigen apply
enable -a ls

source ~/.zsh/options.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/bindings.zsh
source ~/.zsh/completion.zsh

zmodload zsh/terminfo

disable -a ls
loadmodules
source ~/.zsh/init.zsh
