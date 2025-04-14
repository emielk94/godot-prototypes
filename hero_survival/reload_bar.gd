extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Replace with function body.

func set_value(value):
	$TextureProgressBar.value = value
	if value >= 0:
		show()
	else:
		hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
