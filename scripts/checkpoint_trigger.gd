extends Area2D
signal checkpoint_reached(new_position: Vector2)

@onready
var respawn_point = $RespawnPoint

func _on_body_entered(body: Node2D) -> void:
	checkpoint_reached.connect(Callable(body, "_on_checkpoint_reached"))
	checkpoint_reached.emit(respawn_point.global_position)
