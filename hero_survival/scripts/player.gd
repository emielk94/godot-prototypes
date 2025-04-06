extends CharacterBody2D

@onready var player_sprite = $AnimatedSprite2D
@onready var gun_pos = $gun_pos
@onready var gun = $gun_pos.get_child(0)
var pistol = preload("res://scenes/weapons/pistol.tscn")

const speed = 300.0
const JUMP_VELOCITY = -400.0
var direction
var inventory = []

func _ready() -> void:
	inventory.append(pistol)
	inventory.append(pistol)
	
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var angle_to_mouse = (mouse_position - global_position).angle()
	var offset = Vector2(gun.draw_offset, 0).rotated(angle_to_mouse)
	
	gun_pos.global_position = global_position + offset
	
	if Input.is_action_just_pressed("weapon_slot_1"):
		equip_weapon(0)
	if Input.is_action_just_pressed("weapon_slot_2"):
		equip_weapon(1)
		await get_tree().process_frame
		gun.fire_rate = 0.01
		
	direction = Input.get_vector("left","right","up","down")
	if Input.is_action_pressed("shoot"):
		gun.shoot()
			
	var mouse_pos = get_global_mouse_position()
	
	if direction:
		player_sprite.play("walk")
	else:
		player_sprite.play("idle")
		
	if mouse_pos.x > global_position.x:
		player_sprite.flip_h = true
	else:
		player_sprite.flip_h = false
		
func _physics_process(delta: float) -> void:
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func equip_weapon(index):
	gun_pos.get_child(0).queue_free()
	await get_tree().process_frame
	var new_weapon = inventory[index].instantiate()
	gun_pos.add_child(new_weapon)
	gun_pos.get_child(0).set_owner(self)
	gun = gun_pos.get_child(0)
