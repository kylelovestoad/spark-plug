extends Node

signal died
signal health_changed(new_health: int)

@export 
var max_health: int = 1
var current_health: int
var alive = true

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	emit_signal("health_changed", current_health)
	
	if current_health <= 0 && alive:
		die()

func die() -> void:
	emit_signal("died")
	
func respawn() -> void:
	current_health = max_health
	alive = true
