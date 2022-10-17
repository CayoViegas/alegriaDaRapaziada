import sys
input = lambda: sys.stdin.readline().rstrip()
 
N, M, K = map(int, input().split())
if K % 2:
    for _ in range(N):
        print(*[-1] * M)
    exit()
A = [[int(a) for a in input().split()] for _ in range(N)]
B = [[int(a) for a in input().split()] for _ in range(N-1)]
X = [[0] * M for _ in range(N)]
inf = 1 << 30
for k in range(1, K // 2 + 1):
    nX = [[inf] * M for _ in range(N)]
    for i in range(N):
        for j in range(M):
            if i: nX[i][j] = min(nX[i][j], X[i-1][j] + B[i-1][j])
            if i < N - 1: nX[i][j] = min(nX[i][j], X[i+1][j] + B[i][j])
            if j: nX[i][j] = min(nX[i][j], X[i][j-1] + A[i][j-1])
            if j < M - 1: nX[i][j] = min(nX[i][j], X[i][j+1] + A[i][j])
    X = nX
for x in X:
    print(*[a * 2 for a in x])