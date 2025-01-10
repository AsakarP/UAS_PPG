extends Control

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
