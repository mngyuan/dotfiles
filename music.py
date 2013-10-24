"""
music.py
---------------
Take files formatted like:

Song title - Artist.mp3

and swaps to

Artist - Song title.mp3

or vice versa, in side of the directory
this script is placed inside. Files are
moved to a renamed/ directory
"""

import os

for filename in os.listdir('.'):
    newfn = filename.replace("▶", "") #i dont even
    newfn = newfn[:newfn.rfind('.')]
    ext = filename[filename.rfind('.'):]
    newfn = newfn.rsplit(' - ',1) #lol ne-yo

    if len(newfn) >= 2: #.DS_STORE lol
        newfn[0], newfn[1] = newfn[1].strip(), newfn[0].strip()
        newfn = newfn[0] + ' - ' + newfn[1] + ext

        os.rename(filename, "renamed/"+newfn)
        print("Rename:", filename, "to:", newfn)