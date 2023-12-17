extends Control
class_name Display

@onready var viewport: SubViewport = $Viewport
@onready var low_res: SubViewport = $LowRes
@onready var aspect_fitter: AspectRatioContainer = $AspectFitter
@onready var aspect_texture: TextureRect = $AspectFitter/Texture

@export var view_height: int = 480
@export var keep_aspect: bool = true
@export var blur_display: bool = true

const MIN_ASPECT := 4.0/3.0
const MAX_ASPECT := 12.0/3.0

func _process(_delta):
	var aspect: float = MIN_ASPECT
	if not keep_aspect:
		aspect = clampf(size.x / size.y, MIN_ASPECT, MAX_ASPECT)
	
	var width: int = floori(view_height * aspect)
	if width % 2 != 0:
		width -= 1
	
	var highResMaterial: ShaderMaterial = aspect_texture.material
	highResMaterial.set_shader_parameter("blur", blur_display)
	
	var newSize := Vector2i(width, view_height)
	
	aspect_fitter.ratio = aspect
	if viewport.size != newSize:
		viewport.size = newSize
		low_res.size = newSize

func _rectify_event(event: InputEvent) -> InputEvent:
	if event is InputEventMouse:
		var newPosition = event.position
		newPosition -= aspect_texture.position
		if viewport.size.x / float(viewport.size.y) < size.x / size.y:
			newPosition *= (viewport.size.y / size.y)
		else:
			newPosition *= (viewport.size.x / size.x)
		event.position = newPosition
	
	return event

func _input(event):
	viewport.push_input(_rectify_event(event), true)
func _unhandled_input(event):
	viewport.push_input(_rectify_event(event), true)

func add_view_child(n: Node) -> bool:
	viewport.add_child(n)
	return true

func remove_view_child(n: Node) -> bool:
	if viewport.is_ancestor_of(n):
		viewport.remove_child(n)
		return true
	else:
		return false
