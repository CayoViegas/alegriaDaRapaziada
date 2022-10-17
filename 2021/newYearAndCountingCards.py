x=input()
cont=0
for e in x:
    if e in "aeiou" or e in "02468":
        cont+=1


print(cont)