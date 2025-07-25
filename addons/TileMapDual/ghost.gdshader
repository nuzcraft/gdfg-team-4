// A shader that sets all pixels to 0 alpha, making the object invisible.

shader_type canvas_item;
void fragment() {
    COLOR = vec4(0);
}