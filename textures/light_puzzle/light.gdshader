shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 color : source_color = vec4(1.0);

const vec4 INVSIBLE_COLOR = vec4(0.0);

void fragment() {
	if (UV.x < progress)
		COLOR = color;
	else
		COLOR = INVSIBLE_COLOR;
}
