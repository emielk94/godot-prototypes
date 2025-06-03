extends Node2D

@onready var phrase_label = $CanvasLayer/phrase_label
@onready var next_button = $CanvasLayer/next_button
@onready var timer_label = $CanvasLayer/timer_label
@onready var countdown_player = $countdown
@onready var countdown_finished = $countdown_finished
@onready var timer = $Timer
@onready var team1_label = $CanvasLayer/team1_label
@onready var team2_label = $CanvasLayer/team2_label
var time = 15.0
var index = 0
var team1_points = 0
var team2_points = 0

var things = [
	"Things that are colorful = Coisas que são coloridas",
	"Things that are heavy = Coisas que são pesadas",
	"Things that are shiny = Coisas que são brilhantes",
	"Things that are small = Coisas que são pequenas",
	"Things that are scary = Coisas que são assustadoras",
	"Things that are strong = Coisas que são fortes",
	"Things that are sticky = Coisas que são pegajosas",
	"Things that are useful = Coisas que são úteis",
	"Things that are big = Coisas que são grandes",
	"Things that are fast = Coisas que são rápidas",
	"Things that are loud = Coisas que são barulhentas",
	"Things that are round = Coisas que são redondas",
	"Things that are fragile = Coisas que são frágeis",
	"Things that are cold = Coisas que são frias",
	"Things that are light = Coisas que são leves",
	"Things that are soft = Coisas que são macias",
	"Things that are slow = Coisas que são lentas",
	"Things that are expensive = Coisas que são caras",
	"Things that are hot = Coisas que são quentes"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = time # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !timer.is_stopped():
		timer_label.text = str(round(timer.time_left))
		
func _on_button_pressed() -> void:
	phrase_label.text = things[index]
	index += 1 # Replace with function body.

func _on_button_2_pressed() -> void:
	countdown_player.play(0.2)
	timer.start() # Replace with function body.
	
func _on_timer_timeout() -> void:
	countdown_finished.play(1.0) # Replace with function body.

func _on_team_1_button_pressed() -> void:
	team1_points += 1
	team1_label.text = "Team 1: " + str(team1_points) # Replace with function body.

func _on_team_2_button_pressed() -> void:
	team2_points += 1
	team2_label.text = "Team 2: " + str(team2_points) # Replace with function body.
