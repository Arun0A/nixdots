pulseaudio --start &
feh --no-fehbg --bg-fill ~/Pictures/walls/wall5.png &
# xset b off
picom -b --backend glx &
# blueman-applet &
copyq &
touchegg &
xinput set-prop 9 347 45 &
redshift -O 5000
~/.nixdots/dwm/status.sh &
export XDG_SESSION_TYPE=x11
exec dwm
