setxkbmap -model abnt2 -layout br &
sxhkd &
picom --config $HOME/.config/picom/picom.conf &
exec bspwm
