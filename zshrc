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
zstyle :compinstall filename '/home/skalnark/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


export PATH="$PATH:$HOME/.local/bin"
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$PATH:/home/skalnark/bin/flutter/bin"
export PATH="$PATH:/home/skalnark/bin/android-studio/bin"
export PATH="$PATH:/home/skalnark/.dotnet/tools"
export PATH="$PATH:/home/skalnark/bin/VSCode-linux-x64/bin"
export PATH="$PATH:/home/skalnark/bin/Sevenz2101-linux-x64"
export PATH="$PATH:/home/skalnark/bin/dotnet"
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOPATH

alias r=". ranger"
alias ls="ls --color=always"
alias cpr="rsync --progress"
alias dc="docker-compose"
alias code="code-insiders"

[ -f "/home/skalnark/.ghcup/env" ] && source "/home/skalnark/.ghcup/env" # ghcup-env

