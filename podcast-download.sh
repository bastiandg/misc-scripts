#!/usr/bin/env bash

DOWNLOADDIRECTORY="/path/to/download/podcast"
CHANNELLIST="/path/to/podcast-list"

YOUTUBEDL="/usr/local/bin/youtube-dl"
MAXDOWNLOAD="10"
DATEAFTER="now-1month"
FORMAT="bestaudio"
THREADS=5


IFS=$'\n'

download () {
    "$YOUTUBEDL" --playlist-end "$MAXDOWNLOAD" \
                 --download-archive "$DOWNLOADDIRECTORY/archive-list" \
                 --dateafter "$DATEAFTER" \
                 --continue \
                 --no-overwrites \
                 --ignore-errors \
                 --format "$FORMAT" \
                 --match-title "$2" \
                 --output "$3/%(upload_date)s-%(title)s-%(id)s.%(ext)s" "$1"
}

title () {
    curl -s -L "$1" | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");sub(/%/,"Percent");print;exit}'
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
    
    download "$url" "$pattern" "$DOWNLOADDIRECTORY/$(title "$url")" &
    sleep "0.1"
done

wait
exit 0
