extends Node2D

@onready var hitbox = $Area2D
@onready var player = get_parent().find_child("player")

var wave_amplitude = 5.0 # Height of the wave
var wave_speed = 2.0      # Speed of the wave
var original_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = original_position.y + sin(Time.get_ticks_msec() / 1000.0 * wave_speed) * wave_amplitude

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.add_ammo() # Replace with function body.
	queue_free()
