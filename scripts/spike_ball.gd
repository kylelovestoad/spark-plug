extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.health_component:
			body.health_component.take_damage(1)
