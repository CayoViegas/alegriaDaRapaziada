import math

def init_table(arr):
    n = len(arr)
    k = int(math.log(n, 2)) + 1
    sparse_table = [[-1] * k for i in range(n)] 

    for i in range(0, n):
        sparse_table[i][0] = arr[i]
     
    j = 1
    while (1 << j) <= n:
        i = 0
        while (i + (1 << j) - 1) < n:
            if (sparse_table[i][j - 1] < sparse_table[i + (1 << (j - 1))][j - 1]):
                sparse_table[i][j] = sparse_table[i][j - 1]
            else:
                sparse_table[i][j] = sparse_table[i + (1 << (j - 1))][j - 1]
             
            i += 1
        j += 1
    
    return sparse_table

def rmq(table, l, r):
    m = r - l + 1
    k = int(math.log(m, 2))
    return min(table[l][k], table[l + m - (1 << k)][k])

n = int(input())
arr = list(map(lambda x : int(x), input().split()))
table = init_table(arr)
for i in range(int(input())):
    l, r = list(map(lambda x : int(x), input().split()))
    if (l > r):
        l, r = r, l
    print(rmq(table, l, r))

