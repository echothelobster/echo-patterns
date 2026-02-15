/**
 * TRMNL ASCII Art Patterns
 * Echo the Lobster | echo.surf
 * 
 * Generates ASCII art using Unicode block elements for e-ink displays.
 */

const BLOCKS = ' ░▒▓█';

// Noise functions
function hash(x, y) {
  const n = Math.sin(x * 12.9898 + y * 78.233) * 43758.5453;
  return n - Math.floor(n);
}

function smoothNoise(x, y, scale = 8) {
  const sx = x / scale, sy = y / scale;
  const x0 = Math.floor(sx), y0 = Math.floor(sy);
  const fx = sx - x0, fy = sy - y0;
  const v00 = hash(x0, y0), v10 = hash(x0 + 1, y0);
  const v01 = hash(x0, y0 + 1), v11 = hash(x0 + 1, y0 + 1);
  return (v00 * (1-fx) + v10 * fx) * (1-fy) + (v01 * (1-fx) + v11 * fx) * fy;
}

function fbm(x, y, octaves, time) {
  let v = 0, a = 0.5, f = 1;
  for (let i = 0; i < octaves; i++) {
    v += a * smoothNoise(x * f + time, y * f);
    a *= 0.5; f *= 2;
  }
  return v;
}

// Pattern generators
const patterns = {
  noiseFlow: (w, h, t) => {
    let art = '';
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const n = fbm(x * 0.1, y * 0.15, 4, t * 0.5);
        art += BLOCKS[Math.floor(n * 4.99)];
      }
      art += '\n';
    }
    return art;
  },

  plasma: (w, h, t) => {
    let art = '';
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const v1 = Math.sin(x * 0.15 + t);
        const v2 = Math.sin((x * 0.1 + y * 0.1) + t * 0.5);
        const v3 = Math.sin(Math.sqrt((x-w/2)**2 + (y-h/2)**2) * 0.15 - t);
        const v = (v1 + v2 + v3) / 3;
        const n = (v + 1) / 2;
        art += BLOCKS[Math.floor(n * 4.99)];
      }
      art += '\n';
    }
    return art;
  },

  voronoi: (w, h, t) => {
    const points = [];
    for (let i = 0; i < 8; i++) {
      points.push({
        x: (hash(i, Math.floor(t * 0.1)) * 0.8 + 0.1) * w,
        y: (hash(i + 100, Math.floor(t * 0.1)) * 0.8 + 0.1) * h
      });
    }
    let art = '';
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        let min1 = Infinity, min2 = Infinity;
        for (const p of points) {
          const d = Math.sqrt((x-p.x)**2 + (y-p.y)**2);
          if (d < min1) { min2 = min1; min1 = d; }
          else if (d < min2) { min2 = d; }
        }
        const n = Math.min(1, (min2 - min1) / 8);
        art += BLOCKS[Math.floor(n * 4.99)];
      }
      art += '\n';
    }
    return art;
  },

  interference: (w, h, t) => {
    let art = '';
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const d1 = Math.sqrt((x - w*0.3)**2 + (y - h*0.5)**2);
        const d2 = Math.sqrt((x - w*0.7)**2 + (y - h*0.5)**2);
        const wave = (Math.sin(d1 * 0.5 - t) + Math.sin(d2 * 0.4 + t * 0.7)) / 2;
        const n = (wave + 1) / 2;
        art += BLOCKS[Math.floor(n * 4.99)];
      }
      art += '\n';
    }
    return art;
  },

  domainWarp: (w, h, t) => {
    let art = '';
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const scale = 0.08;
        const wx = x * scale + fbm(x * scale, y * scale, 3, t) * 3;
        const wy = y * scale + fbm(x * scale + 5.2, y * scale + 1.3, 3, t) * 3;
        const n = fbm(wx, wy, 2, t * 0.5);
        art += BLOCKS[Math.floor(n * 4.99)];
      }
      art += '\n';
    }
    return art;
  },

  moire: (w, h, t) => {
    let art = '';
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const cx = w / 2 + Math.sin(t) * 10;
        const cy = h / 2 + Math.cos(t * 0.7) * 5;
        const d1 = Math.sqrt(x * x + y * y);
        const d2 = Math.sqrt((x - cx)**2 + (y - cy)**2);
        const v = (Math.sin(d1 * 0.4) + Math.sin(d2 * 0.5)) / 2;
        const n = (v + 1) / 2;
        art += BLOCKS[Math.floor(n * 4.99)];
      }
      art += '\n';
    }
    return art;
  },

  raymarch: (w, h, t) => {
    let art = '';
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const u = (x / w - 0.5) * 2;
        const v = (y / h - 0.5) * 2;
        const r = 0.6 + Math.sin(t) * 0.1;
        const d = Math.sqrt(u*u + v*v) - r;
        const ripple = Math.sin(Math.sqrt(u*u + v*v) * 10 - t * 2) * 0.05;
        const n = 1 - Math.min(1, Math.max(0, d + ripple + 0.5));
        art += BLOCKS[Math.floor(n * 4.99)];
      }
      art += '\n';
    }
    return art;
  },

  reaction: (w, h, t) => {
    let art = '';
    for (let y = 0; y < h; y++) {
      for (let x = 0; x < w; x++) {
        const n1 = smoothNoise(x + t * 10, y, 12);
        const n2 = smoothNoise(x, y + t * 8, 8);
        const n3 = smoothNoise(x * 2 + t * 5, y * 2, 6);
        const v = Math.sin(n1 * 6 + n2 * 4 + n3 * 8 + t);
        const n = (v + 1) / 2;
        art += BLOCKS[Math.floor(n * 4.99)];
      }
      art += '\n';
    }
    return art;
  }
};

function generatePattern(name, width = 30, height = 20, time = Date.now() / 1000) {
  const fn = patterns[name] || patterns.plasma;
  return fn(width, height, time);
}

function listPatterns() {
  return Object.keys(patterns);
}

module.exports = { generatePattern, listPatterns, patterns };
