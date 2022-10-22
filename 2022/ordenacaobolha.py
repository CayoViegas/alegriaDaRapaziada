def bolha(arr):
  for i in range(len(arr)):
    for j in range(len(arr) - 1):
      if arr[j] > arr[j + 1]:
          arr[j], arr[j + 1] = arr[j + 1], arr[j]

  return arr

def main():
  arr = [5, 4, 3, 2, 1]
  print(bolha(arr))

if __name__ == "__main__":
  main()