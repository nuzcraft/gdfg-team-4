# StarBackground.gd  (attach to ParallaxBackground)
extends ParallaxBackground

@export var speed: float = 20.0        # px / s
@export var tile_width: float = 256.0   # match your texture

func _process(delta: float) -> void:
	scroll_offset.x = fmod(scroll_offset.x - speed * delta, tile_width)
