extends Control

@onready var health_bar = $Health
@onready var armor_bar = $Armor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var last_health: int = Globals.player_health
var last_armor: int = Globals.player_armor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var curr_health = Globals.player_health
	var curr_armor = Globals.player_armor
	
	if last_health != curr_health:
		health_bar.material.set_shader_parameter('health', float(curr_health / 100.0))
		last_health = curr_health
	if last_armor != curr_armor:
		armor_bar.material.set_shader_parameter('armor', float(curr_health / 100.0))
		last_armor = curr_armor
		
	# add code to handle rendering extra health bars
	# if Globals.player_max_health > 100
