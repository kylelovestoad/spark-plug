extends AnimatedSprite2D

func interrupt_anim(anim: String):
	if is_playing():
		stop()
		
	play(anim)
