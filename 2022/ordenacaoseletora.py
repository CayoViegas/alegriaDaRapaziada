def selectiona(lista):
  for i in range(len(lista)):
    min = i
    for j in range(i + 1, len(lista)):
      if lista[min] > lista[j]:
        min = j
    lista[i], lista[min] = lista[min], lista[i]
  
  return lista

def main():
  arr = [5, 4, 3, 2, 1]
  print(selectiona(arr))

if __name__ == "__main__":
  main()