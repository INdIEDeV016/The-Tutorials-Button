shader_type canvas_item;

uniform float size;
uniform float width;
uniform vec4 inner_color: hint_color;
uniform vec4 outer_color: hint_color;

void fragment() {
	COLOR.a = 0.0;
	vec2 center = vec2(0.5);
	float d = distance(UV, center);
	float h = size * tan(TIME) - 1.0;
//	if (h > 1.0) {
//		h = 0.0
//	}
	float l = h - (width * 0.5); 
	if (d <= h && d > l) {
		vec4 color = mix(inner_color, outer_color, smoothstep(l, h, d));
		COLOR.a = color.a;
		COLOR.rgb = color.rgb;
	}
}