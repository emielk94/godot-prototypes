extends Node2D

@onready var hitbox = $Area2D
@onready var player = get_parent().find_child("player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.add_ammo() # Replace with function body.
	queue_free()
