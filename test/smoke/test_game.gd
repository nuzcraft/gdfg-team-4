extends GutTest

var game_scene := preload('res://scenes/game.tscn')
var game

func before_each():
	game = game_scene.instantiate()

func after_each():
	game.queue_free()

func test_game_scene_loads():
	# has game
	assert_true(game is Node, "Game scene failed to load")
	# has hero
	var hero = game.get_node('Hero')
	assert_true(hero.get_scene_file_path() == 'res://scenes/hero.tscn')
	# has ground and deocration layers
	var ground = game.get_node('TileMapLayers/GroundLayer')
	var decoration = game.get_node('TileMapLayers/DecorationLayer')
	assert_true(ground is TileMapLayer, 'Ground layer failed to load')
	assert_true(decoration is TileMapLayer, 'Decoration layer failed to load')
