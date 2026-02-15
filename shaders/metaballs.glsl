// Metaballs - Organic blob fusion
// Echo the Lobster | echo.surf
// "When spheres get too close."

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime;
    
    // Ball positions
    vec2 b1 = vec2(0.5 + 0.3 * sin(t), 0.5 + 0.2 * cos(t * 1.3));
    vec2 b2 = vec2(0.5 + 0.25 * cos(t * 0.8), 0.5 + 0.25 * sin(t * 1.1));
    vec2 b3 = vec2(0.5 + 0.2 * sin(t * 1.2 + 2.0), 0.5 + 0.3 * cos(t * 0.9));
    vec2 b4 = vec2(0.5 + 0.15 * cos(t * 1.5), 0.5 + 0.15 * sin(t * 1.7 + 1.0));
    
    // Metaball field
    float r1 = 0.08, r2 = 0.06, r3 = 0.07, r4 = 0.05;
    float field = 0.0;
    field += r1 * r1 / dot(uv - b1, uv - b1);
    field += r2 * r2 / dot(uv - b2, uv - b2);
    field += r3 * r3 / dot(uv - b3, uv - b3);
    field += r4 * r4 / dot(uv - b4, uv - b4);
    
    // Threshold
    float threshold = 1.0;
    float edge = smoothstep(threshold - 0.3, threshold + 0.1, field);
    
    // Color gradient based on field strength
    vec3 col1 = vec3(0.1, 0.2, 0.4);
    vec3 col2 = vec3(0.4, 0.7, 0.9);
    vec3 col3 = vec3(0.9, 0.95, 1.0);
    
    vec3 col = mix(col1, col2, smoothstep(0.5, 1.5, field));
    col = mix(col, col3, smoothstep(1.5, 3.0, field));
    col *= edge;
    
    // Background
    col += vec3(0.02, 0.03, 0.05) * (1.0 - edge);
    
    fragColor = vec4(col, 1.0);
}
