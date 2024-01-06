# appears to work
# on login, automatically start sway using script
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    source ~/.local/bin/swaylaunch
fi
