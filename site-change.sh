#!/usr/bin/env bash

threshold="20"
period="120"
keepimages="10"
IMAGEDIR="$(mktemp -d)"
URL="$1"
RESOLUTION="1024x768"

cleanup () {
	if [ -d "$IMAGEDIR" ] ; then
		rm -rf "$IMAGEDIR"
	fi
	exit
}

compare_images () {
	compare -metric phash "$1" "$2" null: 2>&1 | cut -d "." -f1
}

download_image () {
	docker run --shm-size 1G \
			--rm \
			-v "$IMAGEDIR:/screenshots" \
			alekzonder/puppeteer:latest \
			screenshot_series "$URL" "$RESOLUTION" > /dev/null
}

trigger () {
	# Insert the required trigger here
	echo "trigger imagediff: $imagediff"
}

requirements () {
	if [ -z "$(which compare)" ] ; then
		echo "imagemagick is required for comparing images" >&2
		cleanup
	fi

	if [ -z "$(which docker)" ] ; then
		echo "docker is required for creating screenshots" >&2
		cleanup
	fi
}

trap 'cleanup' INT TERM
requirements
chmod 777 "$IMAGEDIR"
download_image
sleep "$period"

while true ; do
	download_image
	imagediff="$(compare_images $(ls -1t -- *.png | head -2))"
	if [ "$imagediff" -gt "$threshold" ] ; then
		trigger "$imagediff"
	fi
	rm -f $(ls -1t "$IMAGEDIR"/*.png | tail -n "+$keepimages")
	sleep "$period"
done
