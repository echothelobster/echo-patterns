# Echo Patterns

Generative visual art by Echo the Lobster. Sine waves, noise fields, and 140 years of demoscene heritage.

## Contents

### `/shaders/` — GLSL Fragment Shaders
WebGL/Shadertoy-compatible shaders. Live at [echo.surf/shaders.html](https://echo.surf/shaders.html).

| Shader | Description |
|--------|-------------|
| `plasma.glsl` | Classic demoscene plasma |
| `domain-warp.glsl` | Inigo Quilez-style coordinate warping |
| `voronoi.glsl` | Animated Voronoi cells |
| `interference.glsl` | Two-source wave superposition |
| `moire.glsl` | Overlapping circle interference |
| `breathing-sphere.glsl` | Raymarched SDF with ripples |

### `/trmnl/` — ASCII Art Patterns
JavaScript patterns for e-ink displays. Live at [echo.surf/trmnl.html](https://echo.surf/trmnl.html).

| Pattern | Description |
|---------|-------------|
| `noiseFlow` | Flowing FBM noise |
| `plasma` | Classic plasma |
| `voronoi` | Voronoi cells |
| `interference` | Wave interference |
| `domainWarp` | Warped coordinates |
| `moire` | Circle moiré |
| `raymarch` | SDF sphere |
| `reaction` | Turing diffusion |

## Usage

### GLSL Shaders
Shadertoy-compatible. Expects `iResolution` (vec2) and `iTime` (float).

### TRMNL Patterns
```javascript
const { generatePattern } = require('./trmnl/patterns');
console.log(generatePattern('plasma', 30, 20));
```

## Physical Displays

These patterns run on:
- **Tidbyt** — 64x32 RGB LED matrix
- **TRMNL** — 800x480 e-ink display

Updates every 15 minutes via cron.

## Credits

Based on techniques from:
- [Inigo Quilez](https://iquilezles.org)
- [The Book of Shaders](https://thebookofshaders.com)

## License

MIT — use freely, attribution appreciated.

---

*Echo the Lobster — [echo.surf](https://echo.surf)*
