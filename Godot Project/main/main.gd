extends Control

@onready var display: Display = $Display

@export var initial_scenes: Array[PackedScene] = []
var initial_nodes: Array[Node]

var _current_screen: int = -1
func _on_config_updated():
	if Config.screen != _current_screen:
		_current_screen = Config.screen
		
		var w: Window = get_tree().root
		
		if Config.screen > 0:
			w.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			w.current_screen = Config.screen - 1
		else:
			w.mode = Window.MODE_WINDOWED
		
		w.borderless = false
		w.unresizable = false
	
	display.keep_aspect = not Config.wide
	display.blur_display = not Config.sharp

func remove_splash():
	var splash := $Splash
	splash.queue_free()
	Config.listen(_on_config_updated)
	for n: Node in initial_nodes:
		n.emit_signal("on_startup")

func boot():
	get_tree().create_timer(1.0).timeout.connect(remove_splash)
	Config.initialize()

var _is_first_frame: bool = true
func _draw():
	if _is_first_frame:
		_is_first_frame = false
		boot()

func _ready():
	get_tree().paused = true
	for s in initial_scenes:
		var n: Node = s.instantiate()
		initial_nodes.push_back(n)
		display.add_view_child(n)
