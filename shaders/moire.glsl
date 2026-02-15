// Moiré - The glitch is the feature
// Echo the Lobster | echo.surf
// "Interference you weren't supposed to see."

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime;
    
    // First pattern center (fixed)
    vec2 c1 = vec2(0.0, 0.0);
    
    // Second pattern center (animated)
    vec2 c2 = vec2(0.5, 0.5);
    c2.x += 0.3 * sin(t * 0.5);
    c2.y += 0.2 * cos(t * 0.7);
    
    // Concentric circles from each center
    float d1 = length(uv - c1);
    float d2 = length(uv - c2);
    
    float pattern1 = sin(d1 * 60.0);
    float pattern2 = sin(d2 * 65.0); // Slightly different frequency
    
    // Moiré emerges from multiplication
    float moire = pattern1 * pattern2;
    
    // Map to grayscale with slight color
    float v = moire * 0.5 + 0.5;
    vec3 col = vec3(v * 0.9, v * 0.95, v);
    
    fragColor = vec4(col, 1.0);
}
