extends Node2D
class_name Gun

@onready var reload_timer = $reload_timer
@onready var fire_cd_timer = $fire_cd
@onready var raycast = $RayCast2D
@onready var hud = get_node("/root/world/hud")
@onready var gun_sfx = preload("res://sfx/gunshot.ogg")

signal update_hud

var clip_size : int= 12
var sfx_db = 0
var remaining_bullets: int=0
var reload_time : int = 3
var fire_rate : float = 0.5
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
	pass

func shoot():
	if owner.is_reloading or !can_shoot:
		return
		
	if remaining_bullets > 0:
		remaining_bullets -= 1
		owner.ammo[name]["remaining_bullets"] = remaining_bullets
		can_shoot = false
		fire_cd_timer.wait_time = fire_rate
		fire_cd_timer.start()
		
		play_audio(sfx_db)
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider && collider.is_in_group("enemies"):
				collider.take_damage(damage)
				collider.apply_knockback(knockback_str,(owner.position - collider.position))
				
		emit_signal("update_hud") 
	else:
		reload()
	
func reload():
	if owner.is_reloading:
		return
		
	if owner.ammo[name]["total"] != 0 and remaining_bullets != clip_size:
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
