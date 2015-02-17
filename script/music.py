"""
music.py

Kevin Lee, 2013
---------------
Take files formatted like:

Song title - Artist.mp3

and swaps to

Artist - Song title.mp3

or vice versa, inside of the directory
this script is placed inside. Files are
moved to a renamed/ directory. Originally
coded after the great Spotify HTML5 .mp3
fiasco of 2013.

Run with python2 music.py in the directory
you want to modify.
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