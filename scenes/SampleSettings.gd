extends GridContainer

@onready var SeedEdit = $SeedEdit
@onready var AmountEdit = $AmountEdit
@onready var SizeEdit = $SizeEdit
@onready var PointsEdit = $PointsEdit

func _ready():
	Global.random_seed = SeedEdit.value
	Global.sample_size = AmountEdit.value
	Global.image_size = SizeEdit.value
	Global.points = PointsEdit.value

func _on_seed_edit_value_changed(value):
	Global.random_seed = value

func _on_amount_edit_value_changed(value):
	Global.sample_size = value

func _on_size_edit_value_changed(value):
	Global.image_size = value

func _on_points_edit_value_changed(value):
	Global.points = value
