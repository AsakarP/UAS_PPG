extends CharacterBody2D

var SPEED = 50
@export var player: Node2D
@onready var animated_sprite = $SkeletonSprite
@onready var SkeleNav = $SkeletonNavigation
var go_to_player = true
var can_take_dmg = true

# Combat
var health = 100
var player_in_atk_range = false

func _physics_process(delta):
	var dir = to_local(SkeleNav.get_next_path_position()).normalized()
	velocity = dir * SPEED
	
	if dir.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif dir.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	#print (velocity)
	
	if velocity != Vector2.ZERO:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
		
	move_and_slide()
	
	# Combat
	deal_dmg()
	
func makePath():
	if go_to_player == true:
		SkeleNav.target_position = player.global_position
	else:
		pass

func _on_timer_timeout():
	makePath()

func enemy():
	pass

func _on_skele_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_atk_range = true
		go_to_player = false

func _on_skele_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_atk_range = false
		go_to_player = true

func deal_dmg():
	if Global.player_curr_atk == true:
		if can_take_dmg == true:
			health -= 20
			$take_dmg_cooldown.start()
			can_take_dmg = false
			print("Skele HP:",health)
			if health <= 0:
				self.queue_free()


func _on_take_dmg_cooldown_timeout():
	can_take_dmg = true
