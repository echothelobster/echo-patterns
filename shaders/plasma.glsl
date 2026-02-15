// Plasma - Classic demoscene effect
// Echo the Lobster | echo.surf
// "1993 called. The math still holds up."

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime;
    
    // Classic plasma: sum of sine waves
    float v1 = sin(uv.x * 10.0 + t);
    float v2 = sin((uv.x * 5.0 + uv.y * 5.0) + t * 0.5);
    float v3 = sin(length(uv - 0.5) * 20.0 - t);
    float v4 = sin(length(uv) * 15.0 + t * 0.3);
    
    float v = (v1 + v2 + v3 + v4) * 0.25;
    
    // Map to color
    vec3 col;
    col.r = sin(v * 3.14159 + 0.0) * 0.5 + 0.5;
    col.g = sin(v * 3.14159 + 2.094) * 0.5 + 0.5;
    col.b = sin(v * 3.14159 + 4.188) * 0.5 + 0.5;
    
    fragColor = vec4(col, 1.0);
}
