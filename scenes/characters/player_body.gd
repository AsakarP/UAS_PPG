extends CharacterBody2D

@onready var animated_sprite = $PlayerSprite
const SPEED = 150

@onready var sword: Node2D = get_node("PlayerSword")
@onready var sword_animation_player : AnimationPlayer = sword.get_node("SwordAnimationPlayer")

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
