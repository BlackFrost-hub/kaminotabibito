const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const outputDirectory = path.resolve(__dirname, '..', 'imports', 'Common', 'Effect', 'Form', 'Debuff');
const mdxPath = path.join(outputDirectory, 'AinzHeartCountdown.mdx');
const previewPath = path.join(process.env.TEMP || outputDirectory, 'AinzHeartCountdown-preview.svg');
const previewPpmPath = path.join(process.env.TEMP || outputDirectory, 'AinzHeartCountdown-preview.ppm');

function formatNumber(value) {
  const rounded = Math.abs(value) < 0.000001 ? 0 : value;
  return Number(rounded.toFixed(6)).toString();
}

function vector(values) {
  return `{ ${values.map(formatNumber).join(', ')} }`;
}

function texturedHeartRelief(centerZ, halfWidth, halfHeight, segments = 12, depth = 18) {
  const vertices = [];
  const normals = [];
  const textureVertices = [];
  const faces = [];
  for (let row = 0; row <= segments; row += 1) {
    const v = row / segments;
    const normalizedZ = (0.5 - v) * 2;
    for (let column = 0; column <= segments; column += 1) {
      const u = column / segments;
      const normalizedY = (u - 0.5) * 2;
      const radiusSquared = Math.min(1, normalizedY * normalizedY + normalizedZ * normalizedZ);
      const relief = depth * (1 - radiusSquared) ** 1.35;
      vertices.push([
        -relief,
        normalizedY * halfWidth,
        centerZ + normalizedZ * halfHeight,
      ]);
      const normal = [-1, -normalizedY * 0.42, -normalizedZ * 0.42];
      const normalLength = Math.hypot(...normal);
      normals.push(normal.map((value) => value / normalLength));
      textureVertices.push([u, v]);
    }
  }
  const rowLength = segments + 1;
  for (let row = 0; row < segments; row += 1) {
    for (let column = 0; column < segments; column += 1) {
      const current = row * rowLength + column;
      const next = current + rowLength;
      faces.push(current, next, next + 1, current, next + 1, current + 1);
    }
  }
  return { vertices, normals, faces, textureVertices, materialId: 1, matrixId: 1 };
}

function annulus(centerZ, innerRadius, outerRadius, segments = 64) {
  const vertices = [];
  const faces = [];
  for (let i = 0; i < segments; i += 1) {
    const angle = (Math.PI * 2 * i) / segments;
    const cos = Math.cos(angle);
    const sin = Math.sin(angle);
    vertices.push([0.8, cos * innerRadius, centerZ + sin * innerRadius]);
    vertices.push([0.8, cos * outerRadius, centerZ + sin * outerRadius]);
  }
  for (let i = 0; i < segments; i += 1) {
    const currentInner = i * 2;
    const currentOuter = currentInner + 1;
    const nextInner = ((i + 1) % segments) * 2;
    const nextOuter = nextInner + 1;
    faces.push(currentInner, currentOuter, nextOuter, currentInner, nextOuter, nextInner);
  }
  return { vertices, faces };
}

function radialTick(centerZ, angle, innerRadius, outerRadius, halfWidth) {
  const radialY = Math.cos(angle);
  const radialZ = Math.sin(angle);
  const tangentY = -radialZ;
  const tangentZ = radialY;
  const point = (radius, side) => [
    1.2,
    radialY * radius + tangentY * halfWidth * side,
    centerZ + radialZ * radius + tangentZ * halfWidth * side,
  ];
  return {
    vertices: [point(innerRadius, -1), point(outerRadius, -1), point(outerRadius, 1), point(innerRadius, 1)],
    faces: [0, 1, 2, 0, 2, 3],
  };
}

function extentFor(vertices) {
  const minimum = [Infinity, Infinity, Infinity];
  const maximum = [-Infinity, -Infinity, -Infinity];
  for (const vertex of vertices) {
    for (let axis = 0; axis < 3; axis += 1) {
      minimum[axis] = Math.min(minimum[axis], vertex[axis]);
      maximum[axis] = Math.max(maximum[axis], vertex[axis]);
    }
  }
  return { minimum, maximum };
}

function geosetBlock(geometry, geosetAnimationId) {
  const { vertices, faces } = geometry;
  const { minimum, maximum } = extentFor(vertices);
  const normals = geometry.normals || vertices.map(() => [1, 0, 0]);
  const textureVertices = geometry.textureVertices || vertices.map((vertex) => [(vertex[1] + 150) / 300, (vertex[2] - centerZ + 150) / 300]);
  const materialId = geometry.materialId || 0;
  const matrixId = geometry.matrixId || 0;
  return `Geoset {
    Vertices ${vertices.length} {
${vertices.map((vertex) => `        ${vector(vertex)},`).join('\n')}
    }
    Normals ${normals.length} {
${normals.map((normal) => `        ${vector(normal)},`).join('\n')}
    }
    TVertices ${textureVertices.length} {
${textureVertices.map((uv) => `        ${vector(uv)},`).join('\n')}
    }
    VertexGroup {
${vertices.map(() => '        0,').join('\n')}
    }
    Faces 1 ${faces.length} {
        Triangles {
            { ${faces.join(', ')} },
        }
    }
    Groups 1 1 {
        Matrices { ${matrixId} },
    }
    MinimumExtent ${vector(minimum)},
    MaximumExtent ${vector(maximum)},
    BoundsRadius 180,
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius 180,
    }
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius 180,
    }
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius 180,
    }
    MaterialID ${materialId},
    SelectionGroup 0,
}`;
}

function alphaTrack(entries) {
  return `Alpha ${entries.length} {
        Linear,
${entries.map(([time, alpha]) => `        ${time}: ${formatNumber(alpha)},`).join('\n')}
    }`;
}

function geosetAnimationBlock(geosetId, color, alphaEntries) {
  return `GeosetAnim {
    ${alphaTrack(alphaEntries)}
    static Color ${vector(color)},
    GeosetId ${geosetId},
}`;
}

const centerZ = 110;
const geometries = [
  texturedHeartRelief(centerZ, 82, 82),
  annulus(centerZ, 105, 111),
];

for (let index = 0; index < 12; index += 1) {
  const angle = Math.PI / 2 - (Math.PI * 2 * index) / 12;
  geometries.push(radialTick(centerZ, angle, 118, 136, 3.8));
}

const lifecycleAlpha = [[0, 0], [300, 1], [600, 1], [700, 1], [12700, 1], [13400, 0]];
const geosetAnimations = [
  geosetAnimationBlock(0, [1, 1, 1], lifecycleAlpha),
  geosetAnimationBlock(1, [0.02, 0.06, 0.85], [[0, 0], [300, 0.75], [600, 0.75], [700, 0.75], [12700, 0.75], [13400, 0]]),
];

for (let index = 0; index < 12; index += 1) {
  const offTime = 1700 + index * 1000;
  geosetAnimations.push(geosetAnimationBlock(2 + index, [0.01, 0.08, 1], [
    [0, 0],
    [300, 1],
    [600, 1],
    [700, 1],
    [offTime - 120, 1],
    [offTime, 0],
    [13400, 0],
  ]));
}

function scalingKey(time, scale) {
  return `        ${time}: ${vector(scale)},`;
}

const heartbeatKeys = [[0, [1, 1, 1]], [300, [1, 1, 1]], [600, [1, 1, 1]]];
for (let beatStart = 700; beatStart < 12700;) {
  const period = beatStart < 8700 ? 900 : beatStart < 10700 ? 650 : 450;
  const beat = [
    [beatStart, [1, 1, 1]],
    [beatStart + 65, [1, 0.94, 0.9]],
    [beatStart + 145, [1, 1.075, 1.1]],
    [beatStart + 245, [1, 1, 1]],
    [beatStart + 325, [1, 1.025, 1.035]],
    [beatStart + 405, [1, 1, 1]],
  ];
  heartbeatKeys.push(...beat.filter(([time]) => time <= 12700));
  beatStart += period;
}
heartbeatKeys.push([12800, [1, 1, 1]], [13050, [1, 0.72, 0.65]], [13400, [1, 0.18, 0.12]]);

const mdl = `Version {
    FormatVersion 800,
}
Model "AinzHeartCountdown" {
    BlendTime 150,
    MinimumExtent { -20, -145, -35 },
    MaximumExtent { 2, 145, 255 },
    BoundsRadius 190,
}
Sequences 3 {
    Anim "Birth" {
        Interval { 0, 600 },
        NonLooping,
        MinimumExtent { -20, -145, -35 },
        MaximumExtent { 2, 145, 255 },
        BoundsRadius 190,
    }
    Anim "Stand" {
        Interval { 700, 12700 },
        NonLooping,
        MinimumExtent { -20, -145, -35 },
        MaximumExtent { 2, 145, 255 },
        BoundsRadius 190,
    }
    Anim "Death" {
        Interval { 12800, 13400 },
        NonLooping,
        MinimumExtent { -20, -145, -35 },
        MaximumExtent { 2, 145, 255 },
        BoundsRadius 190,
    }
}
Textures 2 {
    Bitmap {
        Image "Textures\\white.blp",
    }
    Bitmap {
        Image "Common\\Effect\\Form\\Debuff\\Texture\\AinzHeartAnatomical.blp",
    }
}
Materials 2 {
    Material {
        Layer {
            FilterMode Additive,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 0,
        }
    }
    Material {
        Layer {
            FilterMode Blend,
            TwoSided,
            Unfogged,
            static TextureID 1,
        }
    }
}
${geometries.map((geometry, index) => geosetBlock(geometry, index)).join('\n')}
${geosetAnimations.join('\n')}
Bone "AinzHeartRoot" {
    ObjectId 0,
    Billboarded,
    GeosetId Multiple,
    GeosetAnimId None,
}
Bone "AinzHeartPulse" {
    ObjectId 1,
    Parent 0,
    GeosetId 0,
    GeosetAnimId 0,
    Scaling ${heartbeatKeys.length} {
        Linear,
${heartbeatKeys.map(([time, scale]) => scalingKey(time, scale)).join('\n')}
    }
}
PivotPoints 2 {
    { 0, 0, 110 },
    { 0, 0, 110 },
}
`;

fs.mkdirSync(outputDirectory, { recursive: true });

const model = new Model();
model.loadMdl(mdl);
fs.writeFileSync(mdxPath, model.saveMdx());

const verified = new Model();
verified.loadMdx(fs.readFileSync(mdxPath));
if (verified.name !== 'AinzHeartCountdown' || verified.geosets.length !== 14 || verified.sequences.length !== 3 || verified.bones.length !== 2) {
  throw new Error('Generated MDX did not pass structural verification');
}

const tickSvg = Array.from({ length: 12 }, (_, index) => {
  const angle = -90 + index * 30;
  return `<rect x="296" y="28" width="8" height="36" rx="3" transform="rotate(${angle} 300 300)"/>`;
}).join('\n        ');
const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="600" height="600" viewBox="0 0 600 600">
  <defs>
    <filter id="glow"><feGaussianBlur stdDeviation="9" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
    <radialGradient id="heart" cx="48%" cy="42%"><stop offset="0" stop-color="#fff2f3"/><stop offset="0.3" stop-color="#ff4052"/><stop offset="1" stop-color="#8f0015"/></radialGradient>
  </defs>
  <rect width="600" height="600" fill="#060309"/>
  <g filter="url(#glow)" fill="#ff1738">
    <circle cx="300" cy="300" r="221" fill="none" stroke="#b80025" stroke-width="10" opacity="0.8"/>
    ${tickSvg}
    <ellipse cx="300" cy="300" rx="104" ry="122" fill="#b20b22" opacity="0.9"/>
  </g>
  <circle cx="300" cy="300" r="150" fill="none" stroke="#ff203d" stroke-width="2" opacity="0.3"/>
  <text x="300" y="560" text-anchor="middle" fill="#cfa9af" font-family="sans-serif" font-size="19">AINZ · HEART COUNTDOWN · 12s</text>
</svg>`;
fs.writeFileSync(previewPath, svg, 'utf8');

const previewSize = 600;
const pixels = Buffer.alloc(previewSize * previewSize * 3);
const clampByte = (value) => Math.max(0, Math.min(255, Math.round(value)));
for (let py = 0; py < previewSize; py += 1) {
  for (let px = 0; px < previewSize; px += 1) {
    const dx = px - 300;
    const dy = 300 - py;
    const radius = Math.sqrt(dx * dx + dy * dy);
    let red = 6;
    let green = 3;
    let blue = 9;

    const ringGlow = Math.exp(-(((radius - 221) / 13) ** 2));
    red += 145 * ringGlow;
    green += 7 * ringGlow;
    blue += 28 * ringGlow;
    if (Math.abs(radius - 221) < 4.5) {
      red += 100;
      green += 10;
      blue += 25;
    }

    for (let tickIndex = 0; tickIndex < 12; tickIndex += 1) {
      const angle = Math.PI / 2 - (Math.PI * 2 * tickIndex) / 12;
      const radial = dx * Math.cos(angle) + dy * Math.sin(angle);
      const tangent = -dx * Math.sin(angle) + dy * Math.cos(angle);
      const tickGlow = Math.max(0, 1 - Math.abs(tangent) / 15) * Math.max(0, 1 - Math.abs(radial - 254) / 38);
      red += 35 * tickGlow;
      blue += 8 * tickGlow;
      if (radial >= 236 && radial <= 272 && Math.abs(tangent) <= 4) {
        red += 175;
        green += 18;
        blue += 35;
      }
    }

    const hx = dx / 95;
    const hy = (dy - 8) / 92;
    const heartEquation = (hx * hx + hy * hy - 1) ** 3 - hx * hx * hy ** 3;
    if (heartEquation <= 0) {
      const highlight = Math.max(0, 1 - Math.sqrt((hx + 0.25) ** 2 + (hy - 0.35) ** 2) / 1.1);
      red += 150 + 85 * highlight;
      green += 9 + 48 * highlight;
      blue += 18 + 50 * highlight;
    } else if (heartEquation < 0.45) {
      const heartGlow = Math.max(0, 1 - heartEquation / 0.45);
      red += 95 * heartGlow;
      green += 4 * heartGlow;
      blue += 18 * heartGlow;
    }

    const offset = (py * previewSize + px) * 3;
    pixels[offset] = clampByte(red);
    pixels[offset + 1] = clampByte(green);
    pixels[offset + 2] = clampByte(blue);
  }
}
fs.writeFileSync(previewPpmPath, Buffer.concat([Buffer.from(`P6\n${previewSize} ${previewSize}\n255\n`), pixels]));

process.stdout.write(JSON.stringify({
  mdxPath,
  previewPath,
  previewPpmPath,
  byteLength: fs.statSync(mdxPath).size,
  geosets: verified.geosets.length,
  sequences: verified.sequences.map((sequence) => sequence.name),
}, null, 2));
