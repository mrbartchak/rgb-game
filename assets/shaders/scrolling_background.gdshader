shader_type canvas_item;

uniform float scroll_speed: hint_range(0.0, 2.0) = 0.05;
uniform float angle_degrees: hint_range(0, 360, 1) = 45.0;
uniform float repeat: hint_range(1, 20, 1) = 1;
uniform vec4 tint: source_color = vec4(1.0);


void fragment() {
	
	float angle_rad = radians(angle_degrees);
	vec2 direction = vec2(cos(angle_rad), sin(angle_rad));
	vec2 offset_uv = UV - (TIME * scroll_speed * direction);
	
	vec2 scaled_uv = vec2(fract(offset_uv.x * repeat), fract(offset_uv.y * repeat));
	vec2 texel_size = vec2(1.0) / vec2(textureSize(TEXTURE, 0));
	vec2 snapped_uv = round(scaled_uv / texel_size) * texel_size;
	
	COLOR = texture(TEXTURE, snapped_uv) * tint;
}
