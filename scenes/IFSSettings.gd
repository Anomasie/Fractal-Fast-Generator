extends MarginContainer

@onready var NbContractionsMin = $Content/Content/Lines/HBoxContainer/MinEdit
@onready var NbContractionsMax = $Content/Content/Lines/HBoxContainer/MaxEdit
@onready var DelayMin = $Content/Content/Lines/HBoxContainer/DelayMinEdit
@onready var DelayMax = $Content/Content/Lines/HBoxContainer/DelayMaxEdit
@onready var PCentered = $Content/Content/Lines/CenteredEdit
@onready var BGColorChecker = $Content/Content/Lines/BGColorChecker

func _ready():
	Global.nb_contractions_min = NbContractionsMin.value
	Global.nb_contractions_max = NbContractionsMax.value
	Global.delay_min = DelayMin.value
	Global.delay_max = DelayMax.value
	Global.p_centered = PCentered.value
	Global.bgcolor_allowed = BGColorChecker.button_pressed

func _on_min_edit_value_changed(value):
	Global.nb_contractions_min = value

func _on_max_edit_value_changed(value):
	Global.nb_contractions_max = value

func _on_delay_max_edit_value_changed(value):
	Global.delay_max = value

func _on_delay_min_edit_value_changed(value):
	Global.delay_min = value

func _on_centered_edit_value_changed(value):
	Global.p_centered = value

func _on_bg_color_checker_pressed():
	Global.bgcolor_allowed = BGColorChecker.button_pressed
