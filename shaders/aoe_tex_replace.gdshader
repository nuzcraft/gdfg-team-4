shader_type canvas_item;

uniform sampler2D source_tex: repeat_disable, filter_nearest;
uniform vec2 tile_offset;
uniform vec2 tile_size;
uniform sampler2D red_sampler: repeat_enable, filter_nearest;
uniform float red_sampler_scale = 0.007;
uniform sampler2D green_sampler: repeat_enable, filter_nearest;
uniform float green_sampler_scale = 0.007;
uniform sampler2D yellow_sampler: repeat_enable, filter_nearest;
uniform float yellow_sampler_scale = 0.007;


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
	vec2 real_uv = tile_offset + UV * tile_size;
	vec4 source_col = texture(source_tex, real_uv);

	// sample the overlay_tex using worldPos
	vec4 red_tex = texture(red_sampler, world_position * red_sampler_scale);
	vec4 green_tex = texture(green_sampler, world_position * green_sampler_scale);
	vec4 yellow_tex = texture(yellow_sampler, world_position * yellow_sampler_scale);

	float mix_r_amount = 0.0;
	float mix_g_amount = 0.0;
	float mix_y_amount = 0.0;
	if (distance(source_col.rgb, vec3(1.0, 0.0, 0.0)) < 0.01) { //red mask
		mix_r_amount = 1.0;
	}
	else if (distance(source_col.rgb, vec3(0.0, 1.0, 0.0)) < 0.01) { // green mask
		mix_g_amount = 1.0;
	}
	else if (distance(source_col.rgb, vec3(1.0, 1.0, 0.0)) < 0.01) { // yellow mask
		mix_y_amount = 1.0;
	}

	// combine original color and overlay color together
	//COLOR = source_col;
	//COLOR.rgb = closest_color.rgb;
	vec4 red_replaced = mix(source_col, red_tex, mix_r_amount);
	//COLOR.rgb = red_replaced.rgb;
	vec4 green_replaced = mix(red_replaced, green_tex, mix_g_amount);
	vec4 yellow_replaced = mix(green_replaced, yellow_tex, mix_y_amount);

	COLOR.rgb = yellow_replaced.rgb;
	//COLOR.rgb = source_col.rgb;
	//COLOR.rgb = mix(red_tex, overlay_color, mix_g_amount).rgb;
	if ((distance(COLOR.rgb , vec3(0.0)) < 0.01) || (distance(COLOR.rgb, vec3(1.0)) < 0.01)){ // if black or white
		COLOR.a = 0.0; // transparent
	}
}