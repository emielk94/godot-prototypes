extends Timer

@onready var player = get_tree().current_scene.find_child("player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_stopped():
		player.reload_bar.set_value((wait_time - time_left) / wait_time * 100)
