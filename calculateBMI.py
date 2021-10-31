print("CALCULATE YOUR BMI!\n")

w = float(input("Enter your Weight: "))
h = float(input("Enter your height: "))

BMI = w * (h * h)

print("your BMI %.0f" % BMI)


print("-------------------")
print("18.5 < BMI: under Weight")
print("18.5 > BMI < 24.9: normal Weight")
print("25.0 > BMI < 29.9: over Weight")
print("30.0 > BMI < 34.9: obese I")
print("35.0 > BMI < 39.9: obese II")
print("40.0 > BMI: obese III")
