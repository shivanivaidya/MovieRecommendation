#!/usr/bin/env python
import sys

for line in sys.stdin:
    line = str(line)
    line = line.strip()
    splits = line.split('\t')
    if(len(splits) != 1):
        userID = splits[0]
        rmse = float(splits[1])

        if(rmse == 0.000000):
            print ('%s\tA' % (userID))

            
