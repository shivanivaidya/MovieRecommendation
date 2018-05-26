#!/usr/bin/env python
import sys

for line in sys.stdin:
    line = str(line)
    line = line.strip()
    (movieID, rating) = line.split('\t')
    print ('%s\tA\t%s' % (movieID, rating))
