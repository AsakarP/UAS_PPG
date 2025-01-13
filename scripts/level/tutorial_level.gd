extends Node2D

# Tutorial Level
var enemy_count = 1
@onready var block = $Exit/StaticBody2D

func _ready():
	for enemies in $Skeletons.get_children():
		if enemies.has_signal("enemy_died"):
			enemies.connect("enemy_died", Callable(self,"onEnemyDied"))

# Clear enemy requirement
func onEnemyDied():
	enemy_count -= 1
	if enemy_count <= 0:
		unlock_room()

# Unlock door to next room
func unlock_room():
	block.position = Vector2(0, -13)


func _on_exit_area_body_entered(body):
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
