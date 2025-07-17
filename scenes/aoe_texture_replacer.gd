extends Node2D

@onready var color_rect: ColorRect = $ColorRect
@onready var sub_viewport: SubViewport = $SubViewport
@onready var canvas_group: CanvasGroup = $SubViewport/CanvasGroup

func _ready() -> void:
	color_rect.show()

func _process(delta: float) -> void:
	var img: Image = sub_viewport.get_viewport().get_texture().get_image()
	var tex: ImageTexture = ImageTexture.create_from_image(img)
	var mat: ShaderMaterial = color_rect.material
	mat.set_shader_parameter("source_tex", tex)
	
	for sub_node in canvas_group.get_children():
		for sub_sub_node in sub_node.get_children():
			if sub_sub_node is Timer:
				var timer: Timer = sub_sub_node
				if timer.time_left <= 0.1:
					timer.get_parent().queue_free()
	
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
		elif sub_node is Timer:
			new_timer = sub_node.duplicate()
			new_timer.wait_time = sub_node.wait_time
	new_spr.add_child(new_timer)
	new_timer.start()
	
