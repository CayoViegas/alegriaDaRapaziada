def funcao(s, leftShift, rightShift):
    finalString = ""
    for i in range(len(s)):
        print(s[(i+leftShift) % len(s)], leftShift, i-leftShift)
        finalString = finalString + s[(i+leftShift) % len(s)]
    # finalString = finalString[::-1]
    # finalString.join("")
    print(finalString)
    result = ""
    for i in range(len(s)):
        index = (i - rightShift)
        print(finalString[index], index, i + rightShift)
        result = result + finalString[index]

    print (result)

funcao("abcdef",2,4)