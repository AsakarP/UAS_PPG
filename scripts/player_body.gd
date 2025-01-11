extends CharacterBody2D

# Player Variables
@onready var animated_sprite = $PlayerSprite
@onready var sword: Node2D = get_node("PlayerSword")
@onready var sword_animation_player : AnimationPlayer = sword.get_node("SwordAnimationPlayer")
var SPEED = 150
var enemies_in_atk_range = []
var enemy_atk_cooldown = true
var health = 100
var player_alive = true
var atk_in_progress = false
var attack = false

func _physics_process(delta):
	# Mouse tracking
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
		
	# WASD movement
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
	
	# Animation
	if velocity != Vector2.ZERO:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	# Movement
	move_and_slide()
	
	# Combat system
	enemy_atk()
	atk()
	health_system()
	
	# If player died
	if health <= 0:
		player_alive = false
		health = 0
		print("Player Killed")
		get_tree().change_scene_to_file("res://scenes/ui/retry.tscn")

# Is a player
func player():
	pass

# if enemy attacks
func enemy_atk():
	if enemies_in_atk_range.size() > 0 and enemy_atk_cooldown:
		for enemy in enemies_in_atk_range:
			health -= 5
		enemy_atk_cooldown = false
		$Atk_cooldown.start()
		print("Player HP:", health)
# enemy attack cooldown
func _on_atk_cooldown_timeout():
	enemy_atk_cooldown = true

# Player attack
func atk():
	if Input.is_action_just_pressed("ui_attack"):
		attack = true

# Attack timeout
func _on_deal_atk_timeout():
	$deal_atk.stop()
	Global.player_curr_atk = false
	atk_in_progress = false
	attack = false

# Enemy enters player body
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy") and body not in enemies_in_atk_range:
		enemies_in_atk_range.append(body)

# Enemy exits player body
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy") and body in enemies_in_atk_range:
		enemies_in_atk_range.erase(body)

# Sword enters enemys body
func _on_sword_hitbox_body_entered(body):
	if body.has_method("enemy"):
		if attack == true:
			Global.player_curr_atk = true
			atk_in_progress = true
			$deal_atk.start()

# Sword exits enemys body
func _on_sword_hitbox_body_exited(body):
	if body.has_method("enemy"):
		attack = false

# Player health
func health_system():
	var healthbar = $Healthbar
	healthbar.value = health
