#!/usr/bin/env python

import sys
import math

current_userID = ''
current_sum = 0.0
n = 0

for line in sys.stdin:
    line = str(line)
    line = line.strip()
    splits = line.split('\t')

    if(len(splits) != 1):
        userID = splits[0]
        movID = splits[1]
        diff_squared = float(splits[2])
    
        if current_userID != userID:
            if current_userID != '':
                rmse = math.sqrt(current_sum / n)
                print('%s\t%f' % (current_userID, rmse))
            current_userID = userID
            current_sum = 0
            n = 0
        n += 1
        current_sum += diff_squared

rmse = math.sqrt(current_sum / n)
print('%s\t%f' % (current_userID, rmse))  
        
    

        
    
