extends Label

@export
var offset = 100

func _ready() -> void:
	
	# Sets initial position to something above vbox
	position.y -= offset
	var tween = get_tree().create_tween()

	tween.tween_property(self, "position:y", position.y + offset, 1.0) \
		.set_trans(Tween.TRANS_BOUNCE) \
		.set_ease(Tween.EASE_OUT)
