extends CharacterBody2D

@onready var player_sprite = $AnimatedSprite2D
@onready var gun_pos = $gun_pos
@onready var gun = $gun_pos.get_child(0)
@onready var reload_bar = $ReloadBar
@onready var player = get_parent().find_child("player")
@onready var hud = get_node("/root/world/hud")
@onready var grenade_scene = preload("res://grenade.tscn")

var reset = false
var health = 100
var is_dead = false
var is_reloading = false
const speed = 300.0
const JUMP_VELOCITY = -400.0
var direction : Vector2
var inventory = []

signal update_hud

var guns = {
"pistol": preload("res://scenes/weapons/pistol.tscn"),
"flamethrower": preload("res://scenes/weapons/flamethrower.tscn"),
"shotgun": preload("res://scenes/weapons/shotgun.tscn"),
"minigun": preload("res://scenes/weapons/minigun.tscn"),
"sniper": preload("res://scenes/weapons/sniper.tscn")
}

var ammo = {
	"pistol": {"total": 20, "remaining_bullets": 12},
	"flamethrower": {"total": 100, "remaining_bullets": 100},
	"shotgun": {"total": 20, "remaining_bullets": 5},
	"minigun": {"total": 200, "remaining_bullets": 100},
	"sniper": {"total": 15, "remaining_bullets": 5}
}


func _ready() -> void:
	add_weapon_to_inventory("pistol")
	add_weapon_to_inventory("flamethrower")
	add_weapon_to_inventory("sniper")
	add_weapon_to_inventory("shotgun")
	gun_pos.add_child(guns[inventory[0]].instantiate())
	gun_pos.get_child(0).set_owner(self)
	gun = gun_pos.get_child(0)
	gun.remaining_bullets = ammo[gun.name]["remaining_bullets"]
	
	connect("update_hud", hud.update)
	
func _process(delta: float) -> void:
	if !is_dead:
			var mouse_position = get_global_mouse_position()
			var angle_to_mouse = (mouse_position - global_position).angle()
			var offset = Vector2(gun.draw_offset, 0).rotated(angle_to_mouse)
			
			gun_pos.global_position = global_position + offset
			
			handle_weapon_switch()
				
			if Input.is_action_just_pressed("reload"):
				reload()
			
			if Input.is_action_just_pressed("grenade_slot"):
				throw_grenade(mouse_position - global_position)
				
				
			direction = Input.get_vector("left","right","up","down")
			if Input.is_action_pressed("shoot"):
				gun.shoot()
			elif gun.particles != null:
				if gun.particles.emitting == true:
					gun.particles.emitting = false
					gun.flamethrower_hitbox.monitoring = false
					gun.dps_timer.stop()
									
			var mouse_pos = get_global_mouse_position()
			
			if direction:
				player_sprite.play("walk")
			else:
				player_sprite.play("idle")
				
			if mouse_pos.x > global_position.x:
				player_sprite.flip_h = true
			else:
				player_sprite.flip_h = false

func handle_weapon_switch():
	for i in range(3): # Adjust the range if you have more slots
		if Input.is_action_just_pressed("weapon_slot_" + str(i + 1)):
			equip_weapon(i)
			
func add_weapon_to_inventory(name):
	inventory.append(name)
	
func reload():
	await gun.reload()
	
func throw_grenade(dir):
	var grenade_instance = grenade_scene.instantiate()
	grenade_instance.position = position
	grenade_instance.direction = dir
	
	get_tree().current_scene.add_child(grenade_instance)
	
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
	if !is_dead:
		health -= damage
		if health <= 0:
			die()
	
func die():
	is_dead = true
	var tween = create_tween()
	
	tween.tween_property(self, "modulate:a", 0, 0.5)
	await tween.finished
	queue_free()
	
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
