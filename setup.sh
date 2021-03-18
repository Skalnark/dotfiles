#!/usr/bin/env 
cp xmonad.hs $HOME/.xmonad/xmonad.hs

cp -r config/* $HOME/.config/
cp p10k.zsh $HOME/.p10k.zsh
cp zshrc $HOME/.zshrc
cp vimrc $HOME/.vimrc

rm $HOME/.config/kitty/theme.conf
ln $HOME/.config/kitty/kitty-themes/themes/Flatland.conf $HOME/.config/kitty/theme.conf


echo DONE!
