entrada = input().split()
n = int(entrada[0])
m = int(entrada[1])
s = ""

for i in range(n):
    s = list(input())

    for j in range(m):
        if s[j] == '.':
            if (i + j) % 2 == 1:
                s[j] = 'W'
            else:
                s[j] = 'B'

    s = "".join(s)      
    print(s)