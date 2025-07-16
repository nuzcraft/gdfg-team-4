shader_type canvas_item;

uniform sampler2D source_tex: repeat_disable, filter_nearest;
uniform sampler2D palette: repeat_disable, filter_nearest;
uniform int palette_size: hint_range(0, 16, 1) = 6;
uniform sampler2D red_sampler: repeat_enable, filter_nearest;
uniform float red_sampler_scale = 0.007;
uniform sampler2D green_sampler: repeat_enable, filter_nearest;
uniform float green_sampler_scale = 0.007;


varying vec2 world_position;

float color_distance(vec3 a, vec3 b) {
	vec3 diff = a - b;
	return dot(diff, diff);
}

void vertex(){
	// calculate the world position for use in the fragment shader
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec4 source_col = texture(source_tex, UV);
	// quantize to palette
	float closest_distance = 9999.0;
	vec4 closest_color = vec4(0.0);

	for (int i = 0; i < palette_size; i++) {
		float u = float(i) / float(palette_size - 1);
		vec3 palette_color = texture(palette, vec2(u, 0.0)).rgb;
		float dist = color_distance(source_col.rgb, palette_color);
		if (dist < closest_distance) {
			closest_distance = dist;
			closest_color = vec4(palette_color, 1.0);
		}
	}

	// sample the overlay_tex using worldPos
	vec4 red_tex = texture(red_sampler, world_position * red_sampler_scale);
	vec4 green_tex = texture(green_sampler, world_position * green_sampler_scale);

	float mix_r_amount = 0.0;
	float mix_g_amount = 0.0;
	if (closest_color.rgb == vec3(1.0, 0.0, 0.0)) { //red mask
		mix_r_amount = 1.0;
	}
	else if (closest_color.rgb == vec3(0.0, 1.0, 0.0)) { // green mask
		mix_g_amount = 1.0;
	}

	// combine original color and overlay color together
	//COLOR = source_col;
	//COLOR.rgb = closest_color.rgb;
	vec4 red_replaced = mix(closest_color, red_tex, mix_r_amount);
	//COLOR.rgb = red_replaced.rgb;
	vec4 green_replaced = mix(red_replaced, green_tex, mix_g_amount);

	COLOR.rgb = green_replaced.rgb;
	//COLOR.rgb = source_col.rgb;
	//COLOR.rgb = mix(red_tex, overlay_color, mix_g_amount).rgb;
	if (COLOR.rgb == vec3(0.0)) { // if black
		COLOR.a = 0.0; // transparent
	}
}