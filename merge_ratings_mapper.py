#!/usr/bin/env python
import sys

movID = ""
original_rating = ""

for line in sys.stdin:
    line = str(line)
    line = line.strip()
    splits = line.split("\t")

    if(len(splits) != 1):
        if(splits[1] == 'A'):
            movID = splits[0]
            original_rating = splits[2]
        else:
            if(splits[0] == movID):
                userID = splits[2]
                rating = splits[3]
                print(("%s\t%s\t%s\t%s") % (userID, movID, rating, original_rating))
            
        
        
