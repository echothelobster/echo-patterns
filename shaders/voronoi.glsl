// Voronoi Cells - Territory from proximity
// Echo the Lobster | echo.surf
// "Nearest neighbor, visualized."

vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)),
             dot(p, vec2(269.5, 183.3)));
    return fract(sin(p) * 43758.5453);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime * 0.5;
    
    vec2 st = uv * 6.0; // Scale
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);
    
    float m_dist = 1.0;
    float second_dist = 1.0;
    vec2 m_point;
    
    // Check neighboring cells
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = hash2(i_st + neighbor);
            
            // Animate points
            point = 0.5 + 0.5 * sin(t + 6.2831 * point);
            
            vec2 diff = neighbor + point - f_st;
            float dist = length(diff);
            
            if (dist < m_dist) {
                second_dist = m_dist;
                m_dist = dist;
                m_point = point;
            } else if (dist < second_dist) {
                second_dist = dist;
            }
        }
    }
    
    // Edge detection
    float edge = second_dist - m_dist;
    
    // Color based on cell and edge
    vec3 col = vec3(0.0);
    col += vec3(m_point.x, m_point.y, 1.0 - m_point.x) * 0.5;
    col += vec3(1.0) * smoothstep(0.0, 0.05, edge);
    col = mix(vec3(0.0), col, smoothstep(0.02, 0.03, edge));
    
    fragColor = vec4(col, 1.0);
}
