def find_min(L):
	min = L[0]
		
	for x in L:
		if x < min:
			min = x
				
	return min
