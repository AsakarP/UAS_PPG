extends CharacterBody2D

# Enemy Skeleton
# Skeleton variables
var SPEED = 40
var stop_range = 20
@export var player: Node2D
@onready var animated_sprite = $Node2D/SkeletonSprite
@onready var SkeleNav = $SkeletonNavigation
@onready var dmgHighlight = $damage_highlight
var can_take_dmg = true

signal enemy_died

# Combat variables
var health = 150
var player_in_atk_range = false

func _ready():
	if not player:
		player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Updates nav if not close to player
	if distance_to_player > stop_range:
		var next_position = SkeleNav.get_next_path_position()
		var dir = (next_position - global_position).normalized()
		velocity = dir * SPEED
		SkeleNav.target_position = player.global_position
	else:
		velocity = Vector2.ZERO
		SkeleNav.target_position = global_position
	
	# Flip sprite
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
	
	# Movement
	var collision = move_and_collide(velocity * delta)
	if collision and collision.get_collider().has_method("player"):
		velocity = Vector2.ZERO
	
	# Animation
	if velocity != Vector2.ZERO:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
		
	# Combat
	health_system()

# Find player if player is far away
func makePath():
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > stop_range:
		SkeleNav.target_position = player.global_position
	else:
		SkeleNav.target_position = global_position

# Pathing timer
func _on_timer_timeout():
	makePath()

# Is an Enemy
func enemy():
	pass

# Skeleton body enters player
func _on_skele_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_atk_range = true

# Skeleton body exits player
func _on_skele_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_atk_range = false

# Skeleton take damage
func damage(amount):
	if can_take_dmg == true:
		health -= amount
		dmgHighlight.play("damaged")
		$take_dmg_cooldown.start()
		can_take_dmg = false
		# Skeleton died
		if health <= 0:
			emit_signal("enemy_died")
			queue_free()

# Dmg Cooldown
func _on_take_dmg_cooldown_timeout():
	can_take_dmg = true

# HP for skele
func health_system():
	var healthbar = $Enemyhealthbar
	healthbar.value = health
	healthbar.visible = health < 150
