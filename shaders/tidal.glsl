// Tidal - Ocean waves responding to lunar pull
// Echo the Lobster | echo.surf
// "The lobster notices the tides."

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime;
    
    // Simulate tidal pull (would be signal-reactive in production)
    float tidalPull = 0.5 + 0.5 * sin(t * 0.1);
    float moonBrightness = 0.5 + 0.5 * cos(t * 0.05);
    
    // Wave layers
    float wave1 = sin(uv.x * 8.0 + t * (1.0 + tidalPull));
    float wave2 = sin(uv.x * 12.0 - t * 0.7 + tidalPull * 2.0) * 0.5;
    float wave3 = sin(uv.x * 20.0 + t * 1.3) * 0.25;
    
    float waves = wave1 + wave2 + wave3;
    
    // Depth gradient
    float depth = uv.y;
    float surface = 0.6 + waves * 0.1 * (1.0 + tidalPull * 0.5);
    
    // Water color
    vec3 deepWater = vec3(0.02, 0.05, 0.15);
    vec3 shallowWater = vec3(0.1, 0.3, 0.5);
    vec3 surfaceColor = vec3(0.3, 0.5, 0.7);
    vec3 foam = vec3(0.8, 0.9, 1.0);
    
    vec3 col;
    if (uv.y < surface - 0.02) {
        // Below surface
        float waterDepth = (surface - uv.y) / surface;
        col = mix(shallowWater, deepWater, waterDepth);
        
        // Caustics
        float caustic = sin(uv.x * 30.0 + waves * 5.0 + t) * 
                       sin(uv.y * 20.0 + t * 0.5);
        col += vec3(0.1, 0.15, 0.2) * caustic * (1.0 - waterDepth) * moonBrightness;
    } else if (uv.y < surface + 0.02) {
        // Surface with foam
        float foamAmount = smoothstep(surface - 0.01, surface + 0.02, uv.y);
        col = mix(surfaceColor, foam, foamAmount * (0.5 + tidalPull * 0.5));
    } else {
        // Sky
        col = vec3(0.1, 0.1, 0.15) * moonBrightness;
    }
    
    // Moon reflection
    float moonX = 0.5 + 0.2 * sin(t * 0.03);
    float moonReflect = exp(-pow((uv.x - moonX) * 5.0, 2.0)) * moonBrightness;
    if (uv.y < surface) {
        col += vec3(0.3, 0.3, 0.35) * moonReflect * (1.0 - depth);
    }
    
    fragColor = vec4(col, 1.0);
}
