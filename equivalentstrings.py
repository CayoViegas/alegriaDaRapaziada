def div(s):
    lenght = len(s)
    if (lenght % 2 == 1):
        return s
    
    s1 = div(s[0:int(lenght/2)])
    s2 = div(s[int(lenght/2):lenght])
    if s1 < s2:
        return s1 + s2 
    else:
        return s2 + s1
 
 
s1 = input()
s2 = input()
 
print('YES') if div(s1) == div(s2) else print('NO')