export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=dwm

systemctl --user import-environment \
    DISPLAY \
    XAUTHORITY \
    XDG_SESSION_TYPE \
    XDG_CURRENT_DESKTOP

dbus-update-activation-environment --systemd \
    DISPLAY \
    XAUTHORITY \
    XDG_SESSION_TYPE \
    XDG_CURRENT_DESKTOP

pulseaudio --start &
~/.fehbg
xset b off
picom -b --backend glx &
# blueman-applet &
copyq &
touchegg &
dunst &
xinput set-prop "ELAN06FA:00 04F3:31BE Touchpad" 347 45 & # Elan Trackpad Scrolling Distance
xinput set-prop "Logitech MX Anywhere 3S" 349 0 & # Disable MXA3S High-Res Scroll
xmodmap -e "keycode 191 = Delete"
redshift -O 5000
~/.nixdots/dwm/status.sh &

# Initialize GNOME Keyring for NixOS + dwm
if [ -x /run/wrappers/bin/gnome-keyring-daemon ]; then
    eval $(/run/wrappers/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export GNOME_KEYRING_CONTROL
    export GNOME_KEYRING_PID
    export SSH_AUTH_SOCK
fi

# Ensure D-Bus is aware of the keyring variables
if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    dbus-update-activation-environment --systemd GNOME_KEYRING_CONTROL GNOME_KEYRING_PID SSH_AUTH_SOCK
fi

# exec dwm
while true; do
    # dwm 2> ~/.dwm.log
    dwm >/dev/null 2>&1
    [ $? -ne 0 ] && break
done
