#!/usr/bin/env bash

DOWNLOADDIRECTORY="/path/to/download/podcast"
CHANNELLIST="/path/to/podcast-list"

YOUTUBEDL="/usr/local/bin/youtube-dl"
MAXDOWNLOAD="10"
DATEAFTER="now-1month"
FORMAT="bestaudio"
THREADS=5

IFS=$'\n'

download() {
  if [[ "$4" == "true" ]]; then
    ARCHIVE_PARAM=()
  else
    ARCHIVE_PARAM=(--download-archive "$DOWNLOADDIRECTORY/archive-list")
  fi
  "$YOUTUBEDL" --playlist-end "$MAXDOWNLOAD" \
    --dateafter "$DATEAFTER" \
    --continue \
    --no-overwrites \
    --ignore-errors \
    "${ARCHIVE_PARAM[@]}" \
    --format "$FORMAT" \
    --match-title "$2" \
    --output "$3/%(upload_date)s-%(title)s-%(id)s.%(ext)s" "$1"
}

title() {
  curl -s -L "$1" | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");gsub(/%/,"Percent");gsub(/<!\[CDATA\[|>|]/,"");print;exit}'
}

if [ ! -f "$CHANNELLIST" ]; then
  echo "channel-list missing" >&2
  exit 1
fi

for line in $(grep -v "^#" "$CHANNELLIST"); do
  while [ "$(jobs | wc -l)" -ge "$THREADS" ]; do
    sleep 1
  done
  url="$(echo "$line" | cut -d " " -f1)"
  pattern="$(echo "$line" | grep " " | cut -d " " -f2-)"

  # Workaround for a podcast always using the same file name
  # TODO make this configurable
  if grep -q "9YNI3WaL" <<<"$url"; then
    NODOWNLOADARCHIVE=true
  else
    NODOWNLOADARCHIVE=false
  fi

  download "$url" "$pattern" "$DOWNLOADDIRECTORY/$(title "$url")" "$NODOWNLOADARCHIVE" &
  sleep "0.1"
done

wait
exit 0
