extends Control

func _on_play_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/game_level.tscn")


func _on_tutorial_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")


func _on_quit_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().quit()
