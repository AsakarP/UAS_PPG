extends Node2D

# The Cells Room
var enemy_count = 5
@onready var pointer = $Pointer
@onready var block = $Exit/StaticBody2D

func _ready():
	pointer.visible = false
	for enemies in $Skeletons.get_children():
		if enemies.has_signal("enemy_died"):
			enemies.connect("enemy_died", Callable(self,"onEnemyDied"))
	
# Clear enemy requirement
func onEnemyDied():
	enemy_count -= 1
	print(enemy_count)
	if enemy_count <= 0:
		unlock_room()

# Unlock door to next room
func unlock_room():
	block.position = Vector2(0, -20)
	pointer.visible = true
	print("Room Unlocked")

func _on_next_body_entered(body):
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/hallway2.tscn")
