extends CanvasLayer

@export
var player: CharacterBody2D

@export
var label: Label

func _process(delta: float) -> void:
	label.text = "Lives: " + str(player.lives)
