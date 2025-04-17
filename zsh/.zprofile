# on login, automatically start Sway using script (from Sway Arch wiki)
if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
    source ~/.local/bin/swaylaunch
fi
