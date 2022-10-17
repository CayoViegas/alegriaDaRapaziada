while(True):
    print("celsius to fahrenheit [ 1 ]")
    print("fahrenheit to celsius [ 2 ]")
    print("exit [ enter ]")

    x = input("  ?  ")

    if(x == "1"):
        temp = float(input("Celsius: "))
        print(temp * (9/5) + 32)
    elif(x == "2"):
        temp = float(input("fahrenheit: "))
        print((temp - 32) / 5/9)
    
    else:
        break
    print("\n")
