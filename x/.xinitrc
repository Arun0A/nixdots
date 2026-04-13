pulseaudio --start &
~/.fehbg
# xset b off
picom -b --backend glx &
# blueman-applet &
copyq &
touchegg &
xinput set-prop 9 347 45 & # Elan Trackpad Scrolling Distance
xinput set-prop 16 349 0 & # Disable MXA3S High-Res Scroll
redshift -O 5000
~/.nixdots/dwm/status.sh &
export XDG_SESSION_TYPE=x11
# exec dwm
while true; do
    # dwm 2> ~/.dwm.log
    dwm >/dev/null 2>&1
    [ $? -ne 0 ] && break
done
