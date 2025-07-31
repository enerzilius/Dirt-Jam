shader_type sky;

uniform vec3 skyColor : source_color;
uniform vec3 horizonColor : source_color;
uniform float sun_radius : hint_range(0.0, 0.5, 0.01) = 0.05;

float getVec3Avg(vec3 a) {
	return (a.r + a.g + a.b)/3.0;
}

void sky() {
	float col = clamp(EYEDIR.y+0.10 / 0.17, 0.0, 1.0);
	vec3 finalColor = skyColor;
	finalColor = mix(horizonColor, skyColor, col);
	float diff = length(EYEDIR - LIGHT0_DIRECTION);
	if(diff < sun_radius) finalColor += vec3(1.0, 1.0-diff, 0.27-diff);
	finalColor = clamp(finalColor, vec3(0.0),vec3(1.0));
	float effect = clamp(LIGHT0_DIRECTION.y, 0.0, 1.0);
	finalColor += -diff * vec3(0.27+effect, 0.2-effect*0.2, 0.350-effect);
	finalColor = clamp(finalColor, vec3(0.0),vec3(1.0));
	COLOR = finalColor;
}
