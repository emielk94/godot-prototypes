extends Gun


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = 10
	draw_offset = 20 # Replace with function body.
	knockback_str = 200
	reload_time = 2
	reload_timer.wait_time = reload_time
	fire_rate = 0.5
	fire_cd_timer.wait_time = fire_rate
	
	connect("update_hud", hud.update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
