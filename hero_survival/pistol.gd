extends Gun

@onready var raycast = $RayCast2D
@onready var sprite = $sprite
@onready var fire_cd_timer = $fire_cd

#var gunshot = preload("res://sfx/gunshot.ogg")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_offset = 30 # Replace with function body.
	fire_rate = 0.1
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
		can_shoot = false
		fire_cd_timer.start()
		
		play_audio()
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider && collider.is_in_group("enemies"):
				collider.take_damage(damage)

func play_audio():
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.global_position = global_position
	#audio_player.stream = gunshot
	get_tree().current_scene.add_child(audio_player)
	audio_player.play()

func _on_fire_cd_timeout() -> void:
	can_shoot = true # Replace with function body.
