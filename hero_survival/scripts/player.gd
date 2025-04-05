extends CharacterBody2D

@onready var player_sprite = $AnimatedSprite2D
@onready var gun_pos = $gun_pos
@onready var gun = $gun_pos.get_child(0)

const speed = 300.0
const JUMP_VELOCITY = -400.0
var direction


func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var angle_to_mouse = (mouse_position - global_position).angle()
	var offset = Vector2(gun.draw_offset, 0).rotated(angle_to_mouse)
	
	gun_pos.global_position = global_position + offset
	
	direction = Input.get_vector("left","right","up","down")
	if Input.is_action_pressed("shoot"):
		gun.shoot()
			
	var mouse_pos = get_global_mouse_position()
	
	if direction:
		player_sprite.play("walk")
	else:
		player_sprite.play("idle")
		
	if mouse_pos.x > global_position.x:
		player_sprite.flip_h = true
	else:
		player_sprite.flip_h = false
		
func _physics_process(delta: float) -> void:
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
