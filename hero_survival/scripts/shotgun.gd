extends Gun

@onready var sprite = $Sprite2D
@onready var raycasts = [$R1,$R2,$R3,$R4,$R5]

#@onready var particles = $CPUParticles2D
var max_spread_degrees = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	gun_sfx = preload("res://sfx/shotgun.wav") # Replace with function body.
	range = 1000
	damage = 15
	knockback_str = 200
	clip_size = 5
	reload_time = 2
	reload_timer.wait_time = reload_time
	fire_rate = 0.5
	fire_cd_timer.wait_time = fire_rate
	
	connect("update_hud", Callable(hud, "update"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	var raycast_global_target = raycasts[0].global_position + direction * 1000
	raycasts[0].target_position = raycasts[0].to_local(raycast_global_target)
	
	rotation = (mouse_pos - global_position).angle()
	
	if mouse_pos.x > owner.global_position.x:
		sprite.flip_v = false
	else:
		sprite.flip_v = true
	
func _physics_process(delta):
	pass
	
func shoot():
	if can_shoot:
		if remaining_bullets > 0:
			remaining_bullets -= 1
			owner.ammo[name]["remaining_bullets"] = remaining_bullets
			can_shoot = false
			fire_cd_timer.wait_time = fire_rate
			fire_cd_timer.start()
			can_shoot = false
			fire_cd_timer.wait_time = fire_rate
			fire_cd_timer.start()
			#particles.emitting = true
			var mouse_pos = get_global_mouse_position()
			var direction = (mouse_pos - global_position).normalized()
			play_audio()
		
			for i in range(1, 5):
				var random_angle = randf_range(-max_spread_degrees, max_spread_degrees)
				var raycast_global_target = raycasts[i].global_position + direction.rotated(deg_to_rad(random_angle)) * 1000
				raycasts[i].target_position = raycasts[i].to_local(raycast_global_target)
				raycasts[i].force_raycast_update()

			for raycast in raycasts:
				if raycast.is_colliding():
					var collider = raycast.get_collider()
					if collider && collider.is_in_group("enemies"):
						collider.take_damage(damage)
						collider.apply_knockback(knockback_str, owner.position - collider.position)
						
			emit_signal("update_hud") 
		else:
			reload()

func _on_fire_cd_timer_timeout() -> void:
	can_shoot = true # Replace with function body.

func _on_reload_timer_timeout() -> void:
	finish_reload()
