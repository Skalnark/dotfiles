#!/usr/bin/bash

sudo pacman -Syu
sudo pacman -S git go --no-confirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg
sudo pacman -U *.pkg.tar.zst --noconfirm
