extends Node2D
class_name Gun

var clip_size : int= 12
var reload_time : float = 3
var fire_rate : float = 0.5
var knockback_str : float = 0
var draw_offset : int = 0
var damage : int = 50
var range : float = 200
var can_shoot : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
