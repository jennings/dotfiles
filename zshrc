ZSH=$HOME/.oh-my-zsh

# If you set this to "random", it'll load a random theme
ZSH_THEME="jennings"

alias erl="nocorrect erl"
alias rspec="nocorrect rspec"
alias -g lg="lg"

# My fingers forget where I am
alias dir="ls"
alias cls="clear"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

export EDITOR="/usr/local/bin/mvim"
export FIGNORE=".o:~:.swp"
export GOPATH=~/Code/go
export LESS=-FRSX

PATH=$GOPATH/bin:$PATH
PATH=/usr/local/share/npm/bin:$PATH
PATH=/usr/local/bin:$PATH
PATH=~/bin:$PATH
export PATH

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
