#!/bin/python3

import math
import os
import random
import re
import sys



#
# Complete the 'countDuplicate' function below.
#
# The function is expected to return an INTEGER.
# The function accepts INTEGER_ARRAY numbers as parameter.
#

def countDuplicate(numbers):
    duplicates = set()
    for i in range(len(numbers)):
        for x in range(i+1, len(numbers), 1):
            # print(str(i) + " "  + str(x) + " ")
            if(numbers[i] == numbers[x]):
                print(numbers[i])
                duplicates.add(numbers[i])
                break
    print(len(duplicates))

if __name__ == '__main__':
    # fptr = open(os.environ['OUTPUT_PATH'], 'w')

    numbers_count = int(input().strip())

    numbers = []

    for _ in range(numbers_count):
        numbers_item = int(input().strip())
        numbers.append(numbers_item)

    result = countDuplicate(numbers)

    # fptr.write(str(result) + '\n')

    # fptr.close()
