extends Node2D

var ogre = preload("res://scenes/enemies/ogre.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn(x,y, isRandomPos, count):
	for i in range(count):
		var xpos = randi() % 1000
		var ypos = randi() % 1000
		
		var ogre_instance = ogre.instantiate()
		if isRandomPos:
			ogre_instance.position = Vector2(xpos, ypos) 
		else:
			ogre_instance.position = Vector2(x, y) 
	
		get_tree().current_scene.add_child(ogre_instance)
