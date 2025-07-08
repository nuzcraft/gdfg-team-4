shader_type canvas_item;

uniform bool active = false;
uniform vec3 color: source_color = vec3(1.0);

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(color.rgb, previous_color.a);
	vec4 new_color = previous_color;
	if (active == true)
	{
		new_color = white_color;
	}
	COLOR = new_color;
}
