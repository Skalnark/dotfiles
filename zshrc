# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/skalnark/.zshrc'
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

autoload -Uz compinit
compinit
# End of lines added by compinstall
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

alias r=". ranger"
alias ls="ls --color=always"
alias mfa="python $HOME/.aws/mfa.py"
alias android-studio="/usr/local/bin/android-studio/bin/studio.sh"
alias dc="docker-compose"
alias exit="exit 0"
alias cls='printf "\033c"'

alias usejava8='sudo archlinux-java set java-8-openjdk'
alias usejava23='sudo archlinux-java set java-23-openjdk'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/bin/flutter/bin"
export PATH="$PATH:/usr/local/bin/android-studio/bin"
export PATH="$PATH:/usr/local/bin/VSCode-linux-x64/bin"
export PATH="$PATH:$HOME/.config/scripts"
export PATH="$PATH:/opt/gradle/gradle-6.0.1/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Orbee related stuff
export AWS_PROFILE=technology
export AWS_SDK_LOAD_CONFIG=1
export EDITOR=vim

export JAVA_HOME="/usr/lib/jvm/default"

if [[ $(xrandr --query | grep 'HDMI1' | grep -w 'connected') != *disconnected* ]]; then
	export DUAL_MONITOR="1"
fi

export GTK_THEME="Adwaita:dark"
export GTK2_RC_FILES="/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc"
export QT_STYLE_OVERRIDE="Adwaita-Dark"

[ -f "/home/skalnark/.ghcup/env" ] && . "/home/skalnark/.ghcup/env" # ghcup-env