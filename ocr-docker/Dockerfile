FROM alpine:3

RUN apk add --no-cache \
			tesseract-ocr \
			tesseract-ocr-data-deu \
			inotify-tools

COPY ocr.sh /ocr.sh

ENTRYPOINT ["/ocr.sh"]
