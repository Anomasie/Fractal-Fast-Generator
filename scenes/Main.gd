extends VBoxContainer

var data = ""
var file_counter = 0

func _ready():
	$FileDialog.hide()

func image_to_string(image):
	var strings = []
	for x in len(image):
		strings.append(",".join(image[x]))
	return ",".join(strings)

func generate_fractals():
	for _i in Global.sample_size:
		var image = [[0,1],[0.5,0]]
		data += image_to_string(image) + "\n"
	save()

func _on_button_pressed():
	generate_fractals()

# saving

func save():
	if OS.has_feature("web"):
		save_from_web()
	else:
		$FileDialog.show()

func save_from_web():
	var filename = "generated-fractals" + str(file_counter) + ".csv"
	file_counter += 1
	var buf = data.to_utf8_buffer()
	JavaScriptBridge.download_buffer(buf, filename)

func save_local(path):
	# save image
	if not path.ends_with(".csv"):
		path += ".csv"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data)

func _on_file_dialog_file_selected(path):
	save_local(path)
