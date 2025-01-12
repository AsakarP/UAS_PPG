extends Control

# Menu Screen
@onready var colorRect = $ColorRect
@onready var animationPlayer = $AnimationPlayer

func _ready():
	colorRect.visible = true
	animationPlayer.play("fade_in")

# Play button
func _on_play_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/game_level.tscn")

# Tutorial Button
func _on_tutorial_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/tutorial_level.tscn")

# Quit Button
func _on_quit_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().quit()

# Fade in to menu
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		colorRect.visible = false
