#!/usr/bin/env python
import sys

for line in sys.stdin:
    (userID, movieID, rating, timestamp) = line.split('\t')
    print ('%s\tB\t%s\t%s' % (userID, movieID, rating))
