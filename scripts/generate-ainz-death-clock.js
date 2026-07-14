const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const outputDirectory = path.resolve(__dirname, '..', 'imports', 'Common', 'Effect', 'Form', 'Debuff');
const mdxPath = path.join(outputDirectory, 'AinzDeathClock.mdx');
const previewPath = path.join(process.env.TEMP || outputDirectory, 'AinzDeathClock-preview.svg');
const previewPpmPath = path.join(process.env.TEMP || outputDirectory, 'AinzDeathClock-preview.ppm');

const centerZ = 126;
const clockRadius = 130;

function formatNumber(value) {
  const rounded = Math.abs(value) < 0.000001 ? 0 : value;
  return Number(rounded.toFixed(6)).toString();
}

function vector(values) {
  return `{ ${values.map(formatNumber).join(', ')} }`;
}

function createGeometry(vertices, faces, materialId = 0, matrixId = 0) {
  return { vertices, faces, materialId, matrixId };
}

function disc(radius, segments = 72, x = 0.1) {
  const vertices = [[x, 0, centerZ]];
  const faces = [];
  for (let index = 0; index < segments; index += 1) {
    const angle = (Math.PI * 2 * index) / segments;
    vertices.push([x, Math.cos(angle) * radius, centerZ + Math.sin(angle) * radius]);
  }
  for (let index = 0; index < segments; index += 1) {
    faces.push(0, index + 1, ((index + 1) % segments) + 1);
  }
  return createGeometry(vertices, faces);
}

function annulus(innerRadius, outerRadius, segments = 72, x = 0.5, materialId = 1) {
  const vertices = [];
  const faces = [];
  for (let index = 0; index < segments; index += 1) {
    const angle = (Math.PI * 2 * index) / segments;
    const cosine = Math.cos(angle);
    const sine = Math.sin(angle);
    vertices.push([x, cosine * innerRadius, centerZ + sine * innerRadius]);
    vertices.push([x, cosine * outerRadius, centerZ + sine * outerRadius]);
  }
  for (let index = 0; index < segments; index += 1) {
    const currentInner = index * 2;
    const currentOuter = currentInner + 1;
    const nextInner = ((index + 1) % segments) * 2;
    const nextOuter = nextInner + 1;
    faces.push(currentInner, currentOuter, nextOuter, currentInner, nextOuter, nextInner);
  }
  return createGeometry(vertices, faces, materialId);
}

function radialPlate(angle, innerRadius, outerRadius, halfWidth, x = 0.8, materialId = 1) {
  const radialY = Math.cos(angle);
  const radialZ = Math.sin(angle);
  const tangentY = -radialZ;
  const tangentZ = radialY;
  const point = (radius, side) => [
    x,
    radialY * radius + tangentY * halfWidth * side,
    centerZ + radialZ * radius + tangentZ * halfWidth * side,
  ];
  return createGeometry(
    [point(innerRadius, -1), point(outerRadius, -1), point(outerRadius, 1), point(innerRadius, 1)],
    [0, 1, 2, 0, 2, 3],
    materialId,
  );
}

function mergeGeometries(geometries, materialId = 1) {
  const vertices = [];
  const faces = [];
  for (const geometry of geometries) {
    const offset = vertices.length;
    vertices.push(...geometry.vertices);
    faces.push(...geometry.faces.map((face) => face + offset));
  }
  return createGeometry(vertices, faces, materialId);
}

function hand(length, halfWidth, tipWidth, x, materialId, matrixId) {
  const tail = 13;
  const bodyEnd = length - 13;
  const vertices = [
    [x, -halfWidth, centerZ - tail],
    [x, -halfWidth, centerZ + bodyEnd],
    [x, halfWidth, centerZ + bodyEnd],
    [x, halfWidth, centerZ - tail],
    [x, 0, centerZ + length],
    [x, -tipWidth, centerZ + bodyEnd],
    [x, tipWidth, centerZ + bodyEnd],
  ];
  return createGeometry(vertices, [0, 1, 2, 0, 2, 3, 5, 4, 6], materialId, matrixId);
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

function geosetBlock(geometry) {
  const { vertices, faces, materialId, matrixId } = geometry;
  const { minimum, maximum } = extentFor(vertices);
  const normals = vertices.map(() => [1, 0, 0]);
  const textureVertices = vertices.map((vertex) => [
    (vertex[1] + clockRadius) / (clockRadius * 2),
    (vertex[2] - centerZ + clockRadius) / (clockRadius * 2),
  ]);
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

function quaternionForXRotation(angle) {
  return [Math.sin(angle / 2), 0, 0, Math.cos(angle / 2)];
}

function rotationTrack() {
  const keys = [[0, quaternionForXRotation(0)], [600, quaternionForXRotation(0)], [700, quaternionForXRotation(0)]];
  for (let step = 0; step < 12; step += 1) {
    const stepStart = 700 + step * 1000;
    const currentAngle = -Math.PI * 2 * step / 12;
    const nextAngle = -Math.PI * 2 * (step + 1) / 12;
    keys.push([stepStart + 910, quaternionForXRotation(currentAngle)]);
    keys.push([stepStart + 1000, quaternionForXRotation(nextAngle)]);
  }
  return `Rotation ${keys.length} {
        Linear,
${keys.map(([time, rotation]) => `        ${formatNumber(time)}: ${vector(rotation)},`).join('\n')}
    }`;
}

const outerFrames = [];
for (let index = 0; index < 12; index += 1) {
  const angle = Math.PI / 2 - (Math.PI * 2 * index) / 12;
  const isCardinal = index % 3 === 0;
  outerFrames.push(radialPlate(angle, 112, 127, isCardinal ? 6.8 : 4.3, 1.0, 1));
}

const geometries = [
  { ...disc(106), materialId: 0 },
  annulus(122, 130, 96, 0.45, 1),
  annulus(106, 110, 96, 0.65, 1),
  mergeGeometries(outerFrames, 1),
  annulus(14, 20, 40, 1.05, 1),
  hand(98, 2.4, 6, 1.35, 1, 1),
];

for (let index = 0; index < 12; index += 1) {
  const angle = Math.PI / 2 - (Math.PI * 2 * index) / 12;
  const isCardinal = index % 3 === 0;
  geometries.push(radialPlate(angle, 113, 125, isCardinal ? 3.1 : 2.2, 1.25, 1));
}

const lifecycleAlpha = [[0, 0], [220, 0.42], [520, 1], [12700, 1], [13400, 0]];
const geosetAnimations = [
  geosetAnimationBlock(0, [0.012, 0.006, 0.06], [[0, 0], [220, 0.58], [520, 0.72], [12700, 0.72], [13400, 0]]),
  geosetAnimationBlock(1, [0.018, 0.045, 0.45], lifecycleAlpha),
  geosetAnimationBlock(2, [0.016, 0.006, 0.12], [[0, 0], [220, 0.25], [520, 0.45], [12700, 0.45], [13400, 0]]),
  geosetAnimationBlock(3, [0.018, 0.09, 0.30], lifecycleAlpha),
  geosetAnimationBlock(4, [0.015, 0.06, 0.70], lifecycleAlpha),
  geosetAnimationBlock(5, [0.025, 0.10, 0.92], lifecycleAlpha),
];

for (let index = 0; index < 12; index += 1) {
  const offTime = 700 + (index + 1) * 1000;
  geosetAnimations.push(geosetAnimationBlock(6 + index, [0.025, 0.12, 0.92], [
    [0, 0],
    [220, 0.62],
    [520, 1],
    [700, 1],
    [offTime - 140, 1],
    [offTime, 0],
    [13400, 0],
  ]));
}

const mdl = `Version {
    FormatVersion 800,
}
Model "AinzDeathClock" {
    BlendTime 150,
    MinimumExtent { -3, -140, -14 },
    MaximumExtent { 3, 140, 266 },
    BoundsRadius 190,
}
Sequences 3 {
    Anim "Birth" {
        Interval { 0, 600 },
        NonLooping,
        MinimumExtent { -3, -140, -14 },
        MaximumExtent { 3, 140, 266 },
        BoundsRadius 190,
    }
    Anim "Stand" {
        Interval { 700, 12700 },
        NonLooping,
        MinimumExtent { -3, -140, -14 },
        MaximumExtent { 3, 140, 266 },
        BoundsRadius 190,
    }
    Anim "Death" {
        Interval { 12800, 13400 },
        NonLooping,
        MinimumExtent { -3, -140, -14 },
        MaximumExtent { 3, 140, 266 },
        BoundsRadius 190,
    }
}
Textures 1 {
    Bitmap {
        Image "Textures\\white.blp",
    }
}
Materials 2 {
    Material {
        Layer {
            FilterMode Blend,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 0,
        }
    }
    Material {
        Layer {
            FilterMode Additive,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 0,
        }
    }
}
${geometries.map(geosetBlock).join('\n')}
${geosetAnimations.join('\n')}
Bone "AinzDeathClockRoot" {
    ObjectId 0,
    Billboarded,
    GeosetId Multiple,
    GeosetAnimId None,
    Scaling 5 {
        Linear,
        0: { 0.52, 0.52, 0.52 },
        220: { 0.9, 0.9, 0.9 },
        520: { 1.07, 1.07, 1.07 },
        700: { 1, 1, 1 },
        13400: { 1.1, 1.1, 1.1 },
    }
}
Bone "AinzDeathClockMinuteHand" {
    ObjectId 1,
    Parent 0,
    GeosetId 5,
    GeosetAnimId None,
    ${rotationTrack()}
}
PivotPoints 2 {
    { 0, 0, 126 },
    { 0, 0, 126 },
}
`;

fs.mkdirSync(outputDirectory, { recursive: true });

const model = new Model();
model.loadMdl(mdl);
fs.writeFileSync(mdxPath, model.saveMdx());

const verified = new Model();
verified.loadMdx(fs.readFileSync(mdxPath));
if (verified.name !== 'AinzDeathClock' || verified.geosets.length !== 18 || verified.sequences.length !== 3 || verified.bones.length !== 2) {
  throw new Error('Generated MDX did not pass structural verification');
}
if (verified.textures.length !== 1 || verified.textures[0].path !== 'Textures\\white.blp') {
  throw new Error('Generated MDX texture path verification failed');
}

const remainingTicks = 6;
const tickSvg = Array.from({ length: 12 }, (_, index) => {
  const angle = index * 30;
  const lit = index >= remainingTicks;
  return `<rect x="394" y="86" width="12" height="46" rx="3" transform="rotate(${angle} 400 400)" fill="${lit ? '#ed260a' : '#35100a'}" opacity="${lit ? '1' : '0.38'}"/>`;
}).join('\n        ');
const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="800" viewBox="0 0 800 800">
  <defs>
    <radialGradient id="void"><stop stop-color="#1d0207"/><stop offset="0.72" stop-color="#080105"/><stop offset="1" stop-color="#030204"/></radialGradient>
    <filter id="glow"><feGaussianBlur stdDeviation="8" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  </defs>
  <rect width="800" height="800" fill="#050308"/>
  <circle cx="400" cy="400" r="292" fill="url(#void)" stroke="#6b160d" stroke-width="18"/>
  <circle cx="400" cy="400" r="248" fill="none" stroke="#3d080c" stroke-width="8"/>
  <g filter="url(#glow)">
    ${tickSvg}
    <circle cx="400" cy="400" r="38" fill="#350008" stroke="#c51b08" stroke-width="7"/>
    <path d="M400 410 L400 630" stroke="#ff350d" stroke-width="11" stroke-linecap="round"/>
  </g>
  <circle cx="400" cy="400" r="12" fill="#ff4b1b"/>
  <text x="400" y="746" text-anchor="middle" fill="#b78976" font-family="serif" font-size="24" letter-spacing="3">AINZ · DEATH CLOCK · 6 / 12</text>
</svg>`;
fs.writeFileSync(previewPath, svg, 'utf8');

const previewSize = 800;
const pixels = Buffer.alloc(previewSize * previewSize * 3);
const clampByte = (value) => Math.max(0, Math.min(255, Math.round(value)));
for (let py = 0; py < previewSize; py += 1) {
  for (let px = 0; px < previewSize; px += 1) {
    const dx = px - 400;
    const dy = 400 - py;
    const radius = Math.sqrt(dx * dx + dy * dy);
    let red = 5;
    let green = 3;
    let blue = 8;

    if (radius < 292) {
      const voidStrength = 1 - radius / 292;
      red += 18 * voidStrength;
      blue += 7 * voidStrength;
    }

    const outerRing = Math.exp(-(((radius - 292) / 12) ** 2));
    const innerRing = Math.exp(-(((radius - 248) / 7) ** 2));
    red += 95 * outerRing + 42 * innerRing;
    green += 10 * outerRing;
    blue += 7 * outerRing + 5 * innerRing;

    for (let index = 0; index < 12; index += 1) {
      const angle = Math.PI / 2 - (Math.PI * 2 * index) / 12;
      const radial = dx * Math.cos(angle) + dy * Math.sin(angle);
      const tangent = -dx * Math.sin(angle) + dy * Math.cos(angle);
      const lit = index >= remainingTicks;
      const plate = Math.max(0, 1 - Math.abs(tangent) / 10) * Math.max(0, 1 - Math.abs(radial - 270) / 29);
      red += plate * (lit ? 220 : 34);
      green += plate * (lit ? 24 : 5);
      blue += plate * (lit ? 8 : 4);
    }

    const minuteHand = Math.abs(dx) < 6 && dy < -16 && dy > -224;
    if (minuteHand) {
      red += 245;
      green += 32;
      blue += 9;
    }

    const hub = Math.sqrt(dx * dx + dy * dy);
    if (hub < 34) {
      red += 150;
      green += 12;
      blue += 7;
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
  textures: verified.textures.map((texture) => texture.path),
}, null, 2));
