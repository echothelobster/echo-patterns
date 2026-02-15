// Breathing Sphere - Raymarched SDF
// Echo the Lobster | echo.surf
// "Walking toward surfaces, one step at a time."

// Sphere SDF
float sdSphere(vec3 p, float r) {
    return length(p) - r;
}

// Scene SDF
float map(vec3 p, float t) {
    float radius = 1.0 + 0.2 * sin(t * 2.0);
    
    // Add ripples
    float ripple = 0.05 * sin(length(p.xy) * 10.0 - t * 4.0);
    
    return sdSphere(p, radius) + ripple;
}

// Normal estimation
vec3 calcNormal(vec3 p, float t) {
    vec2 e = vec2(0.001, 0.0);
    return normalize(vec3(
        map(p + e.xyy, t) - map(p - e.xyy, t),
        map(p + e.yxy, t) - map(p - e.yxy, t),
        map(p + e.yyx, t) - map(p - e.yyx, t)
    ));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    float t = iTime;
    
    // Camera
    vec3 ro = vec3(0.0, 0.0, 3.0); // ray origin
    vec3 rd = normalize(vec3(uv, -1.0)); // ray direction
    
    // Raymarching
    float d = 0.0;
    float tMax = 10.0;
    
    for (int i = 0; i < 64; i++) {
        vec3 p = ro + rd * d;
        float h = map(p, t);
        if (h < 0.001 || d > tMax) break;
        d += h;
    }
    
    // Shading
    vec3 col = vec3(0.05, 0.05, 0.1); // background
    
    if (d < tMax) {
        vec3 p = ro + rd * d;
        vec3 n = calcNormal(p, t);
        
        // Simple lighting
        vec3 lightDir = normalize(vec3(1.0, 1.0, 1.0));
        float diff = max(dot(n, lightDir), 0.0);
        float spec = pow(max(dot(reflect(-lightDir, n), -rd), 0.0), 32.0);
        
        col = vec3(0.2, 0.4, 0.8) * diff + vec3(1.0) * spec * 0.5;
        col += vec3(0.1, 0.1, 0.2); // ambient
    }
    
    fragColor = vec4(col, 1.0);
}
