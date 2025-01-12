extends Control

@onready var colorRect = $ColorRect
@onready var animationPlayer = $AnimationPlayer

func _ready():
	colorRect.visible = true
	animationPlayer.play("fade_in")

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

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		colorRect.visible = false
