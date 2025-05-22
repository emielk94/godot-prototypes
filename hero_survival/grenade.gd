extends CharacterBody2D

@onready var particles = $particles
var speed = 500

var direction : Vector2
func _ready():
	velocity = Vector2(50,50)
	
func _physics_process(delta: float) -> void:
	if speed >= 5:
		speed -= 5
		
	print(speed)
	velocity = direction.normalized() * speed
	move_and_slide()

func _on_explode_timer_timeout() -> void:
	$Sprite2D.visible = false
	particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()
