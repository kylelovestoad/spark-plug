extends Node2D

var debug = false

var level_controller: Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		debug = !debug
		
