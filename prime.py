def primes_sieve(limit):
    limitn = limit+1
    not_prime = [False] * limitn
    primes = []
 
    for i in range(2, limitn):
        if not_prime[i]:
            continue
        for f in xrange(i*2, limitn, i):
            not_prime[f] = True
    not_prime[1] = True
    return not_prime
b =  primes_sieve(1000000)
 
n = int(raw_input())
 
x = map(int,raw_input().split())
for i in x:
    raiz = int(i**0.5)
 
    if b[raiz] == False and raiz*raiz == i:
        print "YES"
    else:
        print "NO"