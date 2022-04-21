# General Workflow

1. Acquire file (Soulseek, `youtube-dl`)
1. Sort into folders
1. MusicBrainz Picard for metadata
1. Convert using `ffmpeg` if necessary
1. Upload to iPod

# Commands

## Convert FLAC to ALAC

```zsh
for i in *.flac; do echo $i; ffmpeg -i "$i" -y -v 0 -vcodec copy -acodec alac  "${i%.flac}".m4a && rm -f "$i"; done
```

## Download from YouTube

Ran into artifacting with `youtube-dl`'s default AAC through the `-f 'bestaudio[m4a]'` command I used to use, so using `mp3` now.

```
youtube-dl -4 -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata <URL>
```
