extends Label

@export
var player: CharacterBody2D

func _process(delta: float) -> void:
	text = "Lives: " + str(player.lives)
