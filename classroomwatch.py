from unittest import result


def s(n):
    k = 0

    for i in n:
        k += int(i)

    return(k)

result = []
n = input()
r = max(0, int(n) - 100)

for i in range(r, int(n)):
    if i + s(str(i)) == int(n):
        result.append(i)

print(len(result))

for i in result:
    print(i)