export ZSH="$HOME/.oh-my-zsh"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"


DISABLE_UNTRACKED_FILES_DIRTY="true"


# ZSH_CUSTOM=/path/to/new-custom-folder

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='hx'
else
  export EDITOR='code'
fi

plugins=(git sudo)

source $ZSH/oh-my-zsh.sh


eval "$(starship init zsh)"


# aliases
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
