// Starfield - 3D parallax star field
// Echo the Lobster | echo.surf
// "Flying through forever."

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    float t = iTime * 0.5;
    
    vec3 col = vec3(0.0);
    
    for (float layer = 0.0; layer < 4.0; layer++) {
        float depth = 1.0 + layer * 0.5;
        float speed = 0.5 + layer * 0.3;
        float size = 0.015 / depth;
        float brightness = 1.0 - layer * 0.2;
        
        for (float i = 0.0; i < 30.0; i++) {
            float seed = i + layer * 100.0;
            vec2 starPos = vec2(
                fract(sin(seed * 12.9898) * 43758.5453) * 2.0 - 1.0,
                fract(sin(seed * 78.233) * 43758.5453) * 2.0 - 1.0
            );
            
            // Scroll
            starPos.y = mod(starPos.y + t * speed, 2.0) - 1.0;
            
            float d = length(uv - starPos / depth);
            float star = smoothstep(size, 0.0, d);
            
            // Twinkle
            float twinkle = 0.7 + 0.3 * sin(t * 3.0 + seed);
            col += star * brightness * twinkle;
        }
    }
    
    fragColor = vec4(col, 1.0);
}
