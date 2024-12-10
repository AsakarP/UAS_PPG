extends CharacterBody2D

var SPEED = 50
@export var player: Node2D
@onready var SkeleNav = $SkeletonNavigation

func _physics_process(delta):
	var dir = to_local(SkeleNav.get_next_path_position()).normalized()
	velocity = dir * SPEED
	move_and_slide()
	
func makePath():
	SkeleNav.target_position = player.global_position

func _on_timer_timeout():
	makePath()
	pass
