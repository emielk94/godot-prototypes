extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_damage_timer_timeout() -> void:
	owner.take_damage(5) # Replace with function body.

func _on_queue_free_timer_timeout() -> void:
	queue_free() # Replace with function body.
