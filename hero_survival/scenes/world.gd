extends Node2D

@onready var spawner = $spawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner.spawn(100,100, true, 5) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
