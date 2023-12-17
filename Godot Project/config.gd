extends Node

signal updated

const PATH := "user://config.cfg"

const SEC_VIDEO := "video"
const KEY_SCREEN := "screen"
const KEY_WIDE := "wide"
const KEY_SHARP := "sharp"

const SEC_INPUT = "input"
const KEY_MOUSE_SENS = "mouse_sensitivity"
const KEY_PAD_SENS = "gamepad_sensitivity"

var screen: int = 0:
	set(n):
		screen = clampi(n, 0, DisplayServer.get_screen_count() + 1)
		_save()
var wide: bool = false:
	set(n):
		wide = n
		_save()
var sharp: bool = false:
	set(n):
		sharp = n
		_save()

var mouse_sens: int = 5:
	set(n):
		mouse_sens = clampi(n, 1, 10)
		_save()
var pad_sens: int = 5:
	set(n):
		pad_sens = clampi(n, 1, 10)
		_save()

var _suppress_save: bool = false

func _save():
	if not _suppress_save:
		var c = ConfigFile.new()
		c.set_value(SEC_VIDEO, KEY_SCREEN, screen)
		c.set_value(SEC_VIDEO, KEY_WIDE, wide)
		c.set_value(SEC_VIDEO, KEY_SHARP, sharp)
		
		c.set_value(SEC_INPUT, KEY_MOUSE_SENS, mouse_sens)
		c.set_value(SEC_INPUT, KEY_PAD_SENS, pad_sens)
		c.save(PATH)
		updated.emit()

func initialize():
	_suppress_save = true
	screen = get_tree().root.current_screen + 1
	
	var c = ConfigFile.new()
	if c.load(PATH) == OK:
		screen = c.get_value(SEC_VIDEO, KEY_SCREEN, screen)
		wide = c.get_value(SEC_VIDEO, KEY_WIDE, wide)
		sharp = c.get_value(SEC_VIDEO, KEY_SHARP, sharp)
		
		mouse_sens = c.get_value(SEC_INPUT, KEY_MOUSE_SENS, mouse_sens)
		pad_sens = c.get_value(SEC_INPUT, KEY_PAD_SENS, pad_sens)
	if OS.get_name() == "Web":
		screen = 0
	_suppress_save = false
	
	_save()

func listen(target: Callable):
	updated.connect(target)
	target.call()
