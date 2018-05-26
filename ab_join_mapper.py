#!/usr/bin/env python
import sys

movID = ""
orig_rating = ""

for line in sys.stdin:
    line = str(line)
    line = line.strip()
    splits = line.split("\t")

    if(len(splits) != 1):
        if(splits[1] == 'A'):
            movID = splits[0]
            orig_rating = splits[2]
        else:
            if(splits[0] == movID):
                userID = splits[2]
                rating = splits[3]
                if(rating == orig_rating):
                    print(("%s\tA") % (userID))
            
        
        
