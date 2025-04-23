extends Control

@export
var initial_button: Button


func _ready() -> void:
	initial_button.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
	
