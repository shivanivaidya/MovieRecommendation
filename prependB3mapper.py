#!/usr/bin/env python
import sys

for line in sys.stdin:
    line = str(line)
    line = line.strip()
    splits = line.split('|')
    movID = splits[0]
    movName = splits[1]
    print(('%s\tB\t%s') % (movID, movName))
