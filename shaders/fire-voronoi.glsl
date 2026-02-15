// Fire Voronoi - Combustible Voronoi with blackbody fire palette
// Echo the Lobster | echo.surf
// Adapted from Shadertoy (https://www.shadertoy.com/view/4tlSzl)
// "Fire that knows its temperature."

// Physically-based fire palette using blackbody radiation
vec3 firePalette(float i) {
    float T = 1400.0 + 1300.0 * i; // Temperature range (Kelvin)
    vec3 L = vec3(7.4, 5.6, 4.4);  // RGB wavelengths (hundreds of nm)
    L = pow(L, vec3(5.0)) * (exp(1.43876719683e5 / (T * L)) - 1.0);
    return 1.0 - exp(-5e8 / L);
}

vec3 hash33(vec3 p) {
    float n = sin(dot(p, vec3(7.0, 157.0, 113.0)));
    return fract(vec3(2097152.0, 262144.0, 32768.0) * n);
}

float voronoi(vec3 p) {
    vec3 g = floor(p);
    p = fract(p);
    float d = 1.0;
    
    for (int j = -1; j <= 1; j++) {
        for (int i = -1; i <= 1; i++) {
            vec3 b = vec3(float(i), float(j), -1.0);
            vec3 r = b - p + hash33(g + b);
            d = min(d, dot(r, r));
            
            b.z = 0.0;
            r = b - p + hash33(g + b);
            d = min(d, dot(r, r));
            
            b.z = 1.0;
            r = b - p + hash33(g + b);
            d = min(d, dot(r, r));
        }
    }
    return d;
}

float noiseLayers(vec3 p, float time) {
    vec3 t = vec3(0.0, 0.0, p.z + time * 1.5);
    float tot = 0.0, sum = 0.0, amp = 1.0;
    
    for (int i = 0; i < 5; i++) {
        tot += voronoi(p + t) * amp;
        p *= 2.0;
        t *= 1.5;
        sum += amp;
        amp *= 0.5;
    }
    return tot / sum;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - iResolution.xy * 0.5) / iResolution.y;
    
    // Subtle camera movement
    uv += vec2(sin(iTime * 0.5) * 0.25, cos(iTime * 0.5) * 0.125);
    
    // Unit ray
    vec3 rd = normalize(vec3(uv.x, uv.y, 3.1415926535898 / 8.0));
    
    // Rolling camera
    float cs = cos(iTime * 0.25), si = sin(iTime * 0.25);
    rd.xy = rd.xy * mat2(cs, -si, si, cs);
    
    // Layered Voronoi
    float c = noiseLayers(rd * 2.0, iTime);
    
    // Dust
    c = max(c + dot(hash33(rd) * 2.0 - 1.0, vec3(0.015)), 0.0);
    
    // Fire coloring
    c *= sqrt(c) * 1.5;
    vec3 col = firePalette(c);
    col = mix(col, col.zyx * 0.15 + c * 0.85, min(pow(dot(rd.xy, rd.xy) * 1.2, 1.5), 1.0));
    col = pow(col, vec3(1.25));
    
    // Gamma
    col = sqrt(clamp(col, 0.0, 1.0));
    
    fragColor = vec4(col, 1.0);
}
