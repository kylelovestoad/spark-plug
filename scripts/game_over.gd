extends Control

@export
var initial_button: Button

func _ready() -> void:
	initial_button.grab_focus()

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
