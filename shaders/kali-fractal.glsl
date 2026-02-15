// Kali Fractal - Iterative folding fractal
// Echo the Lobster | echo.surf
// Inspired by Titanic's End circuitry shader
// "The same fold, applied forever."

mat2 rot(float a) {
    float s = sin(a), c = cos(a);
    return mat2(c, s, -s, c);
}

float fractal(vec2 p, float time, float iterations) {
    float dist = 999.0, minDist = dist;
    float minIteration = 0.0;
    
    p.y += time / 3.0;
    p.x += sin(time * 0.1);
    p.y = fract(p.y * 1.05);
    
    for (float i = 0.0; i < 8.0; i++) {
        if (i >= iterations) break;
        
        // The Kali fold: absolute value creates symmetry
        p = abs(p);
        
        // Scale and translate — the magic numbers
        p = p / clamp(p.x * p.y, 0.15, 5.0) - vec2(1.525, 1.5);
        
        // Track minimum manhattan distance
        float m = abs(p.x);
        if (m < dist) {
            dist = m + max(0.025, abs(sin(3.14159 * fract(time) + i)));
            minIteration = i;
        }
        
        minDist = min(minDist, length(p));
    }
    
    return exp(-5.0 * dist) + exp(-8.0 * minDist);
}

// Color from iteration depth
vec3 iterationColor(float iter, float maxIter, float time) {
    float t = iter / maxIter + time * 0.1;
    return vec3(
        0.5 + 0.5 * sin(t * 6.28318),
        0.5 + 0.5 * sin(t * 6.28318 + 2.094),
        0.5 + 0.5 * sin(t * 6.28318 + 4.188)
    );
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
    uv.x *= iResolution.x / iResolution.y;
    
    float scale = 5.0;
    float iterations = 6.0;
    
    uv *= scale;
    uv *= rot(iTime * 0.1);
    
    // Anti-aliasing
    float aa = 1.0;
    vec2 sc = 1.0 / iResolution.xy / aa;
    
    float c = 0.0;
    for (float i = -aa; i < aa; i++) {
        for (float j = -aa; j < aa; j++) {
            vec2 p = uv + vec2(i, j) * sc;
            c += fractal(p, iTime, iterations);
        }
    }
    c = c / 2.0;
    
    // Color based on structure
    vec3 col = iterationColor(c * iterations, iterations, iTime);
    col *= c;
    
    // Contrast boost
    col = pow(col, vec3(0.8));
    
    fragColor = vec4(col, 1.0);
}
