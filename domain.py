#!/usr/bin/python

import string
import random
import subprocess
import time

alphabet = string.ascii_lowercase + string.digits
length = 3
testsPerTld = 10
queryDelay = 1
tlds = ["be", "de", "at", "eu"]

def whois(domain):
	output = subprocess.check_output("whois " + domain + " ; exit 0", stderr=subprocess.STDOUT, shell=True)
	# print output
	if      output.find("nothing found") != -1 or \
		output.find("Status: free") != -1 or \
		output.find("Status: AVAILABLE") != -1 or \
		output.find("Status:	AVAILABLE") != -1:
		return True
	else:
		return False


for tld in tlds:
	for i in range(testsPerTld):
		domain = "".join([alphabet[random.randint(0, len(alphabet) - 1)] for j in range(length)]) + "." + tld
		if whois(domain):
			print domain
		time.sleep(queryDelay)

