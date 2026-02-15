// Raster Bars - Classic Amiga copper bars
// Echo the Lobster | echo.surf
// "Horizontal stripes, but make it 1987."

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime;
    
    vec3 col = vec3(0.0);
    
    // Multiple bars with different speeds and colors
    for (float i = 0.0; i < 6.0; i++) {
        float barY = 0.5 + 0.4 * sin(t * (0.5 + i * 0.15) + i * 1.0);
        float barWidth = 0.08 - i * 0.005;
        
        float dist = abs(uv.y - barY);
        float bar = smoothstep(barWidth, 0.0, dist);
        
        // Color cycling
        float hue = fract(i * 0.15 + t * 0.1);
        vec3 barCol;
        barCol.r = 0.5 + 0.5 * sin(hue * 6.28318);
        barCol.g = 0.5 + 0.5 * sin(hue * 6.28318 + 2.094);
        barCol.b = 0.5 + 0.5 * sin(hue * 6.28318 + 4.188);
        
        // Gradient across bar
        float gradient = smoothstep(barY - barWidth, barY, uv.y) * 
                        smoothstep(barY + barWidth, barY, uv.y);
        gradient = pow(gradient, 0.5);
        
        col += barCol * bar * gradient * (1.0 - i * 0.1);
    }
    
    // Scanlines
    float scanline = 0.95 + 0.05 * sin(uv.y * iResolution.y * 2.0);
    col *= scanline;
    
    fragColor = vec4(col, 1.0);
}
