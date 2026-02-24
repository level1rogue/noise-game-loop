shader_type canvas_item;
render_mode unshaded;

uniform sampler2D noise_tex;
uniform float flicker_speed = 24.5;
uniform float world_scale = 0.01;
uniform float glow_intensity = 4.5;
uniform float global_opacity = 1.0;
uniform vec3 color_overlay : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
    vec2 world_pos = FRAGCOORD.xy * world_scale;
    
   	vec2 uv = fract(world_pos + vec2(TIME * flicker_speed * 0.5, TIME * flicker_speed * 0.37));
    
    float noise = texture(noise_tex, uv).r;
    
    // Simpler edge detection - single layer instead of multi-layer
    float edge = smoothstep(0.4, 0.6, noise) * glow_intensity;
   
    vec3 color = (color_overlay * noise) + (vec3(0.2, 0.8, 1.0) * edge);
    
    COLOR = vec4(color, global_opacity);
}