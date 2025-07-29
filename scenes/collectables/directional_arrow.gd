extends Node2D

var hero_node: CharacterBody2D = null
@export var target: Node2D
var distance: float

func _ready():
	hero_node = get_tree().get_first_node_in_group("Hero")

func _process(_delta):
	if hero_node:
		$".".global_position = hero_node.global_position
		$Sprite2D.global_position = $".".global_position
		#$Sprite2D.global_position = hero_node.global_position
	if target != null:
		$Sprite2D.look_at(target.global_position)
		distance = global_position.distance_to(target.global_position)
	if distance < 590:
		$Sprite2D.visible = false
	else: 
		$Sprite2D.visible = true
	
	#keep the position on the player
	#keep the direction to the gem & turn invisible if too close to gem
