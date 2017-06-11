#!/usr/bin/env python3

import subprocess
import time
import sys
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("--stream-catcher", help="program that catches the stream", default="streamlink")
parser.add_argument("--retry-sleep", type=int, help="sleep time before retry", default=120)
parser.add_argument("--fast-retry-sleep", type=int, help="retry sleep after a stream recording happened", default=10)
parser.add_argument("--fast-retries", type=int, help="retries done with a lower retry sleep after a stream recording happened", default=12)
parser.add_argument("--output-dir", help="download directory", default=".")
parser.add_argument("--stream-name", help="name of the stream", default="")
parser.add_argument("stream_url", help="stream to be cought")
args = parser.parse_args()

retrySleep = args.retry_sleep
fastRetrySleep = args.fast_retry_sleep
fastRetries = args.fast_retries
streamUrl = args.stream_url
outputDir = args.output_dir
streamCatcher = args.stream_catcher

if args.stream_name != "":
	outputName = args.stream_name
else:
	urlSplit = streamUrl.split("/")
	if urlSplit[-1] != "":
		outputName = urlSplit[-1]
	elif urlSplit[-2] != "":
		outputName = urlSplit[-2]
	else:
		outputName = ""

if streamUrl == "-":
	print("stream url required")
	sys.exit(1)


currentFastRetries = 2

while True:
	print("catching stream %s (%s)" % (streamUrl, outputName))
	start = time.time()
	status = subprocess.call([streamCatcher, "--default-stream", "best", "-o", "%s/%s-%s.mkv" % (outputDir, outputName, time.strftime("%d-%m-%Y_%H-%M-%S")), streamUrl])
	end = time.time()
	if (end - start) > 10:
		print("catching stream successful")
		currentFastRetries = fastRetries
	else:
		print("catching stream failed")

	if currentFastRetries > 0:
		print("waiting %i seconds to retry" % fastRetrySleep)
		currentFastRetries -= 1
		time.sleep(fastRetrySleep)
	else:
		print("waiting %i seconds to retry" % retrySleep)
		time.sleep(retrySleep)
