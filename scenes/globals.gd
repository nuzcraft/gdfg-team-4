extends Node

signal screenshake (amount)
signal collected (type)
signal acid_aoe (position, scaling)
signal lava_aoe (position, scaling)
signal ice_aoe (position, scaling)
signal enemy_died (type, scaling)

enum WeaponEnum {
	PLASMA_RIFLE,
	SHOTGUN,
	MACHINE_GUN
}
var inventory = [true,false,false]
var damage_upgrades: int = 0
var firerate_upgrades: int = 0

var primary_weapon: WeaponEnum = WeaponEnum.PLASMA_RIFLE
var player_pos: Vector2
var player_vulnerable: bool = true
var player_health: int = 100
var player_max_health: int = 100
var player_armor: int = 0
var player_max_armor: int = 100
var crystals_collected: int = 0
var crystals_spent: int = 0
var enemies_killed: int = 0
var current_level: int = 1

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true

func add_screenshake(amount: float):
	screenshake.emit(amount)

func collectable_collected(type: String) -> void:
	if type == "crystal":
		crystals_collected += 1
	collected.emit(type)

func place_acid_aoe(position: Vector2, scaling: float) -> void:
	acid_aoe.emit(position, scaling)

func place_lava_aoe(position: Vector2, scaling: float) -> void:
	lava_aoe.emit(position, scaling)

func place_ice_aoe(position: Vector2, scaling: float) -> void:
	ice_aoe.emit(position, scaling)
	
func signal_enemy_died(type: String, position: Vector2, scaling: float) -> void:
	enemy_died.emit(type, position, scaling)

func reset_globals():
	inventory = [true,false,false]
	damage_upgrades = 0
	firerate_upgrades = 0

	primary_weapon = WeaponEnum.PLASMA_RIFLE
	player_pos
	player_vulnerable = true
	player_health = 100
	player_max_health = 100
	player_armor = 0
	player_max_armor = 100
	crystals_collected = 0
	crystals_spent = 0
	enemies_killed = 0
	current_level = 1
