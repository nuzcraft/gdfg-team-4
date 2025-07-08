extends Node2D

var lava_aoe_scene = preload("res://scenes/aoes/lava_aoe.tscn")

func _ready():
	Globals.player_health = 100

func create_lava_aoe(pos):
	var aoe = lava_aoe_scene.instantiate() as Area2D
	aoe.position = pos
	aoe.is_in_group("FireArea")
	$AOEs.add_child(aoe)

func _on_proto_lava_ant_lava_aoe(pos):
	create_lava_aoe(pos)
