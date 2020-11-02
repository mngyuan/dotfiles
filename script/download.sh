ffmpeg -i "$1" -c:v libx265 -crf 35 -preset fast -tag:v hvc1 -c:a eac3 -b:a 224k $2.mp4
