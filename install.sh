#!/usr/bin/bash
sudo pacman -Syu
yay -S alsa-lib bashtop bat binutils bluez-libs bspwm curl \
docker docker-compose dotnet-sdk exa feh firefox fontconfig gdbm \
git gnome-keyring gnu-free-fonts gnupg go kitty mesa linux-firmware \
nano ncurses neovim networkmanager ntp nvidia nvidia-utils openssl \
openjpeg2 picom ranger rofi brave-bin otf-fira-mono otf-fira-sans \
pacmixer polybar polybar-spotify-module pulseaudio spotify sqlite \
sudo sxhkd tar ttf-dejavu ttf-fira-code \
ttf-iosevka-nerd vim unzip atool xbindkeys xcompmgr xdg-utils \
xf86-input-libinput xf86-video-intel xf86-video-vesa xkeyboard-config \
xorg-font-util xorg-server xorg-setxkbmap xorg-xinit xorg-xinput \
xorg-xprop xorg-xsetroot xterm zsh zsh-theme-powerlevel10k-git \
postman-bin dbeaver youtube-dl discord noto-fonts-emoji ttf-joypixels ntfs-3g \
newsboat

sudo usermod -aG docker $USER
