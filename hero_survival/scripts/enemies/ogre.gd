extends CharacterBody2D

@onready var sprite = $animsprite2D
@onready var player = get_parent().find_child("player")
@onready var melee_hitbox = $melee_hitbox

var ammo_scene = preload("res://scenes/ammo.tscn")

const movement_speed = 100
const JUMP_VELOCITY = -400.0

var hp = 100
var is_attacking = false
var player_in_range = false
var direction : Vector2
var already_flipped = true
var knockback_force = 0
var knockback_decay_speed = 30

func _process(delta):
	if player:
		direction = player.global_position - global_position
	
	if direction.x < -20:
		if not already_flipped:
			sprite.flip_h = false
			melee_hitbox.position.x *= -1
			already_flipped = true
	elif direction.x > 20:
		if already_flipped:
			sprite.flip_h = true
			melee_hitbox.position.x *= -1
			already_flipped = false
			
func _physics_process(delta):
	if knockback_force <= 0:
		if !is_attacking:
			velocity = direction.normalized() * movement_speed
	else:
		velocity = -direction.normalized() * knockback_force
		knockback_force -= knockback_decay_speed

	move_and_collide(velocity * delta)
	
func take_damage(damage):
	hp -= damage
	
	if hp <= 0:
		die()
		
func drop_item():
	var ammo_instance = ammo_scene.instantiate()
	ammo_instance.position = position
	get_tree().current_scene.add_child(ammo_instance)
	
func die():
	var random_number = randi() % 3
	if random_number == 0:
		print("drop")
		drop_item()
	queue_free()
	
func apply_knockback(knockback_value):
	knockback_force += knockback_value

func attack():
	velocity = Vector2.ZERO
	is_attacking = true
	sprite.play("attack")
	 
func _on_animsprite_2d_frame_changed() -> void:
	if sprite.animation == "attack":
		if sprite.frame == 3:
			for body in melee_hitbox.get_overlapping_bodies():
				if body.name == "player":
					body.take_damage(10)

func _on_animsprite_2d_animation_finished() -> void:
	if sprite.animation == "attack" && !player_in_range:
		is_attacking = false
		sprite.play("walk")
	else:
		attack()

func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	if body == player:
		attack()
		player_in_range = true

func _on_melee_hitbox_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_range = false
