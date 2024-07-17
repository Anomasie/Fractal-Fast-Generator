extends VBoxContainer

var data = ""
var file_counter = 0

func _ready():
	$FileDialog.hide()

func empty_image(color=0.0, size=Global.image_size):
	var matrix = []
	matrix.resize(size)
	for row in len(matrix):
		var array = []
		array.resize(size)
		array.fill(color)
		matrix[row] = array
	return matrix

func points_to_image(ifs, points):
	var image = empty_image(ifs.background_color)
	if randf() <= Global.p_centered:
		print("centered")
		# center image
		## get origins
		var rect = Rect2(Vector2i(0,0), Vector2i(0,0))
		if len(points) > 0:
			rect = Rect2(points[0].position, Vector2i(0,0))
		for entry in points:
			rect = rect.expand(entry.position)
		# set current_origin and current_size
		## get length
		var length = max(rect.size.x, rect.size.y)
		# set origin
		## shift origin such that boundaries are left and right
		## shift origin such that fractal is centered
		var current_origin = rect.position - Vector2(1,1) * length / 10 / 2 - Vector2(
			length - rect.size.x,
			length - rect.size.y
		) / 2
		var current_size = length * 1.1
		
		# draw
		for entry in points:
			@warning_ignore("narrowing_conversion")
			var real_position = Vector2i(
				# doesn't work anymore :(
				#remap(entry.position.x, current_origin.x, current_size, 0, image_size.x),
				#remap(entry.position.y, current_origin.y, current_size, 0, image_size.y)
				(entry.position.x - current_origin.x) / current_size * len(image),
				(entry.position.y - current_origin.y) / current_size * len(image)
			)
			if real_position.x >= 0 and real_position.x < len(image):
				if real_position.y >= 0 and real_position.y < len(image):
					image[real_position.x][real_position.y] = entry.color
	else:
		print("not centered")
		for entry in points:
			var real_position = Vector2i(
				entry.position.x * len(image),
				entry.position.y * len(image)
			)
			if real_position.x >= 0 and real_position.x < len(image):
				if real_position.y >= 0 and real_position.y < len(image):
					image[real_position.x][real_position.y] = entry.color
		image[5][len(image)-1] = 0.5
	return image

func image_to_string(image):
	var strings = []
	for x in len(image):
		strings.append(",".join(image[x]))
	return ",".join(strings)

func generate_fractal():
	var ifs = IFS.random_ifs()
	var results = ifs.calculate_fractal(point.new(), Global.points)
	return points_to_image(ifs, results)

func _on_button_pressed():
	# set seed
	seed(Global.random_seed)
	for _i in Global.sample_size:
		print(_i)
		data += image_to_string(generate_fractal()) + "\n"
		print()
	save()

# saving

func save():
	$FileDialog.show()

func save_local(path):
	# save image
	if not path.ends_with(".csv"):
		path += ".csv"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data)
	file.close()

func _on_file_dialog_file_selected(path):
	save_local(path)
