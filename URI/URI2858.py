from sys import stdin
def BS(lista, l, r, element):

    m = int((l + r) / 2)
    if int(lista[m]) == int(element):
        return m
    
    elif int(lista[m]) > int(element):
        return BS(lista, l, m -1, element)

    else:
        return BS(lista, m+1, r, element)

MAX = 305000

while True:
    try:
        n = int(input())
        e = stdin.readline()
        k = int(input())
        lista = e.split()
        index = BS( lista, 0, n-1, k) + 1
        eliminado = False
        passo = 2
        
        while index >= passo and not eliminado:

            if (index % passo == 0):
                eliminado = True

            else:
                index = index - (index / passo)
                passo += 1

        if eliminado:
            print("N")
        
        else:
            print ("Y")
    
    except EOFError: break