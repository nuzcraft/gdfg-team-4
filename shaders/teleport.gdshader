shader_type canvas_item;

// how “far” the dissolve has progressed (0→1)
uniform float progress : hint_range(0.0, 1.0) = 0.0;
// how “grainy” the noise is (higher → tighter bands)
uniform float noise_density : hint_range(10.0, 200.0) = 60.0;
// thickness of each “beam” band
uniform float beam_size : hint_range(0.01, 0.15) = 0.07;
// glow color; in Godot 4 replace hint_color with source_color
uniform vec4 color : source_color = vec4(0.0, 1.02, 1.2, 1.0);  // :contentReference[oaicite:0]{index=0}

// for flash
uniform bool flash_active = false;
uniform vec3 flash_color: source_color = vec3(1.0);

// simple 2D value‐noise
vec2 random(vec2 uv) {
    uv = vec2(dot(uv, vec2(127.1,311.7)),
              dot(uv, vec2(269.5,183.3)));
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 i = floor(uv), f = fract(uv);
    vec2 u = smoothstep(vec2(0.0), vec2(1.0), f);

    return mix(
        mix(dot(random(i + vec2(0,0)), f - vec2(0,0)),
            dot(random(i + vec2(1,0)), f - vec2(1,0)), u.x),
        mix(dot(random(i + vec2(0,1)), f - vec2(0,1)),
            dot(random(i + vec2(1,1)), f - vec2(1,1)), u.x),
        u.y
    ) * 0.5 + 0.5;
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    // build noise shape, fading vertically
    float n = noise(UV * noise_density) * UV.y;
    float d1 = step(progress, n);
    float d2 = step(progress - beam_size, n);
    // beam color only where band appears
    vec3 beam = (d2 - d1) * color.rgb;
    tex.rgb += beam;
    // fade out underlying sprite as beam passes
    tex.a *= d2;
    COLOR = tex;

	vec4 previous_color = tex;
	vec4 white_color = vec4(flash_color.rgb, previous_color.a);
	vec4 new_color = previous_color;
	if (flash_active == true)
	{
		new_color = white_color;
	}
	COLOR = new_color;

}
