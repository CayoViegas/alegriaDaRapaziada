import string
a = input()
if len(a) == 0:
    print(0)
dp = [0] * 100000
s = 1 if a[0] not in string.ascii_uppercase else 0
for i in range(1, len(a)):
    dp[i] = (dp[i - 1] if a[i] in string.ascii_lowercase else min(1 + dp[i - 1], s))
    s += 1 if a[i] not in string.ascii_uppercase else 0
print(dp[len(a) - 1])