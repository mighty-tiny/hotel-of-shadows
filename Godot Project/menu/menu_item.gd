extends HBoxContainer
class_name MenuItem

@onready var SELECTED_INDICATOR: TextureRect = $SelectedIndicator

func focus_updated(focused: bool):
	SELECTED_INDICATOR.self_modulate.a = 1 if focused else 0
