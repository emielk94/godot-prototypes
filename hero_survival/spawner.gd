extends Node2D

var enemy_scenes = {"ogre": preload("res://scenes/enemies/ogre.tscn")}
@onready var player = owner.find_child("player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn(x,y, isRandomPos, count, enemy_type):
	for i in range(count):
		var xpos = randi() % 1000
		var ypos = randi() % 1000
		
		var ogre_instance = enemy_scenes[enemy_type].instantiate()
		if isRandomPos:
			var direction = get_random_direction_2d() 
			print(direction)
			ogre_instance.position = player.position + direction * 300
		else:
			ogre_instance.position = Vector2(x, y) 
	
		get_tree().current_scene.add_child(ogre_instance)

func get_random_direction_2d() -> Vector2:
	var angle = randf() * TAU  # TAU is 2 * PI
	return Vector2(cos(angle), sin(angle))
