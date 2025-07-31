extends Node

signal screenshake (amount)
signal collected (type)
signal acid_aoe (position, scaling)
signal lava_aoe (position, scaling)
signal ice_aoe (position, scaling)
signal enemy_died (type, scaling)


var player_pos: Vector2
var player_vulnerable: bool = true
var player_health: int = 100
var player_max_health: int = 100
var player_armor: int = 0
var player_max_armor: int = 100
var crystals_collected: int = 0
var enemies_killed: int = 0

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true

func add_screenshake(amount: float):
	screenshake.emit(amount)

func collectable_collected(type: String) -> void:
	collected.emit(type)
	if type == "crystal":
		crystals_collected += 1

func place_acid_aoe(position: Vector2, scaling: float) -> void:
	acid_aoe.emit(position, scaling)

func place_lava_aoe(position: Vector2, scaling: float) -> void:
	lava_aoe.emit(position, scaling)

func place_ice_aoe(position: Vector2, scaling: float) -> void:
	ice_aoe.emit(position, scaling)
	
func signal_enemy_died(type: String, position: Vector2, scaling: float) -> void:
	enemy_died.emit(type, position, scaling)
