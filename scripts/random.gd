extends Node

func randi(minimum=0,maximum=100):
	if maximum-minimum >= 0:
		return randi() % (int(maximum)-int(minimum)) + minimum
	else:
		print("WARNING in Random, randi: max - min = ", maximum - minimum, " < 0.")
		return minimum

func randf(minimum=0.0, maximum=1.0):
	if maximum-minimum >= 0:
		return randf() * (maximum-minimum) + minimum
	else:
		print("WARNING in Random, randf: max - min = ", maximum - minimum, " < 0.")
		return minimum
