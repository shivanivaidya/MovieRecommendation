#!/usr/bin/env python

import sys

for line in sys.stdin:
    line = line.strip()
    (userID, movID, rating, orig_rating) = line.split('\t')

    difference = int(rating) - int(orig_rating) 
 
    print('%s\t%s\t%d' % (userID, movID, (difference * difference)))            
    
 
  
        
    

        
    
