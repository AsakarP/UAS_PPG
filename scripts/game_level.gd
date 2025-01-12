extends Node2D

var enemy_count = 3
@onready var block = $Node2D/StaticBody2D

func _ready():
	for skeleton in $Skeletons.get_children():
		if skeleton.has_signal("enemy_died"):
			skeleton.connect("enemy_died", Callable(self,"onEnemyDied"))

func onEnemyDied():
	enemy_count -= 1
	print("Enemy Count:",enemy_count)
	if enemy_count <= 0:
		unlock_room()

func unlock_room():
	block.position = Vector2(0, -13)
	print("Room Unlocked")

func _on_next_body_entered(body):
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
