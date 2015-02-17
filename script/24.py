from random import random

number = lambda: int(random() * 10) + 1
def numbers():
	n = []
	n.append(number())
	n.append(number())
	n.append(number())
	n.append(number())
	return n
def numbers():
	return [input(), input(), input(), input()]

ops = ["+", "-", "*", "/"]

def loop():	
	n = numbers()

	for i in ops:
		for j in ops:
			for k in ops:
				try:
					result = eval(str(n[0]) + i + str(n[1]) + j + str(n[2]) + k + str(n[3]))
				except ZeroDivisionError as e:
					pass
				if result == 24:
					print(str(n[0]) + i + str(n[1]) + j + str(n[2]) + k + str(n[3]))
					return

	print( "not possible" )

while True:
	loop()