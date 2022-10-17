n = int(input())
a = list(map(int,input().split()))
res = [0] + [-1] * (n-1)
idx = [0]
for u in idx:
    for v in [u-1, u+1, a[u]-1]:
        if v >= 0 and v < n and res[v] == -1:
            res[v] = res[u] + 1
            idx.append(v)
print(*res)