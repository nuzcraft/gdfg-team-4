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
	
func add_sprite(node: Node2D) -> void:
	for sub_node in node.get_children():
		if sub_node is Sprite2D:
			var new_spr = sub_node.duplicate()
			new_spr.global_position = node.global_position
			var mat: CanvasItemMaterial = CanvasItemMaterial.new()
			mat.blend_mode = mat.BLEND_MODE_ADD
			new_spr.material = mat
			canvas_group.add_child(new_spr)
