extends CharacterBody2D

@onready var animated_sprite = $PlayerSprite
const SPEED = 100

func _physics_process(delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	var velocity = Vector2.ZERO
	# Movement WASD
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
