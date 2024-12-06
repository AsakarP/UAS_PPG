extends CharacterBody2D

@onready var _animated_sprite = $PlayerSprite
const SPEED = 100

func _physics_process(delta):
	var velocity = Vector2.ZERO
	# Movement WASD
	if Input.is_key_pressed(KEY_W):
		velocity.y -= SPEED
	if Input.is_key_pressed(KEY_A):
		$PlayerSprite.flip_h = true
		velocity.x -= SPEED
	if Input.is_key_pressed(KEY_S):
		velocity.y += SPEED
	if Input.is_key_pressed(KEY_D):
		velocity.x += SPEED
		$PlayerSprite.flip_h = false
	
	position += velocity * delta
	
	# Animasi gerakan
	if velocity != Vector2.ZERO:
		_animated_sprite.play("run")
	else:
		_animated_sprite.play("idle")
	
	# Dapat menabrak collision
	move_and_slide()
