#!/usr/bin/env python
import sys

movID = ""

for line in sys.stdin:
    line = str(line)
    line = line.strip()
    splits = line.split("\t")

    if(len(splits) != 1):
        if(splits[1] == 'A'):
            movID = splits[0]
        else:
            if(splits[0] == movID):
                userID = splits[2]
                rating = splits[3]
                print(("%s\tB\t%s\t%s") % (movID, userID, rating))
            
        
        
