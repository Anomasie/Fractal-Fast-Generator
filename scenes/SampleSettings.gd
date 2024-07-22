extends VBoxContainer

@onready var SeedEdit = $Boxes/SeedEdit
@onready var AmountEdit = $Boxes/AmountEdit
@onready var SizeEdit = $Boxes/SizeEdit
@onready var PointsEdit = $Boxes/PointsEdit
@onready var NonemptyPicChecker = $NonemptyPicturesChecker
@onready var CenteredAndNot = $BothCenteredAndNot

func _ready():
	Global.random_seed = SeedEdit.value
	Global.sample_size = AmountEdit.value
	Global.image_size = SizeEdit.value
	Global.points = PointsEdit.value
	Global.prefer_nonempty_pictures = NonemptyPicChecker.button_pressed
	Global.centered_and_not = CenteredAndNot.button_pressed

func _on_seed_edit_value_changed(value):
	Global.random_seed = value

func _on_amount_edit_value_changed(value):
	Global.sample_size = value

func _on_size_edit_value_changed(value):
	Global.image_size = value

func _on_points_edit_value_changed(value):
	Global.points = value

func _on_nonempty_pictures_checker_pressed():
	Global.prefer_nonempty_pictures = NonemptyPicChecker.button_pressed

func _on_both_centered_and_not_pressed():
	Global.centered_and_not = CenteredAndNot.button_pressed
