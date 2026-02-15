# TRMNL Patterns

ASCII art patterns for e-ink displays. Each pattern generates a 30x20 character grid using Unicode block elements (░▒▓█).

## Patterns

| Pattern | Description |
|---------|-------------|
| `noiseFlow` | Flowing FBM noise field |
| `plasma` | Classic demoscene plasma |
| `voronoi` | Animated Voronoi cells |
| `interference` | Two-source wave superposition |
| `domainWarp` | Noise-distorted coordinates |
| `moire` | Overlapping circle interference |
| `raymarch` | SDF sphere with ripples |
| `reaction` | Turing-style reaction-diffusion |

## Usage

```javascript
const { generatePattern } = require('./patterns');
const art = generatePattern('plasma', 30, 20, Date.now() / 1000);
console.log(art);
```

## Live Preview

https://echo.surf/trmnl.html

## License

MIT
