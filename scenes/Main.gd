extends VBoxContainer

var data = ""
var meta_data = ""
var file_counter = 0

var calculating = false
var sample_counter = 1

@onready var Progress = $Progress/MarginContainer/VBoxContainer/ProgressBar
@onready var StopButton = $Progress/MarginContainer/VBoxContainer/StopButton
@onready var StartButton = $Progress/MarginContainer/VBoxContainer/StartButton

func _ready():
	$FileDialog.hide()
	StopButton.hide()
	StartButton.hide()

func _process(_delta):
	if calculating and sample_counter <= Global.sample_size:
		var ifs = IFS.random_ifs()
		data += image_to_string(generate_image(ifs)) + "\n"
		meta_data += meta_data_to_string(ifs) + "\n"
		sample_counter += 1
		Progress.value = float(sample_counter) / Global.sample_size * 100
	elif calculating:
		StopButton.hide()
		StartButton.hide()
		calculating = false
		Progress.value = 0
		save()

func empty_image(color=0.0, image_size=Global.image_size):
	var matrix = []
	matrix.resize(image_size)
	for row in len(matrix):
		var array = []
		array.resize(image_size)
		array.fill(color)
		matrix[row] = array
	return matrix

func points_to_image_centered(ifs, points):
	var image = empty_image(ifs.background_color)
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
	return image

func points_to_image_original(ifs, points):
	var image = empty_image(ifs.background_color)
	var counter = 0
	for entry in points:
		var real_position = Vector2i(
			entry.position.x * len(image),
			entry.position.y * len(image)
		)
		if real_position.x >= 0 and real_position.x < len(image):
			if real_position.y >= 0 and real_position.y < len(image):
				# new point drawn?
				if image[real_position.x][real_position.y] != ifs.background_color:
					counter += 1
				# draw
				image[real_position.x][real_position.y] = entry.color
	# the less points are drawn, the more likely is it to draw 
	if Global.prefer_nonempty_pictures and counter < float(Global.points)/2 and randf()*2 > float(counter) / Global.points:
		return points_to_image_centered(ifs, points)
	else:
		return image

func points_to_image(ifs, points):
	if randf() <= Global.p_centered:
		return points_to_image_centered(ifs, points)
	else:
		return points_to_image_original(ifs, points)

func generate_image(ifs):
	var results = []
	# check if frame_limit is on
	## if so: get a frame_limit and only calculate that many points at once
	if Global.frame_limit_on:
		var frame_limit = Random.randi(Global.frame_limit_min, Global.frame_limit_max)
		while len(results) < Global.points:
			results += ifs.calculate_fractal(point.new(), min(
				Global.points - len(results),
				frame_limit))
	# else: just calculate all of them in one rush
	else:
		results = ifs.calculate_fractal(point.new(), Global.points)
	return points_to_image(ifs, results)

func image_to_string(image):
	var strings = []
	for x in len(image):
		strings.append(",".join(image[x]))
	return ",".join(strings)

func meta_data_to_string(ifs):
	# version
	var string = "v1"
	# background color
	string += "," + str(ifs.background_color)
	# delay
	string += "," + str(ifs.delay)
	# ifs data
	for contraction in ifs.systems:
		string += ","
		string += str(contraction.translation.x) + "," + str(contraction.translation.y) + ","
		string += str(contraction.contract.x) + "," + str(contraction.contract.y) + ","
		string += str(contraction.rotation) + ","
		string += str(int(contraction.mirrored)) + ","
		string += str(contraction.color)
	return string

func _on_button_pressed():
	# set seed
	seed(Global.random_seed)
	data = ""
	meta_data = ""
	sample_counter = 1
	calculating = true
	StopButton.show()
	StartButton.hide()

# saving

func save():
	$FileDialog.show()

func save_local(path):
	# save image
	if not path.ends_with(".csv"):
		path += ".csv"
	var file = FileAccess.open(
		path,
		FileAccess.WRITE)
	file.store_string(data)
	file.close()
	var meta_file = FileAccess.open(
		path.left(path.length()-4)+"_meta.csv",
		FileAccess.WRITE)
	meta_file.store_string(meta_data)
	file.close()

func _on_file_dialog_file_selected(path):
	save_local(path)

func _on_stop_button_pressed():
	calculating = false
	StopButton.hide()
	StartButton.show()

func _on_start_button_pressed():
	calculating = true
	StopButton.show()
	StartButton.hide()
