extends CharacterBody2D

@onready var particles = $particles
@onready var explosion_hitbox = $explosion_hitbox
var speed = 500
var decay_speed = 10

var direction : Vector2
func _ready():
	velocity = Vector2(50,50)

func explode():
	for body in explosion_hitbox.get_overlapping_bodies():
		print(body.name)
		if body.is_in_group("enemies"):
			body.take_damage(100)
			
	$Sprite2D.visible = false
	particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()
					
					
func _physics_process(delta: float) -> void:
	if speed >= decay_speed:
		speed -= decay_speed
		
	print(speed)
	velocity = direction.normalized() * speed
	move_and_slide()

func _on_explode_timer_timeout() -> void:
	explode()
