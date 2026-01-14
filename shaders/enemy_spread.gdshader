shader_type canvas_item;
render_mode unshaded;

uniform sampler2D noise_tex;
uniform float flicker_speed = 24.5;
uniform float world_scale = 0.01;
uniform float glow_intensity = 4.5;
uniform float global_opacity = 1.0;

void fragment() {
    vec2 world_pos = FRAGCOORD.xy * world_scale;
    
    // Multi-layer noise
    vec2 uv1 = fract(world_pos * 1.0 + vec2(TIME * flicker_speed, TIME * flicker_speed * 0.73));
    float noise1 = texture(noise_tex, uv1).r;
    
    vec2 uv2 = fract(world_pos * 0.7 + vec2(TIME * flicker_speed * 0.5, TIME * flicker_speed * 0.4));
    float noise2 = texture(noise_tex, uv2).g;
    
    float noise = mix(noise1, noise2, 0.5);
    
    // Edge detection for glow
    float edge = abs(dFdx(noise)) + abs(dFdy(noise));
    edge = pow(edge, 2.0) * glow_intensity;
    
    vec3 pink_color = vec3(1.0, 1.0, 1.0);
    vec3 color = (pink_color * noise) + (vec3(0.2, 0.8, 1.0) * edge);
    
    COLOR = vec4(color, global_opacity);
}