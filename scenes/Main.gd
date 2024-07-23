extends VBoxContainer

var ifs_list = []

var data = ""
var meta_data = ""
var file_counter = 0

var calculating = false
var sample_counter = 1

@onready var Progress = $Progress/MarginContainer/VBoxContainer/ProgressBar
@onready var StopButton = $Progress/MarginContainer/VBoxContainer/StopButton
@onready var StartButton = $Progress/MarginContainer/VBoxContainer/StartButton

@onready var LoadButton = $Export/Buttons/HBoxContainer/LoadButton
@onready var LoadDialog = $LoadFileDialog

@onready var IFSSettings = $SettingContainer/Options/Content/Lines/Seperator/IFSSettings

func _ready():
	$FileDialog.hide()
	StopButton.hide()
	StartButton.hide()
	LoadDialog.hide()

func _process(_delta):
	if calculating:
		if ifs_list and sample_counter <= len(ifs_list):
			# add centered image
			if Global.centered_and_not:
				data += image_to_string(generate_image(ifs_list[sample_counter-1], 1)) + "\n"
				# add not-centered image
				data += image_to_string(generate_image(ifs_list[sample_counter-1], 0)) + "\n"
				# add meta-data (in python-format)
				meta_data += meta_data_to_string(ifs_list[sample_counter-1]) + "\n"
				meta_data += meta_data_to_string(ifs_list[sample_counter-1]) + "\n"
			else:
				data += image_to_string(generate_image(ifs_list[sample_counter-1])) + "\n"
				# add meta-data (in python-format)
				meta_data += meta_data_to_string(ifs_list[sample_counter-1]) + "\n"
			# go on
			sample_counter += 1
			Progress.value = float(sample_counter) / len(ifs_list) * 100
		elif not ifs_list and sample_counter <= Global.sample_size:
			var ifs = IFS.random_ifs()
			if Global.centered_and_not:
				data += image_to_string(generate_image(ifs, 0)) + "\n"
				data += image_to_string(generate_image(ifs, 1)) + "\n"
				meta_data += meta_data_to_string(ifs) + "\n"
				meta_data += meta_data_to_string(ifs) + "\n"
			else:
				data += image_to_string(generate_image(ifs)) + "\n"
				meta_data += meta_data_to_string(ifs) + "\n"
			sample_counter += 1
			Progress.value = float(sample_counter) / Global.sample_size * 100
		else:
			end_calculating()

func start_calculating():
	seed(Global.random_seed)
	data = ""
	meta_data = ""
	sample_counter = 1
	resume_calculating()

func end_calculating():
	stop_calculating()
	save()

func stop_calculating():
	Global.p_centered = IFSSettings.PCentered.value
	StopButton.hide()
	StartButton.hide()
	calculating = false
	Progress.value = 0

func pause_calculating():
	calculating = false
	StopButton.hide()
	StartButton.show()

func resume_calculating():
	calculating = true
	StopButton.show()
	StartButton.hide()

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
				image[len(image)-real_position.y-1][real_position.x] = entry.color
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
				image[len(image)-real_position.y-1][real_position.x] = entry.color
	# the less points are drawn, the more likely is it to draw 
	if not Global.centered_and_not and not ifs_list and Global.prefer_nonempty_pictures and counter < float(Global.points)/2 and randf()*2 > float(counter) / Global.points:
		return points_to_image_centered(ifs, points)
	else:
		return image

func points_to_image(ifs, points):
	if randf() <= Global.p_centered:
		return points_to_image_centered(ifs, points)
	else:
		return points_to_image_original(ifs, points)

func generate_image(ifs, centered=-1):
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
	match sign(centered):
		-1: return points_to_image(ifs, results)
		0:  return points_to_image_original(ifs, results)
		1:  return points_to_image_centered(ifs, results)

func image_to_string(image):
	var strings = []
	for x in len(image):
		strings.append(",".join(image[x]))
	return ",".join(strings)

func ifs_from_meta_data(string):
	var ifs = IFS.new()
	var array = string.split(',')
	ifs.background_color = float(array[1])
	ifs.delay = int(array[2])
	for i in ((len(array)-3) / 7):
		var contr = Contraction.new()
		contr.translation = Vector2(float(array[3 + i * 7 + 0]), float(array[3 + i * 7 + 1]))
		contr.contract = Vector2(float(array[3 + i * 7 + 2]), float(array[3 + i * 7 + 3]))
		contr.rotation = float(array[3 + i * 7 + 4])
		contr.mirrored = (array[3 + i * 7 + 5] in ["1", "true"])
		contr.color = float(array[3 + i * 7 + 6])
		ifs.systems.append(contr)
	return ifs

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
	ifs_list = []
	start_calculating()

# saving

func save():
	$FileDialog.show()

func save_local(path):
	save_images(path)
	if not ifs_list:
		save_meta_data(path)

func save_images(path):
	if not path.ends_with(".csv"):
		path += ".csv"
	var file = FileAccess.open(
		path,
		FileAccess.WRITE)
	file.store_string(data)
	file.close()

func save_meta_data(path, overwrite_name = true):
	if path.ends_with(".csv"):
		path = path.left(path.length()-4)
	var file
	if overwrite_name:
		if path.ends_with("_meta"):
			path = path.left(path.length()-5)
		file = FileAccess.open(
			path+"_meta.csv",
			FileAccess.WRITE)
	else:
		if not path.ends_with('.csv'):
			path += ".csv"
		file = FileAccess.open(
			path,
			FileAccess.WRITE)
	file.store_string(meta_data)
	file.close()

func _on_file_dialog_file_selected(path):
	save_local(path)

func _on_stop_button_pressed():
	pause_calculating()

func _on_start_button_pressed():
	resume_calculating()

# loading files

func load_file(path):
	var file = FileAccess.open(
		path,
		FileAccess.READ)
	var string = file.get_as_text()
	var meta_list = string.split("\n")
	file.close()
	# get the ifs-s whose meta-data were not damaged
	ifs_list = []
	for item in meta_list:
		if item.begins_with("https://"):
			ifs_list.append(IFS.from_meta_data(item.replace("https://editor.fracmi.cc/#", "")))
		elif item.length() > 0:
			ifs_list.append(ifs_from_meta_data(item))
	# calculate fractals
	start_calculating()

func _on_upload_button_pressed():
	LoadDialog.show()

func _on_load_file_dialog_file_selected(path):
	LoadDialog.hide()
	load_file(path)

# just meta data

@onready var FileDialogForRandomMeta = $FileDialogForRandomMeta

func _on_meta_button_pressed():
	stop_calculating()
	FileDialogForRandomMeta.show()

func _on_file_dialog_for_random_meta_file_selected(path):
	meta_data = ""
	for i in Global.sample_size:
		meta_data += meta_data_to_string(IFS.random_ifs()) + "\n"
	# save stuff
	save_meta_data(path, false)
	FileDialogForRandomMeta.hide()
