extends Node2D

#@onready var color_rect: ColorRect = $ColorRect
@onready var sub_viewport: SubViewport = $SubViewport
@onready var canvas_group: CanvasGroup = $SubViewport/CanvasGroup

const AOE_TEXTURE_REPLACER = preload("res://shaders/aoe_texture_replacer.material")

const GRID_SIZE := Vector2i(10, 10)
var tile_size: Vector2i = Vector2i(200, 200)
var image_size: Vector2i = Vector2i(2000, 2000)

var color_rects: Array[ColorRect]
var timers: Array[Timer]
var update_timer: float = 0.0

func _ready() -> void:
	#color_rect.show()
	#color_rect.hide()
	#set_size(Vector2i(3000, 3000))
	#create_color_rects()
	pass

func _process(delta: float) -> void:
	#update_timer += delta
	#if update_timer > 0.1:
		#update_viewport_texture()
		#update_timer = 0.0
	
	for timer in timers:
		if timer.time_left <= 0.1:
			timers.remove_at(timers.find(timer))
			timer.get_parent().queue_free()
					
func update_viewport_texture() -> void:
	#var img: Image = sub_viewport.get_viewport().get_texture().get_image()
	#var tex: ImageTexture = ImageTexture.create_from_image(img)
	var tex := sub_viewport.get_texture()
	for cr in color_rects:
		var mat: ShaderMaterial = cr.material
		mat.set_shader_parameter("source_tex", tex)
	
func add_sprite(node: Node2D) -> void:
	var new_spr: Sprite2D
	var new_timer: Timer
	for sub_node in node.get_children():
		if sub_node is Sprite2D:
			new_spr = sub_node.duplicate()
			new_spr.global_position = node.global_position
			new_spr.rotation = node.rotation
			new_spr.scale = node.scale
			var mat: CanvasItemMaterial = CanvasItemMaterial.new()
			mat.blend_mode = mat.BLEND_MODE_ADD
			new_spr.material = mat
			canvas_group.add_child(new_spr)
			update_viewport_texture()
		elif sub_node is Timer:
			new_timer = sub_node.duplicate()
			new_timer.wait_time = sub_node.wait_time
	if new_timer:
		new_spr.add_child(new_timer)
		timers.append(new_timer)
		new_timer.start()
		
func set_size(vec: Vector2i) -> void:
	$SubViewport.size = vec
	image_size = vec
	tile_size = vec / GRID_SIZE
	
func create_color_rects() -> void:
	for x in GRID_SIZE.x:
		for y in GRID_SIZE.y:
			var tile := ColorRect.new()
			tile.position = Vector2(x, y) * Vector2(tile_size)
			tile.size = tile_size
			tile.material = AOE_TEXTURE_REPLACER.duplicate() # set tile_offset etc here
			var mat: ShaderMaterial = tile.material
			mat.set_shader_parameter("tile_offset", Vector2(x * tile_size.x, y * tile_size.y) / Vector2(image_size))
			mat.set_shader_parameter("tile_size", Vector2(tile_size) / Vector2(image_size))
			add_child(tile)
			color_rects.append(tile)
	
