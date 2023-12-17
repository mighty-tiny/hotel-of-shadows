extends CharacterBody3D

@onready var HEAD := $Head

const SPEED = 5.0
const ACCELERATION = 20.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _mapSensitivity(a: int, from: float, to: float) -> float:
	return lerpf(from, to, (a - 1) / 9.0)
	
func _rotate_head(alpha: Vector2):
	rotate_y(-alpha.x)
	HEAD.rotation.x = clampf(HEAD.rotation.x - alpha.y, deg_to_rad(-90), deg_to_rad(90))
func _unhandled_input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_rotate_head(event.relative * _mapSensitivity(Config.mouse_sens, 0.001, 0.003))

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().paused = true

func _physics_process(delta):
	var looking = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if looking.length_squared() > 1.0:
		looking = looking.normalized()
	_rotate_head(looking * _mapSensitivity(Config.pad_sens, 1, 3) * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta

	var moveDir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement = transform.basis * Vector3(moveDir.x, 0, moveDir.y)
	if movement.length_squared() > 1.0:
		movement = movement.normalized()
	velocity.x = move_toward(velocity.x, movement.x * SPEED, ACCELERATION * delta)
	velocity.z = move_toward(velocity.z, movement.z * SPEED, ACCELERATION * delta)

	move_and_slide()
