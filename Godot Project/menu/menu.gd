extends Control

signal on_startup

@onready var ANIMATOR: AnimationPlayer = $Animator
@onready var MAIN: Control = $Main
@onready var MAIN_START: Control = $Main/Enter/EnterButton
@onready var LEAVE_ITEM: Control = $Main/Leave
@onready var EDIT: Control = $Edit
@onready var EDIT_START: Control = $Edit/List/Screen/ScreenSlider
@onready var SCREEN_SLIDER: HSlider = $Edit/List/Screen/ScreenSlider
@onready var BLUR_CHECK: CheckBox = $Edit/List/Blur/BlurCheck
@onready var WIDE_CHECK: CheckBox = $Edit/List/Wide/WideCheck
@onready var GPAD_SLIDER: HSlider = $Edit/List/GPad/GPadSlider
@onready var MOUSE_SLIDER: HSlider = $Edit/List/Mouse/MouseSlider

enum MenuState {
	PRE,
	START,
	ANIMATING_IN,
	MAIN,
	EDIT,
	PLAYING,
}
var _current_state: MenuState = MenuState.PRE

var _is_initial_menu: bool = true

func _go_to_play():
	_current_state = MenuState.PLAYING
	_is_initial_menu = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
func _go_to_menu():
	_current_state = MenuState.MAIN
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_to_main()
func _start_finished():
	_to_main()
func _animate_in():
	_current_state = MenuState.ANIMATING_IN
	ANIMATOR.play("start")
func _to_main():
	_current_state = MenuState.MAIN
	MAIN.visible = true
	EDIT.visible = false
	MAIN_START.grab_focus()
func _to_edit():
	if get_tree().root.mode == Window.MODE_WINDOWED:
		Config._suppress_save = true
		Config.screen = 0
		Config._suppress_save = false
	
	_current_state = MenuState.EDIT
	MAIN.visible = false
	EDIT.visible = true
	EDIT_START.grab_focus()

func _maybe_leave_menu():
	if not _is_initial_menu:
		if Input.is_action_just_pressed("menu"):
			_has_menu_start = true
		if get_tree().paused and Input.is_action_just_released("menu") and _has_menu_start:
			_has_menu_start = false
			_go_to_play()

var _has_menu_start: bool = false
func _process(_delta):
	if get_tree().paused and _current_state == MenuState.PLAYING:
		_go_to_menu()
	
	if _current_state == MenuState.START:
		if Input.is_action_just_pressed("menu") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_animate_in()
	elif _current_state == MenuState.MAIN:
		_maybe_leave_menu()
	elif _current_state == MenuState.EDIT:
		if Input.is_action_just_pressed("ui_cancel"):
			_to_main()

func _on_on_startup():
	_current_state = MenuState.START
	ANIMATOR.play("start_loop")

func _on_enter_button_pressed():
	_go_to_play()
func _on_edit_button_pressed():
	_to_edit()
func _on_leave_button_pressed():
	get_tree().quit()

func _on_config_updated():
	SCREEN_SLIDER.set_value_no_signal(Config.screen)
	BLUR_CHECK.set_pressed_no_signal(not Config.sharp)
	WIDE_CHECK.set_pressed_no_signal(Config.wide)
	GPAD_SLIDER.set_value_no_signal(Config.pad_sens)
	MOUSE_SLIDER.set_value_no_signal(Config.mouse_sens)

func _ready():
	if OS.get_name() == "Web":
		MAIN.remove_child(LEAVE_ITEM)
	SCREEN_SLIDER.tick_count = DisplayServer.get_screen_count() + 1
	SCREEN_SLIDER.max_value = DisplayServer.get_screen_count()
	
	Config.listen(_on_config_updated)

func _on_screen_slider_value_changed(value):
	Config.screen = value
func _on_blur_check_toggled(toggled_on):
	Config.sharp = not toggled_on
func _on_wide_check_toggled(toggled_on):
	Config.wide = toggled_on
func _on_g_pad_slider_value_changed(value):
	Config.pad_sens = value
func _on_mouse_slider_value_changed(value):
	Config.mouse_sens = value
func _on_return_button_pressed():
	_to_main()


