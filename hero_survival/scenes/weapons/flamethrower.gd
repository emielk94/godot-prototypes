extends Node2D

@onready var reload_timer = $reload_timer
@onready var sprite = $Sprite2D
@onready var particles = $CPUParticles2D
@onready var fire_cd_timer = $fire_cd
@onready var hud = get_node("/root/world/hud")
@onready var gun_sfx = preload("res://sfx/gunshot.ogg")
@onready var flamethrower_hitbox = $flamethrower_hitbox
@onready var dps_timer = $dps_timer
@onready var queue_free_timer = $queue_free_timer
@onready var fire_scene = preload("res://scenes/fire.tscn")

signal update_hud

var clip_size : int= 100
var sfx_db = 0
var remaining_bullets: int=0
var reload_time : int = 3
var fire_rate : float = 0.05
var knockback_str : float = 0
var draw_offset : int = 0
var damage : int = 50
var range : float = 200
var can_shoot : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("update_hud", hud.update)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	if ((mouse_pos - global_position).length() > 30):
		rotation = (mouse_pos - global_position).angle()
		if mouse_pos.x > owner.global_position.x:
			sprite.flip_v = false
		else:
			sprite.flip_v = true

func shoot():
	if owner.is_reloading or !can_shoot:
		return
		
	particles.emitting = true
	if !flamethrower_hitbox.monitoring:
		flamethrower_hitbox.monitoring = true
		dps_timer.start() 
	
	if remaining_bullets > 0:
		remaining_bullets -= 1
		owner.ammo[name]["remaining_bullets"] = remaining_bullets
		can_shoot = false
		fire_cd_timer.wait_time = fire_rate
		fire_cd_timer.start()
		
		#play_audio(sfx_db)
				
		emit_signal("update_hud") 
	else:
		reload()
		
	await get_tree().process_frame
	
func reload():
	if owner.is_reloading:
		return
		
	if owner.ammo[name]["total"] != 0 and remaining_bullets != clip_size:
		particles.emitting = false
		owner.is_reloading = true
		reload_timer.start()
		print(reload_timer.owner.name)

func play_audio(db=0):
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.global_position = global_position
	audio_player.stream = gun_sfx
	audio_player.volume_db = sfx_db
	get_tree().current_scene.add_child(audio_player)
	audio_player.play()
	
func finish_reload():
	owner.is_reloading = false
	owner.reload_bar.set_value(reload_timer.time_left)
	owner.reload_bar.hide() # Replace with function body.
	var bullet_count = clip_size - remaining_bullets
	
	if owner.ammo[name]["total"] >= bullet_count:
		owner.ammo[name]["total"] -= bullet_count
		remaining_bullets = clip_size
		owner.ammo[name]["remaining_bullets"] = remaining_bullets
	else:
		remaining_bullets += owner.ammo[name]["total"]
		owner.ammo[name]["total"] = 0
		owner.ammo[name]["remaining_bullets"] = remaining_bullets
	
	emit_signal("update_hud") 


func _on_fire_cd_timeout() -> void:
	can_shoot = true # Replace with function body.

func _on_reload_timer_timeout() -> void:
	finish_reload() # Replace with function body.

func _on_dps_timer_timeout() -> void:
	var bodies = flamethrower_hitbox.get_overlapping_bodies()
	for body in bodies:
		if body.has_node("fire"):
			pass
		else:
			var fire_instance = fire_scene.instantiate()
			body.add_child(fire_instance)
			var fire_node = body.get_node("fire")
			fire_node.set_owner(body)

			
		body.take_damage(4) # Replace with function body.
