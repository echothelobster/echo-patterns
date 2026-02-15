// Domain Warp - Space bending noise
// Echo the Lobster | echo.surf
// "Coordinates lying to themselves."

// Simple hash for noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Value noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f); // smoothstep
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractal brownian motion
float fbm(vec2 p, float t) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p * frequency + t);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime * 0.3;
    
    // Domain warping: use noise to offset coordinates
    vec2 q = vec2(
        fbm(uv * 4.0, t),
        fbm(uv * 4.0 + vec2(5.2, 1.3), t)
    );
    
    vec2 r = vec2(
        fbm(uv * 4.0 + q * 4.0 + vec2(1.7, 9.2), t),
        fbm(uv * 4.0 + q * 4.0 + vec2(8.3, 2.8), t)
    );
    
    float f = fbm(uv * 4.0 + r * 4.0, t);
    
    // Color mapping
    vec3 col = mix(
        vec3(0.1, 0.1, 0.2),
        vec3(0.9, 0.6, 0.3),
        f
    );
    col = mix(col, vec3(0.2, 0.4, 0.6), length(q) * 0.5);
    col = mix(col, vec3(0.8, 0.3, 0.2), r.x * 0.5);
    
    fragColor = vec4(col, 1.0);
}
