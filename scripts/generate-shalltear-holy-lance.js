const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const outputDirectory = path.resolve(__dirname, '..', 'imports', 'Common', 'Effect', 'Form', 'RiseFall');
const mdxPath = path.join(outputDirectory, 'ShalltearHolyLance.mdx');
const previewPath = path.resolve(__dirname, '..', 'image_temp', 'ShalltearHolyLance-preview.svg');
const minimumExtent = [-32, -32, 0];
const maximumExtent = [32, 32, 252];
const boundsRadius = 258;

function formatNumber(value) {
  const rounded = Math.abs(value) < 0.000001 ? 0 : value;
  return Number(rounded.toFixed(6)).toString();
}

function vector(values) {
  return `{ ${values.map(formatNumber).join(', ')} }`;
}

function geometry(vertices, faces, materialId, matrixId, textureVertices) {
  return { vertices, faces, materialId, matrixId, textureVertices };
}

function prism(radius, bottom, top, sides, materialId, matrixId) {
  const vertices = [];
  const faces = [];
  for (let index = 0; index < sides; index += 1) {
    const angle = Math.PI * 2 * index / sides;
    const x = Math.cos(angle) * radius;
    const y = Math.sin(angle) * radius;
    vertices.push([x, y, bottom], [x, y, top]);
  }
  for (let index = 0; index < sides; index += 1) {
    const next = (index + 1) % sides;
    const a = index * 2;
    const b = next * 2;
    faces.push(a, b, b + 1, a, b + 1, a + 1);
  }
  return geometry(vertices, faces, materialId, matrixId);
}

function spearHead(radius, tip, shoulder, neck, sides, materialId, matrixId) {
  const vertices = [[0, 0, tip], [0, 0, neck]];
  const faces = [];
  for (let index = 0; index < sides; index += 1) {
    const angle = Math.PI * 2 * index / sides + Math.PI / 4;
    vertices.push([Math.cos(angle) * radius, Math.sin(angle) * radius, shoulder]);
  }
  for (let index = 0; index < sides; index += 1) {
    const current = index + 2;
    const next = ((index + 1) % sides) + 2;
    faces.push(0, next, current, 1, current, next);
  }
  return geometry(vertices, faces, materialId, matrixId);
}

function planeRectangle(axis, halfWidth, bottom, top, materialId, matrixId) {
  const vertices = axis === 'x'
    ? [[-halfWidth, 0, bottom], [halfWidth, 0, bottom], [halfWidth, 0, top], [-halfWidth, 0, top]]
    : [[0, -halfWidth, bottom], [0, halfWidth, bottom], [0, halfWidth, top], [0, -halfWidth, top]];
  return geometry(vertices, [0, 1, 2, 0, 2, 3], materialId, matrixId);
}

function planeDiamond(axis, halfWidth, tip, shoulder, neck, materialId, matrixId) {
  const vertices = axis === 'x'
    ? [[0, 0, tip], [-halfWidth, 0, shoulder], [0, 0, neck], [halfWidth, 0, shoulder]]
    : [[0, 0, tip], [0, -halfWidth, shoulder], [0, 0, neck], [0, halfWidth, shoulder]];
  return geometry(vertices, [0, 1, 2, 0, 2, 3], materialId, matrixId);
}

function guardWing(axis, side, materialId, matrixId) {
  const sign = side < 0 ? -1 : 1;
  const vertices = axis === 'x'
    ? [[3 * sign, 0, 52], [20 * sign, 0, 61], [14 * sign, 0, 50], [20 * sign, 0, 43], [3 * sign, 0, 48]]
    : [[0, 3 * sign, 52], [0, 20 * sign, 61], [0, 14 * sign, 50], [0, 20 * sign, 43], [0, 3 * sign, 48]];
  return geometry(vertices, [0, 1, 2, 0, 2, 4, 4, 2, 3], materialId, matrixId);
}

function annulus(innerRadius, outerRadius, segments, z, materialId, matrixId) {
  const vertices = [];
  const faces = [];
  for (let index = 0; index < segments; index += 1) {
    const angle = Math.PI * 2 * index / segments;
    const cosine = Math.cos(angle);
    const sine = Math.sin(angle);
    vertices.push([cosine * innerRadius, sine * innerRadius, z]);
    vertices.push([cosine * outerRadius, sine * outerRadius, z]);
  }
  for (let index = 0; index < segments; index += 1) {
    const inner = index * 2;
    const outer = inner + 1;
    const nextInner = ((index + 1) % segments) * 2;
    const nextOuter = nextInner + 1;
    faces.push(inner, outer, nextOuter, inner, nextOuter, nextInner);
  }
  return geometry(vertices, faces, materialId, matrixId);
}

function radialRay(angle, innerRadius, outerRadius, halfWidth, z, materialId, matrixId) {
  const radialX = Math.cos(angle);
  const radialY = Math.sin(angle);
  const tangentX = -radialY;
  const tangentY = radialX;
  return geometry(
    [
      [radialX * innerRadius + tangentX * halfWidth, radialY * innerRadius + tangentY * halfWidth, z],
      [radialX * outerRadius, radialY * outerRadius, z],
      [radialX * innerRadius - tangentX * halfWidth, radialY * innerRadius - tangentY * halfWidth, z],
    ],
    [0, 1, 2],
    materialId,
    matrixId,
  );
}

function trailPlane(axis, materialId, matrixId) {
  const vertices = axis === 'x'
    ? [[-4, 0, 74], [4, 0, 74], [1.2, 0, 252], [-1.2, 0, 252]]
    : [[0, -4, 74], [0, 4, 74], [0, 1.2, 252], [0, -1.2, 252]];
  return geometry(vertices, [0, 1, 2, 0, 2, 3], materialId, matrixId);
}

function merge(parts, materialId, matrixId) {
  const vertices = [];
  const faces = [];
  const textureVertices = [];
  for (const part of parts) {
    const offset = vertices.length;
    vertices.push(...part.vertices);
    faces.push(...part.faces.map((face) => face + offset));
    textureVertices.push(...part.vertices.map((vertex) => [
      0.5 + vertex[0] / 80,
      vertex[2] / 260,
    ]));
  }
  return geometry(vertices, faces, materialId, matrixId, textureVertices);
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

function geosetBlock(item) {
  const { vertices, faces, materialId, matrixId, textureVertices } = item;
  const { minimum, maximum } = extentFor(vertices);
  const normals = vertices.map((vertex) => {
    const length = Math.hypot(vertex[0], vertex[1]) || 1;
    return [vertex[0] / length, vertex[1] / length, 0];
  });
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
    BoundsRadius ${boundsRadius},
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius ${boundsRadius},
    }
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius ${boundsRadius},
    }
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius ${boundsRadius},
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

const core = merge([
  prism(2.4, 48, 182, 6, 0, 0),
  spearHead(9.5, 2, 38, 58, 4, 0, 0),
], 0, 0);

const outline = merge([
  planeRectangle('x', 4.2, 48, 188, 1, 0),
  planeRectangle('y', 4.2, 48, 188, 1, 0),
  planeDiamond('x', 12, 0, 38, 60, 1, 0),
  planeDiamond('y', 12, 0, 38, 60, 1, 0),
  guardWing('x', -1, 1, 0), guardWing('x', 1, 1, 0),
  guardWing('y', -1, 1, 0), guardWing('y', 1, 1, 0),
], 1, 0);

const rays = [];
for (let index = 0; index < 8; index += 1) {
  rays.push(radialRay(Math.PI * 2 * index / 8, 23, index % 2 === 0 ? 38 : 32, 2.2, 3.2, 2, 1));
}
const halo = merge([
  annulus(18, 21.5, 64, 3, 2, 1),
  annulus(27, 28.5, 64, 3.1, 2, 1),
  ...rays,
], 2, 1);

const trail = merge([
  trailPlane('x', 3, 0),
  trailPlane('y', 3, 0),
], 3, 0);

const geometries = [core, outline, halo, trail];
const coreAlpha = [[0, 0], [80, 0.9], [420, 1], [650, 1], [700, 1], [2700, 1], [2800, 1], [3400, 0]];
const outlineAlpha = [[0, 0], [80, 0.65], [420, 0.9], [650, 0.72], [700, 0.68], [1700, 0.82], [2700, 0.68], [2800, 0.82], [3400, 0]];
const haloAlpha = [[0, 0], [340, 0], [460, 0.84], [650, 0.48], [700, 0.44], [1700, 0.62], [2700, 0.44], [2800, 0.64], [3400, 0]];
const trailAlpha = [[0, 0.82], [300, 0.82], [500, 0], [650, 0], [700, 0], [2700, 0], [2800, 0], [3400, 0]];

const mdl = `Version {
    FormatVersion 800,
}
Model "ShalltearHolyLance" {
    BlendTime 100,
    MinimumExtent ${vector(minimumExtent)},
    MaximumExtent ${vector(maximumExtent)},
    BoundsRadius ${boundsRadius},
}
Sequences 3 {
    Anim "Birth" {
        Interval { 0, 650 },
        NonLooping,
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
    Anim "Stand" {
        Interval { 700, 2700 },
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
    Anim "Death" {
        Interval { 2800, 3400 },
        NonLooping,
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
}
Textures 1 {
    Bitmap {
        Image "Textures\\white.blp",
    }
}
Materials 4 {
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
            FilterMode Additive,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 0,
        }
    }
}
${geometries.map(geosetBlock).join('\n')}
${geosetAnimationBlock(0, [0.58, 0.86, 1], coreAlpha)}
${geosetAnimationBlock(1, [0.2, 0.72, 1], outlineAlpha)}
${geosetAnimationBlock(2, [0.38, 0.82, 1], haloAlpha)}
${geosetAnimationBlock(3, [0.72, 0.94, 1], trailAlpha)}
Bone "ShalltearHolyLanceRoot" {
    ObjectId 0,
    GeosetId Multiple,
    GeosetAnimId None,
    Translation 8 {
        Linear,
        0: { 0, 0, 250 },
        300: { 0, 0, 92 },
        420: { 0, 0, 0 },
        650: { 0, 0, 0 },
        700: { 0, 0, 0 },
        2700: { 0, 0, 0 },
        2800: { 0, 0, 0 },
        3400: { 0, 0, 24 },
    }
    Scaling 8 {
        Linear,
        0: { 0.82, 0.82, 0.82 },
        300: { 0.96, 0.96, 0.96 },
        500: { 1.08, 1.08, 1.08 },
        650: { 1, 1, 1 },
        700: { 1, 1, 1 },
        2700: { 1, 1, 1 },
        2800: { 1, 1, 1 },
        3400: { 1.12, 1.12, 1.12 },
    }
}
Bone "ShalltearHolyLanceHalo" {
    ObjectId 1,
    Parent 0,
    GeosetId 2,
    GeosetAnimId 2,
    Scaling 8 {
        Linear,
        0: { 0.2, 0.2, 0.2 },
        340: { 0.2, 0.2, 0.2 },
        520: { 1.12, 1.12, 1.12 },
        650: { 1, 1, 1 },
        700: { 1, 1, 1 },
        1700: { 1.08, 1.08, 1.08 },
        2700: { 1, 1, 1 },
        3400: { 1.4, 1.4, 1.4 },
    }
}
PivotPoints 2 {
    { 0, 0, 0 },
    { 0, 0, 3 },
}
`;

const preview = `<svg xmlns="http://www.w3.org/2000/svg" width="520" height="760" viewBox="0 0 520 760">
  <defs>
    <linearGradient id="gold" x1="0" x2="1"><stop stop-color="#fff2b2"/><stop offset="0.5" stop-color="#fffdf0"/><stop offset="1" stop-color="#d5a82f"/></linearGradient>
    <filter id="glow"><feGaussianBlur stdDeviation="8" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  </defs>
  <rect width="520" height="760" fill="#111722"/>
  <ellipse cx="260" cy="678" rx="105" ry="26" fill="none" stroke="#d8b94c" stroke-width="5" opacity="0.75" filter="url(#glow)"/>
  <path d="M250 145 L270 145 L270 535 L302 514 L286 558 L260 604 L234 558 L218 514 L250 535 Z" fill="url(#gold)" stroke="#fff4bc" stroke-width="5" filter="url(#glow)"/>
  <path d="M250 520 L185 488 L214 535 L184 568 L250 548 M270 520 L335 488 L306 535 L336 568 L270 548" fill="none" stroke="#d9ad35" stroke-width="12" stroke-linejoin="round"/>
  <path d="M260 30 L260 150" stroke="#fff1a5" stroke-width="12" opacity="0.7" filter="url(#glow)"/>
  <text x="260" y="725" fill="#e8dfc4" font-size="18" text-anchor="middle">Shalltear Holy Lance · front preview</text>
</svg>`;

fs.mkdirSync(outputDirectory, { recursive: true });
fs.mkdirSync(path.dirname(previewPath), { recursive: true });
const model = new Model();
model.loadMdl(mdl);
fs.writeFileSync(mdxPath, model.saveMdx());
fs.writeFileSync(previewPath, preview, 'utf8');

const verified = new Model();
verified.loadMdx(fs.readFileSync(mdxPath));
if (verified.name !== 'ShalltearHolyLance' || verified.geosets.length !== 4 || verified.sequences.length !== 3 || verified.bones.length !== 2) {
  throw new Error('Generated MDX did not pass structural verification');
}
if (verified.textures.length !== 1 || verified.textures[0].path !== 'Textures\\white.blp') {
  throw new Error('Generated MDX texture verification failed');
}

process.stdout.write(JSON.stringify({
  mdxPath,
  previewPath,
  byteLength: fs.statSync(mdxPath).size,
  geosets: verified.geosets.length,
  bones: verified.bones.length,
  sequences: verified.sequences.map((sequence) => sequence.name),
  textures: verified.textures.map((texture) => texture.path),
}, null, 2));
