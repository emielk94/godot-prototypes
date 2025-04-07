extends CharacterBody2D

@onready var sprite = $animsprite2D
@onready var player = get_parent().find_child("player")
@onready var melee_hitbox = $melee_hitbox

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var hp = 100
var direction : Vector2
var already_flipped = true
var knockback_force = 0
var knockback_decay_speed = 30

func _process(delta):
	if player:
		direction = player.global_position - global_position
	
	if direction.x < 0:
		if not already_flipped:
			sprite.flip_h = false
			melee_hitbox.position.x *= -1
			already_flipped = true
	else:
		if already_flipped:
			sprite.flip_h = true
			melee_hitbox.position.x *= -1
			already_flipped = false
			
func _physics_process(delta):
	if knockback_force <= 0:
		velocity = direction.normalized() * 40
	else:
		velocity = -direction.normalized() * knockback_force
		knockback_force -= knockback_decay_speed
	
	move_and_collide(velocity * delta)
	
func take_damage(damage):
	hp -= damage
	
	if hp <= 0:
		queue_free()

func apply_knockback(knockback_value):
	knockback_force += knockback_value
	
