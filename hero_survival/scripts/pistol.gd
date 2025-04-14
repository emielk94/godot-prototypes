extends Gun

@onready var raycast = $RayCast2D
@onready var sprite = $sprite
@onready var fire_cd_timer = $fire_cd
@onready var reload_timer = $reload_timer

var gunshot = preload("res://sfx/gunshot.ogg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = 10
	draw_offset = 20 # Replace with function body.
	knockback_str = 200
	reload_time = 2
	reload_timer.wait_time = reload_time
	fire_rate = 0.5
	fire_cd_timer.wait_time = fire_rate
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	var raycast_global_target = global_position + direction * 1000
	raycast.target_position = raycast.to_local(raycast_global_target)
	
	if ((mouse_pos - global_position).length() > 30):
		rotation = (mouse_pos - global_position).angle()
		if mouse_pos.x > owner.global_position.x:
			sprite.flip_v = false
		else:
			sprite.flip_v = true
			
func shoot():
	if can_shoot:
		if remaining_bullets > 0:
			remaining_bullets -= 1
			owner.ammo[name]["remaining_bullets"] = remaining_bullets
			can_shoot = false
			fire_cd_timer.wait_time = fire_rate
			fire_cd_timer.start()
			
			play_audio()
			
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider && collider.is_in_group("enemies"):
					collider.take_damage(damage)
					collider.apply_knockback(knockback_str)
		else:
			reload()

func reload():
	if owner.ammo[name]["total"] != 0 and remaining_bullets != clip_size:
		reload_timer.start()
	
func play_audio():
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.global_position = global_position
	audio_player.stream = gunshot
	get_tree().current_scene.add_child(audio_player)
	audio_player.play()

func _on_fire_cd_timeout() -> void:
	can_shoot = true # Replace with function body.

func _on_reload_timer_timeout() -> void:
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
		
	print(owner.ammo["pistol"])
