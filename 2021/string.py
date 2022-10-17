#!/bin/python3

import math
import os
import random
import re
import sys



#
# Complete the 'getShiftedString' function below.
#
# The function is expected to return a STRING.
# The function accepts following parameters:
#  1. STRING s
#  2. INTEGER leftShifts
#  3. INTEGER rightShifts
#

def getShiftedString(s, leftShifts, rightShifts):
    leftShifts = leftShifts%len(s)
    rightShifts = rightShifts%len(s)

    s = s[leftShifts:] + s[0:leftShifts]
    s = s[len(s) - rightShifts:] + s[0:len(s) - rightShifts]

    print(s)
    return s

if __name__ == '__main__':
    # fptr = open(os.environ['OUTPUT_PATH'], 'w')

    s = input()

    leftShifts = int(input().strip())

    rightShifts = int(input().strip())

    result = getShiftedString(s, leftShifts, rightShifts)

    # fptr.write(result + '\n')

    # fptr.close()
