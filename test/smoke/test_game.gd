extends GutTest

var level1_scene := preload('res://scenes/levels/level1.tscn')
var level2_scene := preload('res://scenes/levels/level2.tscn')
var level3_scene := preload('res://scenes/levels/level3.tscn')

func test_level1_scene_loads():
	var level = level1_scene.instantiate()
	add_child_autofree(level)
	await get_tree().process_frame
	# has level
	assert_true(level is Node, "level scene failed to load")
	# has hero
	var hero = level.get_node('Hero')
	assert_true(hero.get_scene_file_path() == 'res://scenes/hero.tscn')
	assert_true(hero is Hero, 'hero is not of class Hero')
	# has ground and deocration layers
	var ground = level.get_node('TileMapLayers/GroundLayer')
	var decoration = level.get_node('TileMapLayers/DecorationLayer')
	assert_true(ground is TileMapLayer, 'Ground layer failed to load')
	assert_true(decoration is TileMapLayer, 'Decoration layer failed to load')

func test_level2_scene_loads():
	var level = level2_scene.instantiate()
	add_child_autofree(level)
	await get_tree().process_frame
	# has level
	assert_true(level is Node, "level scene failed to load")
	# has hero
	var hero = level.get_node('Hero')
	assert_true(hero.get_scene_file_path() == 'res://scenes/hero.tscn')
	assert_true(hero is Hero, 'hero is not of class Hero')
	# has ground and deocration layers
	var ground = level.get_node('TileMapLayers/GroundLayer')
	var decoration = level.get_node('TileMapLayers/DecorationLayer')
	assert_true(ground is TileMapLayer, 'Ground layer failed to load')
	assert_true(decoration is TileMapLayer, 'Decoration layer failed to load')

func test_level3_scene_loads():
	var level = level3_scene.instantiate()
	add_child_autofree(level)
	await get_tree().process_frame
	# has level
	assert_true(level is Node, "level scene failed to load")
	# has hero
	var hero = level.get_node('Hero')
	assert_true(hero.get_scene_file_path() == 'res://scenes/hero.tscn')
	assert_true(hero is Hero, 'hero is not of class Hero')
	# has ground and deocration layers
	var ground = level.get_node('TileMapLayers/GroundLayer')
	var decoration = level.get_node('TileMapLayers/DecorationLayer')
	assert_true(ground is TileMapLayer, 'Ground layer failed to load')
	assert_true(decoration is TileMapLayer, 'Decoration layer failed to load')
