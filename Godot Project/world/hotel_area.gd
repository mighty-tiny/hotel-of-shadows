extends Area3D
class_name HotelArea3D

@export var fog_start: float = 0.0
@export var fog_end: float = 25.0
@export var fog_color: Color = Color(0.0, 0.0, 0.0)
@export var fog_change_time: float = 0.0

var is_current_area: bool = false

func _on_player_entered():
	World.WORLD.set_fog(fog_start, fog_end, fog_color, fog_change_time)

func _on_body_entered(body: Node3D):
	if body is GameCamera and not is_current_area:
		is_current_area = true
		_on_player_entered()
func _on_body_left(body: Node3D):
	if body is GameCamera and is_current_area:
		is_current_area = false

func _ready():
	collision_mask |= 1 << 15
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_left)
