#
# Bootstrap zsh environement

source ~/.zsh/options.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/bindings.zsh
source ~/.zsh/completion.zsh

disable -a ls
loadmodules
source ~/.zsh/init.zsh
antigen-bundle zsh-users/zsh-syntax-highlighting
antigen bundle kennethreitz/autoenv

antigen-apply
enable -a ls

