extends CharacterBody2D

@onready var particles = $particles

var direction : Vector2

func _physics_process(delta: float) -> void:
	
	move_and_slide()


func _on_explode_timer_timeout() -> void:
	particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()
