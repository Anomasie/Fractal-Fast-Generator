extends MarginContainer

func _ready():
	Global.nb_contractions_min = $Content/Content/Lines/HBoxContainer/MinEdit.value
	Global.nb_contractions_max = $Content/Content/Lines/HBoxContainer/MaxEdit.value
	Global.delay = $Content/Content/Lines/HBoxContainer/DelayEdit.value
	Global.p_centered = $Content/Content/Lines/HBoxContainer/CenteredEdit.value

func _on_min_edit_value_changed(value):
	Global.nb_contractions_min = value

func _on_max_edit_value_changed(value):
	Global.nb_contractions_max = value

func _on_delay_edit_value_changed(value):
	Global.delay = value

func _on_centered_edit_value_changed(value):
	Global.p_centered = value
