t_ = int(input())

while t_ > 0:
    s = list(input())
    t = input()
    retorno = []

    s.sort()

    cnt = 26 * [0]

    for c in s:
        cnt[ord(c) - ord('a')] += 1

    if (t != "abc") or (cnt[0] == 0) or (cnt[1] == 0) or (cnt[2] == 0):
        t_ -= 1
        print("".join(s))
    else:
        while cnt[0] > 0:
            retorno.append('a')
            cnt[0] -= 1
        
        while cnt[2] > 0:
            retorno.append('c')
            cnt[2] -= 1

        while cnt[1] > 0:
            retorno.append('b')
            cnt[1] -= 1

        for i in range(3, 26):
            while(cnt[i] > 0):
                retorno.append(chr(ord('a') + i))
                cnt[i] -= 1

        t_ -= 1
        print("".join(retorno), "\n")