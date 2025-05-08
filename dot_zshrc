#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

#prompt nicoulaj
prompt steeef

# No need for ^S and ^Q to ruin everything
unsetopt flow_control

alias dir="ls"
alias cls="clear"
#alias emacs="open -a /Applications/Emacs.app $1"
alias clip=pbcopy
alias paste=pbpaste
alias dockerc=docker-compose
alias dotfiles='git --git-dir="$DOTFILES_REPO" --work-tree=$HOME'

export EDITOR="/usr/local/bin/vim"
export VISUAL=$EDITOR
export FIGNORE=".o:~:.swp"
export GOPATH=~
export LESS=-FRSX
export DOTFILES_REPO="~/src/github.com/jennings/dotfiles.git"

PATH=/usr/local/bin:$PATH
PATH=/usr/local/Cellar/node/6.8.1/bin:$PATH
PATH=~/.config/yarn/global/node_modules/.bin:$PATH
PATH=~/.cargo/bin:$PATH
PATH=~/.cabal/bin:$PATH
PATH=~/bin:$PATH
export PATH

export ANSIBLE_INVENTORY=~/.ansible_hosts.yml
export PIP_CONFIG_FILE=${XDG_CONFIG_HOME:-$HOME/.config}/pip/pip.conf
export FZF_DEFAULT_COMMAND='fd --type f'

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# OPAM configuration
. ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# z
[ -f /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
