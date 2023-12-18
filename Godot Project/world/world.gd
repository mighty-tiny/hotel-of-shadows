extends Node3D
class_name World

signal on_startup

static var WORLD: World

@onready var CAM: GameCamera = $GameCamera
@onready var ENV: Environment = $WorldEnvironment.environment

var player: Player

var _cur_fog_start: float
var _cur_fog_end: float
var _cur_fog_color: Color
var _old_fog_start: float
var _old_fog_end: float
var _old_fog_color: Color
var _target_fog_start: float = 0.0
var _target_fog_end: float = 8.0
var _target_fog_color: Color = Color(0, 0, 0)
var _target_fog_acc: float = 0.0
var _target_fog_time: float = 0.0

func set_fog(start: float, end: float, color: Color, time: float):
	_old_fog_start = _cur_fog_start
	_old_fog_end = _cur_fog_end
	_old_fog_color = _cur_fog_color
	
	_target_fog_start = start
	_target_fog_end = end
	_target_fog_color = color
	_target_fog_acc = 0
	_target_fog_time = time

func _process(delta):
	_cur_fog_start = _target_fog_start
	_cur_fog_end = _target_fog_end
	_cur_fog_color = _target_fog_color
	
	if _target_fog_time > 0.0 and _target_fog_acc < _target_fog_time:
		_target_fog_acc += delta
		var a := _target_fog_acc / _target_fog_time
		_cur_fog_start = lerpf(_old_fog_start, _target_fog_start, a)
		_cur_fog_end = lerpf(_old_fog_end, _target_fog_end, a)
		_cur_fog_color = lerp(_old_fog_color, _target_fog_color, a)

	RenderingServer.global_shader_parameter_set("fog_start", _cur_fog_start)
	RenderingServer.global_shader_parameter_set("fog_end", _cur_fog_end)
	RenderingServer.global_shader_parameter_set("fog_color", _cur_fog_color)
	ENV.background_color = _cur_fog_color
	
	CAM.global_position = player.HEAD.global_position
	CAM.global_rotation = player.HEAD.global_rotation

func _spawn_first_chunk(chunk: PackedScene):
	var c: WorldChunk = chunk.instantiate()
	
	player = preload("res://player/player.tscn").instantiate()
	add_child(player)
	
	add_child(c)
	
	var s := c.get_node(c.spawn_point)
	player.global_position = s.global_position
	player.global_rotation = s.global_rotation

func _ready():
	WORLD = self
	_spawn_first_chunk(preload("res://chunks/intro_chunk/intro_chunk.tscn"))
