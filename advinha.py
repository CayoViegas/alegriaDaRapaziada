import random
print("Tente adivinhar o numero entre 1 e 100")
x = random.randint(1,100)

while(True):
    valor = int(input("Informe um valor: "))
    
    if(x == valor):
        print("Isso ae!!!")
        break
    
    if(x < valor):
        print("Voce informou um numero maior")
    elif(x > valor):
        print("Voce informou um numero menor")
