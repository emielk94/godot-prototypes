extends Node2D
class_name Gun

@onready var reload_timer = $reload_timer

var clip_size : int= 12
var remaining_bullets: int=0
var reload_time : int = 3
var fire_rate : float = 0.5
var knockback_str : float = 0
var draw_offset : int = 0
var damage : int = 50
var range : float = 200
var can_shoot : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reload():
	print(owner.ammo[name]["total"] != 0)
	print(remaining_bullets != clip_size)
	if owner.ammo[name]["total"] != 0 and remaining_bullets != clip_size:
		reload_timer.start()
		print(reload_timer.owner.name)
		
func finish_reload():
	owner.reload_bar.set_value(reload_timer.time_left)
	owner.reload_bar.hide() # Replace with function body.
	var bullet_count = clip_size - remaining_bullets
	
	if owner.ammo[name]["total"] >= bullet_count:
		owner.ammo[name]["total"] -= bullet_count
		remaining_bullets = clip_size
		owner.ammo[name]["remaining_bullets"] = remaining_bullets
	else:
		remaining_bullets += owner.ammo[name]["total"]
		owner.ammo[name]["total"] = 0
		owner.ammo[name]["remaining_bullets"] = remaining_bullets
