
```

# fade out the last 6 seconds of intro song
ffmpeg -i swarmed-title--2025-07-07.ogg   -af "afade=t=out:st=$(ffprobe -v error -show_entries format=duration \ 
  -of default=noprint_wrappers=1:nokey=1 swarmed-title--2025-07-07.ogg | awk '{print $1 - 6}'):d=6"   -c:a libvorbis -qscale:a 10 swarmed-title--fade-out--2025-07-07.ogg

```
