// http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
shader_type canvas_item; 

void fragment() {
	vec2 iResolution = (1.0 / SCREEN_PIXEL_SIZE);
	vec2 uv = 2.0 * FRAGCOORD.xy / iResolution.xy - 1.0;
	vec2 uvs = uv * iResolution.xy / max(iResolution.x, iResolution.y);
	vec3 p = vec3(uvs / 4.0, 0.0) + vec3(1.0, -1.3, 0.0);
	p += 0.6 * vec3(sin(TIME / 16.0), sin(TIME / 12.0),  sin(TIME / 128.0));
	
	float strength = 9.0 + 0.03 * log(1.e-6 + fract(sin(TIME) * 4373.11));
	float accum = 0.0;
	float prev = 0.0;
	float tw = 0.0;
	for (int i = 0; i < 32; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) / 7.0);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.3));
		tw += w;
		prev = mag;
	}
	
	float t = max(0.0, 6.0 * accum / tw - .97);
	float v = (2.0 - exp((abs(uv.x) - 51.0) * 2.0)) * (19.0 - exp((abs(uv.y) - 1.0) * 6.0));
	COLOR = mix(.4, 1.0, v) * vec4(1.8 * t * t * t, 1.4 * t * t, t, 1.0);
}