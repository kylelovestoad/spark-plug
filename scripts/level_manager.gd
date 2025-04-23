extends Node

@export
var initial_level: Level

var current_level: Level = initial_level

func _ready() -> void:
	Game.level_controller = self
