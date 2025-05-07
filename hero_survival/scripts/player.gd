extends CharacterBody2D

@onready var player_sprite = $AnimatedSprite2D
@onready var gun_pos = $gun_pos
@onready var gun = $gun_pos.get_child(0)
@onready var reload_bar = $ReloadBar
@onready var player = get_parent().find_child("player")
@onready var hud = get_node("/root/world/hud")

var health = 100
var is_reloading = false
const speed = 300.0
const JUMP_VELOCITY = -400.0
var direction : Vector2
var inventory = []

signal update_hud

var guns = {
"pistol": preload("res://scenes/weapons/pistol.tscn"),
"shotgun": preload("res://scenes/weapons/shotgun.tscn"),
"minigun": preload("res://scenes/weapons/minigun.tscn")
}

var ammo = {
	"pistol": {"total": 20, "remaining_bullets": 12},
	"shotgun": {"total": 20, "remaining_bullets": 5},
	"minigun": {"total": 200, "remaining_bullets": 100}
}


func _ready() -> void:
	add_weapon_to_inventory("pistol")
	add_weapon_to_inventory("shotgun")
	add_weapon_to_inventory("minigun")
	gun_pos.add_child(guns[inventory[0]].instantiate())
	gun_pos.get_child(0).set_owner(self)
	gun = gun_pos.get_child(0)
	gun.remaining_bullets = ammo[gun.name]["remaining_bullets"]
	
	connect("update_hud", hud.update)
	
func _process(delta: float) -> void:
	print(is_reloading)
	var mouse_position = get_global_mouse_position()
	var angle_to_mouse = (mouse_position - global_position).angle()
	var offset = Vector2(gun.draw_offset, 0).rotated(angle_to_mouse)
	
	gun_pos.global_position = global_position + offset
	
	if Input.is_action_just_pressed("weapon_slot_1"):
		equip_weapon(0)
	if Input.is_action_just_pressed("weapon_slot_2"):
		equip_weapon(1)
	if Input.is_action_just_pressed("weapon_slot_3"):
		equip_weapon(2)
		
	if Input.is_action_just_pressed("reload"):
		reload()
		
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
		
func add_weapon_to_inventory(name):
	inventory.append(name)
	
func reload():
	await gun.reload()

func add_ammo():
	print(ammo[gun.name]["total"])
	ammo[gun.name]["total"] += 50
	print(ammo[gun.name]["total"])
	emit_signal("update_hud") 
	
func _physics_process(delta: float) -> void:
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func take_damage(damage):
	health -= damage
	print(health)
	
func equip_weapon(index):
	if index <= inventory.size() -1:
		gun_pos.get_child(0).queue_free()
		await get_tree().process_frame
		var new_weapon = guns[inventory[index]].instantiate()
		new_weapon.remaining_bullets = ammo[new_weapon.name]["remaining_bullets"]
		gun_pos.add_child(new_weapon)
		gun_pos.get_child(0).set_owner(self)
		gun = gun_pos.get_child(0)
		reload_bar.set_value(0)
		is_reloading = false
		emit_signal("update_hud")
