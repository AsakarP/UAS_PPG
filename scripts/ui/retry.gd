extends Control

# Retry Screen

@onready var colorRect = $ColorRect2
@onready var anim = $fade_in

func _ready():
	colorRect.visible = true
	anim.play("fade")

func _on_retry_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/game_level.tscn")

func _on_back_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

func _on_fade_in_animation_finished(anim_name):
	if anim_name == "fade":
		colorRect.visible = false
