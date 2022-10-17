operacao = input()

ordem = 12

matriz = []
for i in range(ordem):
    matriz.append([])

contador = 0
for i in range(ordem):
    for j in range(ordem):
        elemento = float(input())  
        matriz[i].append(elemento)

soma = 0
contador = 0
for i in range(len(matriz)):
    for j in range(len(matriz[0])):
        if i > j:
            soma += matriz[i][j]
            contador += 1
            if operacao == 'S':
                resultado = soma
            else:
                resultado = soma / contador

print(f'{resultado:.1f}') 