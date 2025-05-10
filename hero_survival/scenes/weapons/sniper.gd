extends Gun

@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = 90
	draw_offset = 20 # Replace with function body.
	knockback_str = 500
	reload_time = 2
	reload_timer.wait_time = reload_time
	fire_rate = 1
	fire_cd_timer.wait_time = fire_rate
	
	connect("update_hud", hud.update)

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
