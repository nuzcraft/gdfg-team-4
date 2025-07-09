extends Node


var player_pos: Vector2
var player_vulnerable: bool = true
var player_health: int = 100
var player_max_health: int = 100
var player_armor: int = 0
var player_max_armor: int = 100


func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true
