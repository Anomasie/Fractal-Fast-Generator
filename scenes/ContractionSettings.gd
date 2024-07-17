extends MarginContainer

@onready var MirrorEdit = $Main/Content/Lines/MirrorEdit
@onready var RotationEdit = $Main/Content/Lines/RotationEdit
@onready var GreyscaleEdit = $Main/Content/Lines/GreyscaleEdit

func _ready():
	Global.translation_min = $Main/Content/Lines/Contraction/TranslationMinEdit
	Global.translation_max = $Main/Content/Lines/Contraction/TranslationMaxEdit
	Global.contr_min = $Main/Content/Lines/Contraction/ContrMinEdit
	Global.contr_max = $Main/Content/Lines/Contraction/ContrMaxEdit
	Global.mirroring_allowed = MirrorEdit.button_pressed
	Global.rotation_allowed = RotationEdit.button_pressed
	Global.greyscale_allowed = GreyscaleEdit.button_pressed

func _on_translation_min_edit_value_changed(value):
	Global.translation_min = value

func _on_translation_max_edit_value_changed(value):
	Global.translation_max = value

func _on_contr_min_edit_value_changed(value):
	Global.contr_min = value

func _on_contr_max_edit_value_changed(value):
	Global.contr_max = value

func _on_mirror_edit_pressed():
	Global.mirroring_allowed = MirrorEdit.button_pressed

func _on_rotation_edit_pressed():
	Global.rotation_allowed = RotationEdit.button_pressed

func _on_greyscale_edit_pressed():
	Global.rotation_allowed = GreyscaleEdit.button_pressed
