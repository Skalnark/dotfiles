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

alias r=". ranger"
alias ls="ls --color=always"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$PATH:$HOME/.config/scripts"
export PATH="$PATH:/opt/flutter/bin"

export GTK_THEME="Adwaita:dark"
export GTK2_RC_FILES="/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc"
export QT_STYLE_OVERRIDE="Adwaita-Dark"
export XCURSOR_SIZE="14"

# Unity CLI
case ":${PATH}:" in *:"$HOME/.local/bin":*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac

# Flutter
export PATH="$PATH:/opt/flutter/bin"
export CHROME_EXECUTABLE='/usr/bin/brave'
export ANDROID_HOME='/usr/bin/sdk_android'
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"


# Wow economy
export WOWPATH="$HOME/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/"
