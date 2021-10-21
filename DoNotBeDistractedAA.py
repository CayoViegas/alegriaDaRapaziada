for _ in range(int(input())):
	l=[0]*26
	n=int(input())
	s=input()
	prev='a'
    t=0
	for i in s:
		x=ord(i)-ord('A')
		if prev!=i and l[x]:
				t=1
				break
		else:
			l[x]=1
			prev=i
	print('NO') if t else print('YES')
	