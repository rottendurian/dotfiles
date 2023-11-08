if pgrep -x swaylock ; then
    systemctl suspend
    swaymsg "output * dpms off"
fi
