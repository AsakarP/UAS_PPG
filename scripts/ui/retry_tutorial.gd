extends Control

# Retry Screen in tutorial
func _on_retry_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")

func _on_back_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
