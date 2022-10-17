n = int(input())
while n != 0:
	
	origin_x, origin_y = map(int, input().split())
	for i in range(n):
		x, y = map(int, input().split())
		if x == origin_x or y == origin_y:
			print("divisa")
		
		elif x > origin_x and y > origin_y:
			print("NE")
		
		elif x > origin_x and y < origin_y:
			print("SE")
		
		elif x < origin_x and y > origin_y:
			print("NO")
		
		else:
			print("SO")
	
	n = int(input())
