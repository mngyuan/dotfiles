"""
id3.py

Kevin Lee, 2013
---------------

uses the eyed3 module to add artist/song
info to songs based on the name format

Artist - Title.mp3

in the directory this script is in. 
requires python2.7, eyed3. Best used
with/after music.py has properly formatted
a folder.
"""

import eyed3
import os

for filename in os.listdir(u'.'): #lol trentemoller
    audiof = eyed3.load(filename)
    if audiof != None:
        # successfully loaded an audio file
        tag = audiof.tag
        if tag == None:
            tag = eyed3.id3.Tag()

        info = filename[:filename.rfind('.')]
        info = info.split(' - ',1)
        if len(filename) >= 2:
            print "Modified", info[0], "-", info[1]
            tag.artist = info[0]
            tag.title = info[1]
            audiof.tag = tag
            tag.save(filename)
        else:
            print "Could not work with", filename
