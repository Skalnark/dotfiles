setxkbmap -model abnt2 -layout br &
sxhkd &
picom --config $HOME/.config/picom/picom.conf &
xinput set-prop 13 302 1 &
exec bspwm
