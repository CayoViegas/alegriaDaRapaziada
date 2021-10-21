n, k = input().split()
n = int(n)
k = int(k)
a = input().split()
a = [int(x) for x in a]
a1 = 0
for i in range(n):
    if a[i]==1:
        a1+=1
for i in range(k):
    t, x = input().split()
    t = int(t)
    x = int(x)
    if t == 1:
        if a[x-1] == 1:
            a[x-1] = 0
            a1-=1
        else:
            a[x-1] = 1
            a1+=1
    else:
        if a1 >= x:
            print(1)  
        else: 
            print(0)