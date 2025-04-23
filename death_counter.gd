extends Label

func _process(delta: float) -> void:
	text = "Deaths: " + str(Game.deaths)

func _on_died() -> void:
	var tree = get_tree()
	# Prevents null value on game over
	if not tree: return
	
	var tween = tree.create_tween()

	# In the future I'd like a more general tween without hardcoded positions
	tween.tween_property(self, "position:x", 0, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_interval(0.5)

	tween.tween_property(self, "position:x", -80, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_IN)
