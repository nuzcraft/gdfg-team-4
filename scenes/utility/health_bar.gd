extends Control

@onready var health_bar = $Health
@onready var armor_bar = $Armor

var last_health: int = Globals.player_health
var last_armor: int = Globals.player_armor

func _process(_delta: float) -> void:
	var curr_health = Globals.player_health
	var curr_armor = Globals.player_armor
	if last_health != curr_health:
		health_bar.material.set_shader_parameter('health', float(curr_health / 100.0))
		last_health = curr_health
	if last_armor != curr_armor:
		armor_bar.material.set_shader_parameter('armor', float(curr_armor / 100.0))
		last_armor = curr_armor
		
	# add code to handle rendering extra health bars
	# if Globals.player_max_health > 100
