shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 color = texture(screen_texture, UV);
	vec4 offsetColor = texture(screen_texture, UV-0.002);
	if(length(color - offsetColor) > 0.2) color = vec4(0.0);
	COLOR = color;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
