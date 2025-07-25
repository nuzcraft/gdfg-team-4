extends GutTest

var title_scene := preload('res://scenes/utility/title.tscn')
var title

func before_each():
	title = title_scene.instantiate()
	add_child_autofree(title)
	await get_tree().process_frame

func test_title_scene_loads():
	# has title
	assert_true(title is Control, "Title scene failed to load")
	# title is correct
	var title_text = title.get_node('VBoxContainer/CenterContainer/VBoxContainer/TitleLabel')
	assert_true(title_text is Label, 'Title node failed to load')
	assert_eq(title_text.text, 'Swarmed!', 'Title text is not correct')
	# has buttons
	var play_button = title.get_node('VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/PlayButton')
	var settings_button = title.get_node('VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/SettingsButton')
	var exit_button = title.get_node('VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/ExitButton')
	assert_true(play_button is Button, 'Play button failed to load')
	assert_true(settings_button is Button, 'Play button failed to load')
	assert_true(exit_button is Button, 'Play button failed to load')
