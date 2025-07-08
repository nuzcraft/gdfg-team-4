extends Node


var player_pos: Vector2
var player_vulnerable: bool = true
var player_health: int
var player_max_health: int
var player_armor: int
var player_max_armor: int


func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true
