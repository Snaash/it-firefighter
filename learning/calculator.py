operator = input("Do you want to add (+), multiply (*) or subtract (-): ")

# Converting inputs to float for more flexibility
number_1 = float(input("Your first number: "))
number_2 = float(input("Your second number: "))

# Testing the operator variable
if operator == "+":
    result = number_1 + number_2
elif operator == "-":
    result = number_1 - number_2
elif operator == "*":
    result = number_1 * number_2
else:
    result = "Unknown operator"

print(f"The result is: {result}")
