extends TextureButton

@onready var parent: MenuItem = get_parent()

func _on_focus_entered():
	parent.focus_updated(true)
func _on_focus_exited():
	parent.focus_updated(false)
