shader_type canvas_item;

uniform float health : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 dir = UV - vec2(0.9, 0.9);
    float angle = atan(-dir.y, -dir.x);
    float normalized = clamp(angle / (0.5 * 3.14159), 0.0, 1.0);

    if (normalized > health) {
        discard;
    }

    vec4 tex = texture(TEXTURE, UV);
    COLOR = tex;

    if (COLOR.a < 0.01) {
        discard;
    }
}
