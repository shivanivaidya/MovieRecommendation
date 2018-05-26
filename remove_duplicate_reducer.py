#!/usr/bin/env python

import sys

current_movID = ""

for line in sys.stdin:
    movID = line.strip()

    if current_movID != movID:
        if current_movID != "":
            print(("%s\tB") % (current_movID))
        current_movID = movID
print(("%s\tB") % (current_movID))

    
 
    
 
  
        
    

        
    
