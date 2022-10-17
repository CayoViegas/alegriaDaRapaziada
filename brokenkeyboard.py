def solve(s):
    ans = {'a':0, 'b':0, 'c':0, 'd':0, 'e':0, 'f':0, 'g':0, 
    'h':0, 'i':0, 'j':0, 'k':0, 'l':0, 'm':0, 'n':0, 'o':0, 
    'p':0, 'q':0, 'r':0, 's':0, 't':0, 'u':0, 'v':0, 'w':0, 
    'x':0, 'y':0, 'z':0}

    i = 0
    ans_index = 0
    retorno = []

    while(i < len(s)):
        if s[i] == s[ans_index]:
            ans[s[ans_index]] += 1
            i += 1
        else:
            if ans[s[ans_index]] % 2 == 1 and s[ans_index] not in retorno:
                retorno.append(s[ans_index])

            ans[s[ans_index]] = 0
            ans_index = i

    if ans[s[-1]] % 2 == 1 and s[-1] not in retorno:
        retorno.append(s[ans_index])

    retorno.sort()
    retorno = ''.join([ans for ans in retorno])

    print(retorno)

q = int(input())

while(q > 0):
    solve(str(input()))
    q -= 1