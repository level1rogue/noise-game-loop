shader_type canvas_item;
render_mode unshaded;

uniform sampler2D noise_tex;
uniform float noise_scale = 0.5;
uniform float global_opacity = 1.0;
uniform vec3 color_overlay : source_color = vec3(1.0, 0.2, 0.6);

void fragment() {
    // Use screen position directly for static-like pattern
    vec2 uv = UV;
    
    // Layer 1: Main noise texture
    float noise1 = texture(noise_tex, uv * noise_scale).r;
    
    // Layer 2: High-frequency noise for grain (uses built-in noise function)
    float noise2 = fract(sin(dot(uv + TIME * 0.5, vec2(12.9898, 78.233))) * 43758.5453);
    
    // Layer 3: Scanlines (CRT effect)
    float scanlines = sin(uv.y * 100.0) * 0.2 + 0.8;
    
    // Combine: mostly static with color tint
    float combined = mix(noise1, noise2, 0.5);
    vec3 color = color_overlay * combined * scanlines;
    
    COLOR = vec4(color, global_opacity);
}