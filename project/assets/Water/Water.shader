shader_type canvas_item;

uniform vec4 tint : hint_color = vec4(1.0);

void fragment()
{
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	color = mix(color, tint, 0.4);
	color = mix(vec4(0.5), color, 1.4);
	
	COLOR = color;
}
