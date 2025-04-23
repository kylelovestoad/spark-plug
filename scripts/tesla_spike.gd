extends Area2D

@onready 
var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready
var play_timer: Timer = $AnimationTimer

@export 
var play_interval: float = 2.0

@export
var damage_anim = "hit"

func _ready() -> void:
	play_timer.wait_time = play_interval
	play_timer.one_shot  = false
	play_timer.start()
	sprite.speed_scale = 2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.health_component:
			body.health_component.take_damage(1)
			sprite.play(damage_anim)


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.stop()


func _on_animated_sprite_2d_animation_looped() -> void:
	sprite.stop()


func _on_animation_timer_timeout() -> void:
	sprite.stop()
	sprite.play(damage_anim) # Replace with function body.
