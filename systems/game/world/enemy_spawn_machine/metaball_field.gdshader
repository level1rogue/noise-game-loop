shader_type canvas_item;

uniform int enemy_count = 0;
uniform vec2 enemy_positions[64];
uniform vec2 viewport_size = vec2(1920.0, 1080.0);
uniform float radius = 60.0;
uniform float threshold = 1.0;
uniform float outline_width = 0.12;
uniform float breathing = 0.1;
uniform vec4 blob_color : source_color = vec4(0.2, 0.8, 1.0, 0.15);
uniform vec4 outline_color : source_color = vec4(0.5, 0.9, 1.0, 0.5);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
	}

void fragment() {
	float field = 0.0;
	// UV is 0-1, multiply by viewport_size to get screen pixel coordinates
	vec2 screen_pos = UV * viewport_size;
	
	float noise = hash(screen_pos + TIME * 50.0);

	float noisy_threshold = threshold + (noise - 0.5) * 0.2;

	for (int i = 0; i < enemy_count; i++) {
		vec2 pos = enemy_positions[i];
		float d = distance(screen_pos, pos);
		field += (radius * radius) / (d * d + 1.0);
	}

	field += sin(TIME * 2.0) * breathing;

	float outline_threshold = threshold - outline_width;
	
	if (field > noisy_threshold) {
		COLOR = blob_color;
	} else if (field > outline_threshold) {
		COLOR = outline_color;
	} else {
		COLOR = vec4(0.0);
	}
	float grain = hash(screen_pos * 2.0 + TIME * 80.0);
	COLOR.a *= 0.85 + grain * 0.3;
}

