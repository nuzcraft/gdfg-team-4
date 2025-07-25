extends GutTest

var level1_scene := preload('res://scenes/levels/level1.tscn')

func test_level1_scene_loads():
	var level = level1_scene.instantiate()
	get_tree().current_scene.name = level.name
	add_child_autofree(level)
	await get_tree().process_frame
	# has level
	assert_true(level is Node, "level scene failed to load")
	# has hero
	var hero = level.get_node('Hero')
	assert_true(hero.get_scene_file_path() == 'res://scenes/hero.tscn')
	assert_true(hero is Hero, 'hero is not of class Hero')
	# cleanup
	get_tree().current_scene.name = ''
