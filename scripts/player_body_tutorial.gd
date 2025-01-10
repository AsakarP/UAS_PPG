extends CharacterBody2D

@onready var animated_sprite = $PlayerSprite
const SPEED = 150

@onready var sword: Node2D = get_node("PlayerSword")
@onready var sword_animation_player : AnimationPlayer = sword.get_node("SwordAnimationPlayer")

var enemy_in_atk_range = false
var enemy_atk_cooldown = true
var health = 100
var player_alive = true

var atk_in_progress = false
var attack = false

func _physics_process(delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	if Input.is_action_just_pressed("ui_attack") and not sword_animation_player.is_playing():
		sword_animation_player.play("attack")
		
	sword.rotation = mouse_direction.angle()
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
	# Movement WASD
	var velocity = Vector2.ZERO
	if Input.is_key_pressed(KEY_W):
		velocity.y -= SPEED
	if Input.is_key_pressed(KEY_A):
		velocity.x -= SPEED
	if Input.is_key_pressed(KEY_S):
		velocity.y += SPEED
	if Input.is_key_pressed(KEY_D):
		velocity.x += SPEED
	
	position += velocity * delta
	
	# Animasi gerakan
	if velocity != Vector2.ZERO:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	# Dapat menabrak collision
	move_and_slide()
	
	# Combat system
	enemy_atk()
	atk()
	health_system()
	
	if health <= 0:
		player_alive = false # Kembali ke menu / Respawn
		health = 0
		print("Player Killed")
		get_tree().change_scene_to_file("res://scenes/ui/retryTutorial.tscn")

func player():
	pass

func enemy_atk():
	if enemy_in_atk_range and enemy_atk_cooldown == true:
		health -= 5
		enemy_atk_cooldown = false
		$Atk_cooldown.start()
		print("Player HP:", health)

func _on_atk_cooldown_timeout():
	enemy_atk_cooldown = true

func atk():
	if Input.is_action_just_pressed("ui_attack"):
		attack = true

func _on_deal_atk_timeout():
	$deal_atk.stop()
	Global.player_curr_atk = false
	atk_in_progress = false

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = false

func _on_sword_hitbox_body_entered(body):
	if body.has_method("enemy"):
		if attack == true:
			print("Sword Hit")
			Global.player_curr_atk = true
			atk_in_progress = true
			$deal_atk.start()

func _on_sword_hitbox_body_exited(body):
	if body.has_method("enemy"):
		print("Sword End")
		attack = false
		
func health_system():
	var healthbar = $Healthbar
	healthbar.value = health
	
	#if health >= 100:
		#healthbar.visible = false
	#else:
		#healthbar.visible = true
