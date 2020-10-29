def problem():
    t = int(raw_input())
    answer = ""
    for i in xrange(t):
          answer = answer + str(solve()) + "\n"

    return answer

def solve():
    x1, y1, x2, y2 = map(int,raw_input().split())
    returnable = 0
    if x1 == x2:
        returnable = abs(y1 - y2)
    elif y1 == y2:
        returnable = abs(x1 - x2)
    else:
        returnable = abs(x1 - x2) + abs(y1 - y2) + 2

    return returnable


a = problem()
print a
