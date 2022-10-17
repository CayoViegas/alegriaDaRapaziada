#!/bin/python3

import math
import os
import random
import re
import sys


#
# Complete the 'fourthBit' function below.
#
# The function is expected to return an INTEGER.
# The function accepts INTEGER number as parameter.
#

def fourthBit(number):
    maxint = 2147483648
    
    while maxint > number:
        maxint = maxint/2
    
    int_sum = 0
    least = 0
    
    while maxint >= 1:
        added = False
        if int_sum + maxint <= number:
            int_sum += maxint
            print(maxint)
            added = True
            
        if int(maxint) == 8:
            if added:
                least = 1
            else:
                least = 0
                
        maxint = maxint/2
    return least
            
