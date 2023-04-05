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

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


eval "$(starship init zsh)"


# aliases
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

#alias python="$(pyenv which python)"
#alias pip="$(pyenv which pip)"