# dotfiles/script

## calc.py

A weighted grade calculator, using grades entered into a .txt file. Calculate what score is needed to get a desired grade.

## music.py and id3.py

music.py formats all the files in a directory from `Title - Artist.mp3` to `Artist - Title.mp3`, which was useful after the great Spotify HTML5 .mp3 disaster of '13.
id3.py uses the eyed3 module to add Artist and Song Name information into mp3 files' ID3 tags, based on their naming as `Artist - Title.mp3`.

## link.py

Changes raw links embedded in HTML into Google Doc Spreadsheet formulas, for easy copypasta.

## txtconvert.py

Converts from CRLF to LF and vice versa.

## nhk-sunshine.sh

Sunshine app launcher that streams NHK Plus from tangyuanjiqi to the Fire TV via Moonlight. It brings up the ProtonVPN Japan connection, switches the display to 2560x1440, opens https://plus.nhk.jp/ fullscreen in Chromium and clicks the video to start it. Run with `stop` (Sunshine's prep-cmd undo) it closes the window, restores the display and drops the VPN.

Chromium is used because it has Widevine; Firefox-based browsers (Zen included) get "このブラウザでは再生できません". Needs `wmctrl`, `python3-xlib` and X11.

Setup on tangyuanjiqi:

1. `ln -s ~/git/dotfiles/script/nhk-sunshine.sh ~/.local/bin/nhk-sunshine.sh`
2. Set `VPN` (a NetworkManager WireGuard connection, see `nmcli -t -f NAME,TYPE connection show`), `OUTPUT` (tangyuanjiqi: `HDMI-A-0`) and `STREAM_MODE` at the top of the script.
3. Add this to `~/.config/sunshine/apps.json` (or the web UI at https://localhost:47990):
   ```json
   {
       "name": "NHK Plus",
       "cmd": "/home/mngyuan/.local/bin/nhk-sunshine.sh",
       "auto-detach": true,
       "wait-all": true,
       "exit-timeout": 5,
       "elevated": false,
       "image-path": "desktop.png",
       "prep-cmd": [
           {"do": "/bin/true", "undo": "/home/mngyuan/.local/bin/nhk-sunshine.sh stop"}
       ]
   }
   ```
4. Create `~/.config/autostart/sunshine.desktop` with `Exec=systemctl --user start sunshine`. Sunshine's own unit never starts on Cinnamon, which doesn't activate `xdg-desktop-autostart.target`. Then `systemctl --user restart sunshine`.
5. In Moonlight, pair with the PIN (entered in the Sunshine web UI) and launch "NHK Plus". Sign in to NHK Plus in Chromium the first time.

Notes:

- Quit the session from Moonlight so `stop` runs. Otherwise restore tangyuanjiqi's display by hand: `xrandr --output HDMI-A-0 --mode 3840x2160 --scale-from 6144x3456 --filter bilinear`.
- tangyuanjiqi normally runs a 4K panel with a 1.6x scaling transform (6144x3456) and `Xft.dpi: 192`. At 1440p that makes Chromium use scale factor 2, i.e. a 1280 CSS px viewport and NHK's tablet layout. The script passes `--force-device-scale-factor=1.25` (`SCALE`), which is ignored if Chromium is already running, so close all Chromium windows first.
- The click only happens while Chromium reports nothing playing (MPRIS), so other media playing in Chromium makes it skip the click.
- The TV must reach tangyuanjiqi on the LAN while the VPN is up; enable LAN access in the Proton app if not.
