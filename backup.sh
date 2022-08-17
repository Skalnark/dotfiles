#!/usr/bin/env

#cp $HOME/.zshrc zshrc
cp ~/.vimrc vimrc
cp ~/.p10k.zsh p10k.zsh
cp ~/.xmonad/xmonad.hs xmonad.hs
rm -r config/*
cp -r ~/.config/bspwm config 
cp -r ~/.config/kitty config
cp -r ~/.config/neofetch config
cp -r ~/.config/ranger config
cp -r ~/.config/scripts config
cp -r ~/.config/polybar config
cp -r ~/.config/xmobar config
cp -r ~/.config/sxhkd config
cp -r ~/.config/rofi config
cp ~/.zshrc zshrc
cp ~/.newsboat/urls newsboat_urls
