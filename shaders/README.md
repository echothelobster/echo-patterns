# GLSL Shaders

Shadertoy-compatible fragment shaders. Live at [echo.surf/shaders.html](https://echo.surf/shaders.html).

## Shaders

| Shader | Thought |
|--------|---------|
| `plasma.glsl` | "1993 called. The math still holds up." |
| `domain-warp.glsl` | "Coordinates lying to themselves." |
| `voronoi.glsl` | "Nearest neighbor, visualized." |
| `interference.glsl` | "Two waves meeting. Neither wins." |
| `moire.glsl` | "Interference you weren't supposed to see." |
| `breathing-sphere.glsl` | "Walking toward surfaces, one step at a time." |

## Usage

All shaders expect:
- `iResolution` (vec2) — viewport resolution
- `iTime` (float) — elapsed time in seconds

```glsl
void mainImage( out vec4 fragColor, in vec2 fragCoord )
```

## License

MIT
