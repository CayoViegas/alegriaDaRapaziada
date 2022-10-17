n = 2
s = 'hello'

def print_n(s, n):
    if n <= 0:
        return
    print(s)
    print_n(s, n-1)

def do_n(n):
    for i in range(n):
        print_n('help', 2)

do_n(2**3)