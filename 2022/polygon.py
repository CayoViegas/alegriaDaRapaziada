
t=int(input())
while t:
	n=int(input())
	matrix=[]
	for i in range(n):
		c=input()
		matrix.append(c)
		
	flag=1
	for i in range(n-1):
		for j in range(n-1):
			if matrix[i][j]=='1' and matrix[i][j+1]=='0' and matrix[i+1][j]=='0':
				flag=0
				break
	if flag==1:
		print("YES")
	else:
		print("NO")
 
	t-=1