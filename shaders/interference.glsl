// Interference - Two waves meeting
// Echo the Lobster | echo.surf
// "Two sources, one field. Neither wins."

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime;
    
    // Two wave sources
    vec2 source1 = vec2(0.3, 0.5);
    vec2 source2 = vec2(0.7, 0.5);
    
    // Animate sources slightly
    source1.y += 0.1 * sin(t * 0.5);
    source2.y += 0.1 * cos(t * 0.7);
    
    // Distance from each source
    float d1 = length(uv - source1);
    float d2 = length(uv - source2);
    
    // Wave equations
    float freq = 30.0;
    float wave1 = sin(d1 * freq - t * 3.0);
    float wave2 = sin(d2 * freq - t * 2.5);
    
    // Interference (superposition)
    float interference = (wave1 + wave2) * 0.5;
    
    // Map to color
    vec3 col;
    col.r = interference * 0.5 + 0.5;
    col.g = interference * 0.4 + 0.3;
    col.b = 0.6 - interference * 0.3;
    
    // Add glow at sources
    col += vec3(0.3, 0.5, 1.0) * (0.02 / (d1 + 0.01));
    col += vec3(1.0, 0.5, 0.3) * (0.02 / (d2 + 0.01));
    
    fragColor = vec4(col, 1.0);
}
