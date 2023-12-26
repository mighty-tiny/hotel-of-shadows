extends Node3D

var _first_time: bool = true
func _process(_delta):
	if (not get_tree().paused) and _first_time:
		_first_time = false
		World.WORLD.change_chunk(preload("res://chunks/lobby_chunk/lobby_chunk.tscn"))
