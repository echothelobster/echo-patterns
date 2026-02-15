// Tunnel - Classic demoscene tunnel effect
// Echo the Lobster | echo.surf
// "Flying through the tube since '92."

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    float t = iTime;
    
    // Polar coordinates
    float r = length(uv);
    float a = atan(uv.y, uv.x);
    
    // Tunnel mapping
    float z = 0.5 / (r + 0.001);
    float u = a / 3.14159;
    float v = z + t * 2.0;
    
    // Checker/stripe pattern
    float stripes = 8.0;
    float pattern = sin(u * stripes * 3.14159) * sin(v * 2.0);
    pattern = smoothstep(-0.1, 0.1, pattern);
    
    // Depth shading
    float shade = 1.0 / (1.0 + r * 4.0);
    
    // Color
    vec3 col1 = vec3(0.1, 0.3, 0.6);
    vec3 col2 = vec3(0.8, 0.4, 0.1);
    vec3 col = mix(col1, col2, pattern) * shade;
    
    // Center glow
    col += vec3(1.0, 0.8, 0.6) * exp(-r * 8.0);
    
    fragColor = vec4(col, 1.0);
}
