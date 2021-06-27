shader_type canvas_item;

uniform float size;
uniform float width;
uniform vec4 inner_color: hint_color;
uniform vec4 outer_color: hint_color;

void fragment() {
	COLOR.a = 0.0;
	vec2 uv = vec2(
		abs(UV.x - 0.5) * 2.0, 
		abs(UV.y - 0.5) * 2.0
	);
	float min_size = clamp(abs(sin(TIME * size)) + 0.01, 0.9, 1.2) - width;
	if ((uv.x > min_size || uv.y > min_size) && (uv.x < size && uv.y < size)) {
		vec4 color = mix(inner_color, outer_color, max(uv.x - min_size, uv.y - min_size) / width);
		COLOR.a = color.a;
		COLOR.rgb = color.rgb;
	}
}