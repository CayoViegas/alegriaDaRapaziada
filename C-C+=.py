
e=int(input())
for i in range(e):
	e2=input().split()
	a=int(e2[0])
	b=int(e2[1])
	n=int(e2[2])
	k=0
	while max(a, b)<=n:
		a, b=max(a, b), min(a, b)
		b+=a
		k+=1
	print(k)