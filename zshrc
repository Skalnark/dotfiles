# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME:/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall


export PATH="$PATH:$HOME/.local/bin"
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/usr/local/bin/VSCode-linux-x64-insiders/bin":$PATH
export PATH="/usr/local/bin/VSCode-linux-x64/bin":$PATH
export PATH="$HOME/.dotnet/tools":$PATH
export PATH="/usr/local/bin/scripts":$PATH
export PATH="$HOME/.bin":$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export GOPATH=$HOME/go
export GOBIN="/usr/local/bin/go/bin"
export PATH=$PATH:$GOPATH:$GOBIN
export PATH=$PATH:"$HOME/.local/share/gem/ruby/3.0.0/bin"

alias r=". ranger"
alias ls="exa"
alias cpr="rsync --progress"
alias dc="docker-compose"
alias cat="bat"
alias vim="nvim"
alias unity="nohup UnityHub.AppImage"
alias exit="exit 0"
alias mfa="python3 ~/.aws/mfa.py"

[ -f "$HOME:/.ghcup/env" ] && source "$HOME:/.ghcup/env" # ghcup-env

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
source $HOME/.rvm/scripts/rvm

# Orbee related stuff
export AWS_PROFILE=technology
export AWS_SDK_LOAD_CONFIG=1
