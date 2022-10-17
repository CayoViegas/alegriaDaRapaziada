    #aceita ai pcr, na humildade.
    a = raw_input()
    b = raw_input()
    c1 = [0] * (len(b)+1)
    c2 = [0] * (len(b)+1)
    for i in xrange(1, len(b)+1):
    	if b[i-1] == "1":
    		c1[i] = c1[i-1] + 1
    		c2[i] = c2[i-1]
    	else:
    		c2[i] = c2[i-1] + 1
    		c1[i] = c1[i-1]	
     
    k = 0
    for i in xrange(len(a)):
    	k += abs(int(a[i])-1) * (int(c1[len(b) - len(a) + 1 + i]) - int(c1[i]))
    	k += abs(int(a[i])-0) * (int(c2[len(b) - len(a) + 1 + i]) - int(c2[i]))
    print k
