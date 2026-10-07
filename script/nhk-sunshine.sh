#!/usr/bin/env bash
# Sunshine "NHK Plus" app.
#   nhk-sunshine.sh [start]  make sure ProtonVPN (JP) is up, then open NHK Plus fullscreen
#   nhk-sunshine.sh stop     close the NHK window, restore the display mode and disconnect the VPN
#                            (Sunshine's prep-cmd undo)
set -u
VPN="ProtonVPN JP#182"
URL="https://plus.nhk.jp/"
OUTPUT="HDMI-A-0"            # xrandr output to switch while streaming
STREAM_MODE="2560x1440"
SCALE="1.25"                 # Chromium device scale factor; 2560/1.25 = 2048 CSS px wide
STATE="${XDG_RUNTIME_DIR:-/tmp}/nhk-sunshine-display"

# ids of Chromium windows whose title mentions NHK (wmctrl works on X11 only)
nhk_windows() {
    wmctrl -lx | awk 'tolower($3) ~ /chromium/ && tolower($0) ~ /nhk/ {print $1}'
}

# true if any Chromium instance reports MPRIS PlaybackStatus "Playing"
is_playing() {
    local n
    for n in $(busctl --user list --no-pager 2>/dev/null | awk '/org.mpris.MediaPlayer2.chromium/ {print $1}'); do
        busctl --user get-property "$n" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlaybackStatus 2>/dev/null |
            grep -q '"Playing"' && return 0
    done
    return 1
}

# left-click the centre of window $1 (hex id) with XTEST (python-xlib, no xdotool needed)
click_centre() {
    python3 -I - "$1" <<'PY'
import sys
from Xlib import X, display
from Xlib.ext import xtest
d = display.Display()
w = d.create_resource_object("window", int(sys.argv[1], 16))
g = w.get_geometry()
c = d.screen().root.translate_coords(w, g.width // 2, g.height // 2)
xtest.fake_input(d, X.MotionNotify, x=c.x, y=c.y)
xtest.fake_input(d, X.ButtonPress, 1)
xtest.fake_input(d, X.ButtonRelease, 1)
d.sync()
PY
}

# The desktop normally runs a 4K panel mode with a fractional-scaling transform (a ~6144x3456
# framebuffer), which gives a huge, mostly empty page and an expensive capture. Switch to a plain
# STREAM_MODE while streaming, and put the original mode and framebuffer size back afterwards.
set_stream_mode() {
    if [ ! -e "$STATE" ]; then
        local mode fb
        mode=$(xrandr | awk -v o="$OUTPUT" '$1 == o {f = 1; next} /^[^ ]/ {f = 0} f && /\*/ {print $1; exit}')
        fb=$(xrandr -q | sed -n 's/.*current \([0-9]*\) x \([0-9]*\),.*/\1x\2/p')
        echo "$mode $fb" > "$STATE"
    fi
    xrandr --output "$OUTPUT" --mode "$STREAM_MODE" --scale 1x1
    sleep 2
}

restore_mode() {
    [ -e "$STATE" ] || return 0
    local mode fb
    read -r mode fb < "$STATE"
    xrandr --output "$OUTPUT" --mode "$mode" --scale-from "$fb" --filter bilinear && rm -f "$STATE"
}

if [ "${1:-start}" = "stop" ]; then
    for id in $(nhk_windows); do wmctrl -ic "$id"; done
    restore_mode
    nmcli connection down "$VPN"
    exit 0
fi

if ! nmcli -t -f NAME connection show --active | grep -qxF "$VPN"; then
    nmcli connection up "$VPN" || { echo "could not bring up $VPN" >&2; exit 1; }
fi

# wait until we actually exit through Japan
for _ in $(seq 1 20); do
    [ "$(curl -s --max-time 3 ipinfo.io/country)" = "JP" ] && break
    sleep 1
done

set_stream_mode

# Chromium in its default profile: it already has the Widevine CDM that NHK Plus needs (Zen/Firefox
# get "このブラウザでは再生できません"), and the NHK login persists. If Chromium is already running
# this hands off to it and exits straight away; Sunshine's auto-detach keeps the stream going.
# Xft.dpi is 192 on this desktop, so Chromium would default to a scale factor of 2 (a 1280 CSS px
# wide viewport at 1440p, which flips NHK to its tablet layout and pushes the video below the fold).
# The flag only applies if this starts a fresh Chromium process; an already-running one ignores it.
chromium --new-window --start-fullscreen --force-device-scale-factor="$SCALE" "$URL" &

# best effort: fullscreen the NHK window once it appears
id=""
for _ in $(seq 1 30); do
    id=$(nhk_windows | head -n1)
    [ -n "$id" ] && break
    sleep 1
done
if [ -n "$id" ]; then
    wmctrl -ir "$id" -b add,fullscreen
    sleep 5   # let the page and its player load

    # The player only starts on a click anywhere on the video. Click the window centre until
    # Chromium reports (MPRIS) that something is playing; never click while it already is,
    # since that would pause it.
    for _ in 1 2 3 4; do
        is_playing && break
        click_centre "$id"
        sleep 4
    done
fi
wait
