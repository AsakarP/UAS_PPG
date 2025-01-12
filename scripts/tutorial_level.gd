extends Node2D

# Tutorial Level

func _on_exit_body_entered(body):
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
