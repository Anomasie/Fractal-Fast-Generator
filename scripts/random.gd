extends Node

func randi(min=0,max=100):
	if max-min >= 0:
		return randi() % (int(max)-int(min)) + min
	else:
		print("WARNING in Random, randi: max - min = ", max - min, " < 0.")
		return min

func randf(min=0.0, max=1.0):
	if max-min >= 0:
		return randf() * (max-min) + min
	else:
		print("WARNING in Random, randf: max - min = ", max - min, " < 0.")
		return min
