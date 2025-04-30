extends CanvasLayer

@onready var ammo = $ammo_label
@onready var player = get_parent().find_child("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo.text = "%d / %d" % [player.ammo[player.gun.name]["remaining_bullets"], player.ammo[player.gun.name]["total"]]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update():
	print("received")
	ammo.text = "%d / %d" % [player.ammo[player.gun.name]["remaining_bullets"], player.ammo[player.gun.name]["total"]]
