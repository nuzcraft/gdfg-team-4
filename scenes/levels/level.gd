extends Node2D
class_name Level

const TARGET_ROUND_B = preload("res://PlaceholderAssets/target_round_b.svg")
const MAX_LEVELS = 3

var lava_aoe_scene = preload("res://scenes/aoes/lava_aoe.tscn")
const ACID_AOE = preload("res://scenes/aoes/acid_aoe.tscn")
const CRYSTAL = preload("res://scenes/collectables/crystal.tscn")
const SPAWNER = preload("res://scenes/enemies/spawner.tscn")
const LEVEL_1: CompressedTexture2D = preload("res://assets/levels/level1.png")
const LEVEL_2: CompressedTexture2D = preload("res://assets/levels/level2.png")
const LEVEL_3: CompressedTexture2D = preload("res://assets/levels/level3.png")

const LEVELS = [
	"res://scenes/levels/level1.tscn",
	"res://scenes/levels/level2.tscn",
	"res://scenes/levels/level3.tscn"
]

@export var current_level := 0
@export var jungle_ground := false
@export var jungle_wall := false

var num_enemies_spawned = 0
var level_images = {
	"Level1" : LEVEL_1,
	"Level2" : LEVEL_2,
	"Level3" : LEVEL_3,
}

var hero: Hero
var _change_scene:bool = false

func _ready() -> void:
	Input.set_custom_mouse_cursor(TARGET_ROUND_B, 0, Vector2(30, 30))
	for enemy in $Enemies.get_children():
		if enemy is Splitting:
			for splitting_enemy in enemy.get_children():
				splitting_enemy.target = $Hero
				if splitting_enemy is LavaAnt:
					splitting_enemy.connect("lava_aoe", _on_lava_ant_lava_aoe)
		else:
			enemy.target = $Hero
			if enemy is LavaAnt:
				enemy.connect("lava_aoe", _on_lava_ant_lava_aoe)
	trigger_spawners()
	Globals.player_health = 100
	Globals.player_max_health = 100
	Globals.player_armor = 0
	Globals.player_max_armor = 100
	Globals.acid_aoe.connect(_on_acid_aoe)
	if jungle_ground:
		$TileMapLayers/JGroundLayerDual.show()
		$TileMapLayers/GroundLayerDual.hide()
	if jungle_wall:
		$TileMapLayers/JRockWallsDual.show()
		$TileMapLayers/RockWallsDual.hide()
	load_level_from_image()
	hero = get_node('Hero')
	hero.teleport_in()

func _process(_delta):
	if (_enemy_wave_cleared() and not _change_scene):
		_change_scene = true
		_next_level()
	#if Input.is_action_just_pressed("ui_page_down"):
		#_next_level()


func create_lava_aoe(pos, scaling):
	var aoe = lava_aoe_scene.instantiate()
	aoe.position = pos
	aoe.scale = Vector2(scaling, scaling)
	aoe.add_to_group("FireArea")
	#$AOEs/LavaRegion.add_child(aoe)
	$AOEs.add_child(aoe)
	$AoeTextureReplacer.add_sprite(aoe)
	aoe.hide()

func _on_lava_ant_lava_aoe(pos, scaling):
	create_lava_aoe(pos, scaling)

func _on_acid_aoe(pos, scaling) -> void:
	var aoe = ACID_AOE.instantiate()
	aoe.position = pos
	aoe.scale = Vector2(scaling, scaling)
	aoe.add_to_group("AcidArea")
	$AOEs.add_child(aoe)
	$AoeTextureReplacer.add_sprite(aoe)
	aoe.hide()

func _enemy_wave_cleared() -> bool:
	var enemies = $Enemies.get_children()
	if enemies.size() == 0 and num_enemies_spawned > 0:
		return true
	else:
		return false

func _next_level():
	hero.teleport_out()
	await get_tree().create_timer(1.0).timeout
	current_level += 1
	var scene_path
	if current_level > LEVELS.size():
		scene_path = 'res://scenes/utility/title.tscn'
	else:
		scene_path = LEVELS[current_level - 1]
	get_tree().change_scene_to_file(scene_path)

func _on_intro_text_timer_timeout():
	$CanvasLayer/TextOverlay.visible = false

func load_level_from_image() -> void:
	
	var level_name = "Level" + str(current_level)
	if level_images.has(level_name):
		num_enemies_spawned = 0
		var image_file: CompressedTexture2D = level_images[level_name]
		#print("loading level from: ", image_file)
		# remove old enemies and aoes
		for aoe in $AOEs.get_children():
			if aoe is BaseAOE:
				aoe.queue_free()
		for enemy in $Enemies.get_children():
			if enemy is Enemy or enemy is Splitting:
				enemy.queue_free()
		for spawner in get_children():
			if spawner is Spawner:
				spawner.queue_free()
		
		# clear tilemaps
		clear_tilemaps()
		# get image
		var tilemap_image: Image = image_file.get_image()
		var aoe_tilemap_image: Image = image_file.get_image()
		
		# set aoe texture replacer
		$AoeTextureReplacer.set_size(tilemap_image.get_size() * 150)
		$AoeTextureReplacer.create_color_rects()
		$AoeTextureReplacer.update_viewport_texture()

		# set tilemaps from image
		for x in tilemap_image.get_width():
			for y in tilemap_image.get_height():
				var color = tilemap_image.get_pixel(x, y)
				set_tile_map_cell(x, y, color)
				match color:
					Color.BLUE:
						$Hero.position = Vector2(x * 150, y * 150)
						aoe_tilemap_image.set_pixel(x, y, Color.BLACK)
					Color.GREEN:
						var crystal := CRYSTAL.instantiate()
						add_child(crystal)
						crystal.position = Vector2(x * 150, y * 150)
						aoe_tilemap_image.set_pixel(x, y, Color.BLACK)
					Color.RED:
						var spawner:= SPAWNER.instantiate()
						spawner.spawn_scene = spawner.LAVA_ANT
						add_child(spawner)
						spawner.position = Vector2(x * 150, y * 150)
						aoe_tilemap_image.set_pixel(x, y, Color.BLACK)
					Color.MAGENTA:
						var spawner:= SPAWNER.instantiate()
						spawner.spawn_scene = spawner.ACID_SLUG
						add_child(spawner)
						spawner.position = Vector2(x * 150, y * 150)
						aoe_tilemap_image.set_pixel(x, y, Color.BLACK)
					Color.CYAN:
						var spawner:= SPAWNER.instantiate()
						spawner.spawn_scene = spawner.ICE_BEETLE
						add_child(spawner)
						spawner.position = Vector2(x * 150, y * 150)
						aoe_tilemap_image.set_pixel(x, y, Color.BLACK)
					Color.BLACK:
						aoe_tilemap_image.set_pixel(x, y, Color.WHITE)
					_ :
						aoe_tilemap_image.set_pixel(x, y, Color.BLACK)
					
		aoe_tilemap_image.resize(aoe_tilemap_image.get_width() * 4, aoe_tilemap_image.get_height() * 4, Image.INTERPOLATE_NEAREST)
		var list_pixels: Array[Vector2i]
		for x in aoe_tilemap_image.get_width():
			for y in aoe_tilemap_image.get_height():
				var color = aoe_tilemap_image.get_pixel(x, y)
				if color != Color.WHITE:
					if y > 1 and aoe_tilemap_image.get_pixel(x, y - 1) == Color.WHITE:
						list_pixels.append(Vector2i(x, y))
					elif y < aoe_tilemap_image.get_height() and aoe_tilemap_image.get_pixel(x, y + 1) == Color.WHITE:
						list_pixels.append(Vector2i(x, y))
		
		for pixel in list_pixels:
			aoe_tilemap_image.set_pixel(pixel.x, pixel.y, Color.WHITE)
		
		# send the aoe tilemap image to the aoe replacer
		var aoe_tilemap_sprite := Sprite2D.new()
		aoe_tilemap_sprite.texture = ImageTexture.create_from_image(aoe_tilemap_image)
		var node: Node2D = Node2D.new()
		node.add_child(aoe_tilemap_sprite)
		node.scale = Vector2(37.5, 37.5)
		node.position = aoe_tilemap_image.get_size() / 2 * 37.5
		node.hide()
		$AoeTextureReplacer.add_sprite(node)
		
		# trigger enemy spawners
		trigger_spawners()

func clear_tilemaps() -> void:
	for tilemap: TileMapLayer in $TileMapLayers.get_children():
		tilemap.clear()

func set_tile_map_cell(x :int , y: int, color: Color) -> void:
	match color:
		Color.BLACK:
			$TileMapLayers/CollisionWallLayer.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
			$TileMapLayers/RockWallsDual.set_cell(Vector2i(x, y), 0, Vector2i(2, 1))
			$TileMapLayers/JRockWallsDual.set_cell(Vector2i(x, y), 0, Vector2i(2, 1))
		_ :
			$TileMapLayers/CollisionWallLayer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			if randf() < 0.25:
				$TileMapLayers/GroundLayerDual.set_cell(Vector2i(x, y), 0, Vector2(2, 1))
				$TileMapLayers/JGroundLayerDual.set_cell(Vector2i(x, y), 0, Vector2(2, 1))
			else:
				$TileMapLayers/GroundLayerDual.set_cell(Vector2i(x, y), 0, Vector2(0, 3))
				$TileMapLayers/JGroundLayerDual.set_cell(Vector2i(x, y), 0, Vector2(0, 3))

func trigger_spawners():
	for node in get_children():
		if node is Spawner:
			var num_spawn: int = randi_range(node.min_spawn, node.max_spawn)
			for i in num_spawn:
				var enemy = node.spawn()
				var r = (randf() * 2 - 1) * node.max_distance
				enemy.position = node.position + Vector2(r, r)
				enemy.target = $Hero
				enemy.collision_tilemap = $TileMapLayers/CollisionWallLayer
				if enemy is LavaAnt:
					enemy.connect("lava_aoe", _on_lava_ant_lava_aoe)
				$Enemies.add_child(enemy)
				num_enemies_spawned += 1
