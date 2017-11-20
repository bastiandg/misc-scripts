#!/usr/bin/env bash

DOWNLOADDIRECTORY="/path/to/download/youtube"
CHANNELLIST="/path/to/channel-list"

YOUTUBEDL="/usr/local/bin/youtube-dl"
MAXDOWNLOAD="10"
DATEAFTER="now-1month"
FORMAT="bestvideo+bestaudio"
THREADS=5

channeldownload () {
    "$YOUTUBEDL" --playlist-end "$MAXDOWNLOAD" \
                 --download-archive "$DOWNLOADDIRECTORY/archive-list" \
                 --dateafter "$DATEAFTER" \
                 --continue \
                 --no-overwrites \
                 --ignore-errors \
                 --format "$FORMAT" \
                 --output "$DOWNLOADDIRECTORY/%(uploader)s/%(upload_date)s-%(title)s-%(id)s.%(ext)s" "$1"
}

if [ ! -f "$CHANNELLIST" ] ; then
    echo "channel-list missing" >&2
    exit 1
fi

for CHANNEL in $(cat $CHANNELLIST) ; do
    while [ "$(jobs | wc -l)" -ge "$THREADS" ] ; do
        sleep 1
    done
    channeldownload "$CHANNEL" &
    sleep "0.1"
done

wait
exit 0
