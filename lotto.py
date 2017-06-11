#!/usr/bin/env python3

import random

numbers = list(range(1, 50))
random.shuffle(numbers)

for i in range(4):
    s = ""
    for n in sorted(numbers[i * 6:i * 6 + 6]):
        s += "%02i " % n
    print(s)

