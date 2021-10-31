#!/bin/python3

import math
import os
import random
import re
import sys



#
# Complete the 'maxPresentations' function below.
#
# The function is expected to return an INTEGER.
# The function accepts following parameters:
#  1. INTEGER_ARRAY scheduleStart
#  2. INTEGER_ARRAY scheduleEnd
#


def maxPresentations(scheduleStart, scheduleEnd):
    temp = []
    for i in range(len(scheduleEnd)):
        temp.append([scheduleStart[i], scheduleEnd[i], i])
    ans = []
    
    temp.sort(key = lambda x: x[1])
 
    ans.append(temp[0][2])

    time_limit = temp[0][1]

    for i in range(1, len(scheduleEnd)):
        if temp[i][0] >= time_limit:
            ans.append(temp[i][2])
            time_limit = temp[i][1]
    # print(ans)
    # print(len(ans))
    return len(ans)

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    scheduleStart_count = int(input().strip())

    scheduleStart = []

    for _ in range(scheduleStart_count):
        scheduleStart_item = int(input().strip())
        scheduleStart.append(scheduleStart_item)

    scheduleEnd_count = int(input().strip())

    scheduleEnd = []

    for _ in range(scheduleEnd_count):
        scheduleEnd_item = int(input().strip())
        scheduleEnd.append(scheduleEnd_item)

    result = maxPresentations(scheduleStart, scheduleEnd)
    print(result)
    fptr.write(str(result) + '\n')

    fptr.close()
