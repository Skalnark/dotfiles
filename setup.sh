#!/usr/bin/env 

cp p10k.zsh $HOME/.p10k.zsh
cp zshrc $HOME/.zshrc
cp vimrc $HOME/.vimrc

rm $HOME/.config/kitty/theme.conf
ln $HOME/.config/kitty/kitty-themes/themes/Cobalt2.conf $HOME/.config/kitty/theme.conf


echo DONE!
