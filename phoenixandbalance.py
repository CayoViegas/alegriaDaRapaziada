def s():
    n = int(input())
    soma1 = 2 ** n
    soma2 = 0

    for i in range(1, n // 2):
        soma1 += 2 ** i

    for i in range(n // 2, n):
        soma2 += 2 ** i

    print(soma1 - soma2)

t_ = int(input())

while t_ > 0:
    s()
    t_ -= 1