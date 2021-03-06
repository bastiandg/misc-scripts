#!/usr/bin/env bash

TESSERACTIMAGE="tesseractshadow/tesseract4re"
RAWEXTENSION="jpg"
INPUTDIR="/input"
OUTPUTDIR="/output"
OUTPUTPREFIX="dokument"
SCANLANG="deu"
GRACEPERIOD="60"

mkdir -p "$INPUTDIR/"
mkdir -p "$OUTPUTDIR/"
cd "$INPUTDIR"

while true ; do 
	inotifywait -e close_write .
	echo "Waiting for files."
	sleep "$GRACEPERIOD"
	ls -1 -- *."$RAWEXTENSION" > rawfiles
	output_filename="$OUTPUTPREFIX$(date "+%Y-%m-%d_%H-%M")"
	docker run --rm -v "$(pwd):/home/work" "$TESSERACTIMAGE" \
		tesseract rawfiles \
		"$output_filename" \
		-l "$SCANLANG" \
		pdf
	mv "${output_filename}.pdf" "$OUTPUTDIR/"
	chmod 777 "${OUTPUTDIR}/${output_filename}.pdf"
	rm -f -- *
done
