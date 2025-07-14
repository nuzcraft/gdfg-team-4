shader_type canvas_item;

// texture bit
uniform sampler2D overlay_tex: repeat_enable, filter_nearest;
uniform float scale = 0.006944444; // calculated by 1/texture size e.g. 1/144
varying vec2 world_position;

// wiggle bit
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear;
uniform sampler2D NOISE_TEXTURE: repeat_enable;
uniform float strength: hint_range(0.0, 5, 0.1) = 1.0;
uniform float uv_scaling: hint_range (0.0, 1.0, 0.05) = 1.0;
uniform vec2 movement_direction = vec2(1, 0);
uniform float movement_speed: hint_range (0.0, 0.5, 0.01) = 0.1;

void vertex(){
	// calculate the world position for use in the fragment shader
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// sample the overlay_tex using worldPos
	vec4 overlay_texture = texture(overlay_tex, world_position * scale);

	vec2 uv = world_position * scale;
	vec2 movement_factor = movement_direction * movement_speed * TIME;
	float noise_value = texture(NOISE_TEXTURE, uv*uv_scaling + movement_factor).r - 0.5;
	uv += noise_value * strength * TEXTURE_PIXEL_SIZE;
	COLOR.rgb = texture(overlay_tex, uv).rgb;

}