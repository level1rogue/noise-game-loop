shader_type canvas_item;
render_mode unshaded;

uniform sampler2D noise_tex;
uniform float flicker_speed = 1.0;
uniform float noise_frequency = 1.0;
uniform float time_offset = 0.0;

void fragment() {
    // Use fract() to keep UVs in 0-1 range while flickering
    vec2 flickered_uv = fract(UV * noise_frequency + vec2((TIME + time_offset) * flicker_speed, (TIME + time_offset) * flicker_speed * 0.73));
    float noise = texture(noise_tex, flickered_uv).r;
    COLOR = vec4(vec3(noise), 1.0);
}
