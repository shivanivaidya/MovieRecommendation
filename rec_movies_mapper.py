#!/usr/bin/env python
import sys

userID = ""

for line in sys.stdin:
    line = str(line)
    line = line.strip()
    splits = line.split("\t")

    if(len(splits) != 1):
        if(splits[1] == 'A'):
            userID = splits[0]
        else:
            if(splits[0] == userID):
                movID = splits[2]
                rating = splits[3]
                if(rating == '5'):
                    print(("%s") % (movID))
            
        
        
