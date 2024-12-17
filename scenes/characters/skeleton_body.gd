extends CharacterBody2D

var SPEED = 50
@export var player: Node2D
@onready var animated_sprite = $SkeletonSprite
@onready var SkeleNav = $SkeletonNavigation

func _physics_process(delta):
	var dir = to_local(SkeleNav.get_next_path_position()).normalized()
	velocity = dir * SPEED
	
	if dir.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif dir.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	print (velocity)
	move_and_slide()
	
func makePath():
	SkeleNav.target_position = player.global_position

func _on_timer_timeout():
	makePath()
	
	pass
