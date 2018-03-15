#!/usr/bin/env bash

DOWNLOADDIRECTORY="/path/to/download/youtube"
CHANNELLIST="/path/to/channel-list"

YOUTUBEDL="/usr/local/bin/youtube-dl"
MAXDOWNLOAD="10"
DATEAFTER="now-1month"
FORMAT="bestvideo+bestaudio"
THREADS=5


IFS=$'\n'

channeldownload () {
    "$YOUTUBEDL" --playlist-end "$MAXDOWNLOAD" \
                 --download-archive "$DOWNLOADDIRECTORY/archive-list" \
                 --dateafter "$DATEAFTER" \
                 --continue \
                 --no-overwrites \
                 --ignore-errors \
                 --format "$FORMAT" \
                 --match-title "$2" \
                 --output "$DOWNLOADDIRECTORY/%(uploader)s/%(upload_date)s-%(title)s-%(id)s.%(ext)s" "$1"
}

if [ ! -f "$CHANNELLIST" ] ; then
    echo "channel-list missing" >&2
    exit 1
fi

for line in $(grep -v "^#" "$CHANNELLIST") ; do
    while [ "$(jobs | wc -l)" -ge "$THREADS" ] ; do
        sleep 1
    done
    url="$(echo "$line" | cut -d " " -f1)"
    pattern="$(echo "$line" | grep " " | cut -d " " -f2-)"
    channeldownload "$url" "$pattern" &
    sleep "0.1"
done

wait
exit 0
