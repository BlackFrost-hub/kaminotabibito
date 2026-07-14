const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const outputDirectory = path.resolve(__dirname, '..', 'imports', 'Common', 'Effect', 'Form', 'Illusion');
const mdxPath = path.join(outputDirectory, 'ShalltearRoseMirrorRim.mdx');
const previewPath = path.resolve(__dirname, '..', 'image_temp', 'ShalltearRoseMirrorRim-preview.svg');
const rosePngPath = path.join(outputDirectory, 'Texture', 'ShalltearRoseMirrorRimRose.png');

const centerZ = 80;
const minimumExtent = [-18, -36, 32];
const maximumExtent = [8, 36, 128];
const boundsRadius = 94;

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

function rectangle(y1, y2, z1, z2, x, materialId, matrixId) {
  return geometry(
    [[x, y1, z1], [x, y2, z1], [x, y2, z2], [x, y1, z2]],
    [0, 1, 2, 0, 2, 3],
    materialId,
    matrixId,
  );
}

function box(y1, y2, z1, z2, x1, x2, materialId, matrixId) {
  return geometry(
    [
      [x1, y1, z1], [x1, y2, z1], [x1, y2, z2], [x1, y1, z2],
      [x2, y1, z1], [x2, y2, z1], [x2, y2, z2], [x2, y1, z2],
    ],
    [
      0, 1, 2, 0, 2, 3,
      4, 6, 5, 4, 7, 6,
      0, 4, 5, 0, 5, 1,
      1, 5, 6, 1, 6, 2,
      2, 6, 7, 2, 7, 3,
      3, 7, 4, 3, 4, 0,
    ],
    materialId,
    matrixId,
  );
}

function octagonalMedallion(cy, cz, radius, x1, x2, materialId, matrixId) {
  const vertices = [];
  for (const x of [x1, x2]) {
    for (let side = 0; side < 8; side += 1) {
      const angle = side * Math.PI / 4;
      vertices.push([x, cy + Math.cos(angle) * radius, cz + Math.sin(angle) * radius]);
    }
  }
  const faces = [];
  for (let side = 0; side < 8; side += 1) {
    const next = (side + 1) % 8;
    faces.push(side, 8 + side, 8 + next, side, 8 + next, next);
  }
  for (let side = 1; side < 7; side += 1) {
    faces.push(0, side + 1, side, 8, 8 + side, 8 + side + 1);
  }
  return geometry(vertices, faces, materialId, matrixId);
}

function sprite(cy, cz, halfWidth, halfHeight, x, materialId, matrixId) {
  return geometry(
    [
      [x, cy - halfWidth, cz - halfHeight],
      [x, cy + halfWidth, cz - halfHeight],
      [x, cy + halfWidth, cz + halfHeight],
      [x, cy - halfWidth, cz + halfHeight],
    ],
    [0, 1, 2, 0, 2, 3],
    materialId,
    matrixId,
    [[0, 1], [1, 1], [1, 0], [0, 0]],
  );
}

function merge(parts, materialId, matrixId) {
  const vertices = [];
  const faces = [];
  const textureVertices = [];
  for (const part of parts) {
    const offset = vertices.length;
    vertices.push(...part.vertices);
    faces.push(...part.faces.map((face) => face + offset));
    textureVertices.push(...(part.textureVertices || part.vertices.map((vertex) => [
      (vertex[1] + 40) / 80,
      (vertex[2] - 28) / 104,
    ])));
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
  const { vertices, faces, materialId, matrixId } = item;
  const { minimum, maximum } = extentFor(vertices);
  const normals = vertices.map(() => [-1, 0, 0]);
  const textureVertices = item.textureVertices || vertices.map((vertex) => [
    (vertex[1] + 40) / 80,
    (vertex[2] - 28) / 104,
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

const rosePlacements = [
  [-28.5, 119, 7.2], [28.5, 119, 7.2], [-29.2, 80, 6.1], [29.2, 80, 6.1],
  [-28.5, 41, 7.2], [28.5, 41, 7.2],
];

const silverFrame = [
  box(-30, 30, 37.6, 39.8, -7.2, -2.8, 0, 0),
  box(-30, 30, 120.2, 122.4, -7.2, -2.8, 0, 0),
  box(-30, -27.8, 39.8, 120.2, -7.2, -2.8, 0, 0),
  box(27.8, 30, 39.8, 120.2, -7.2, -2.8, 0, 0),
];

const redFiligree = [
  box(-20.5, 20.5, 42.4, 43.4, -8, -6.2, 1, 0),
  box(-20.5, 20.5, 116.6, 117.6, -8, -6.2, 1, 0),
  box(-27.8, -26.8, 43.4, 71.5, -8, -6.2, 1, 0),
  box(-27.8, -26.8, 88.5, 116.6, -8, -6.2, 1, 0),
  box(26.8, 27.8, 43.4, 71.5, -8, -6.2, 1, 0),
  box(26.8, 27.8, 88.5, 116.6, -8, -6.2, 1, 0),
];

const roseSprites = rosePlacements.map(([y, z, radius]) => (
  sprite(y, z, radius, radius, -9.4, 2, 1)
));

const geometries = [
  merge(silverFrame, 0, 0),
  merge(redFiligree, 1, 0),
  merge(roseSprites, 2, 1),
];

const frameAlpha = [[0, 0], [420, 0.64], [600, 0.82], [700, 0.78], [5700, 0.78], [5800, 0.78], [6500, 0]];
const redAlpha = [[0, 0], [260, 0.15], [520, 0.72], [700, 0.62], [1700, 0.72], [2700, 0.62], [3700, 0.72], [4700, 0.62], [5700, 0.62], [5800, 0.72], [6500, 0]];
const roseAlpha = [[0, 0], [300, 0], [560, 1], [700, 1], [1700, 1], [2700, 1], [3700, 1], [4700, 1], [5700, 1], [5800, 1], [6500, 0]];

const mdl = `Version {
    FormatVersion 800,
}
Model "ShalltearRoseMirrorRim" {
    BlendTime 150,
    MinimumExtent ${vector(minimumExtent)},
    MaximumExtent ${vector(maximumExtent)},
    BoundsRadius ${boundsRadius},
}
Sequences 3 {
    Anim "Birth" {
        Interval { 0, 600 },
        NonLooping,
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
    Anim "Stand" {
        Interval { 700, 5700 },
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
    Anim "Death" {
        Interval { 5800, 6500 },
        NonLooping,
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
}
Textures 2 {
    Bitmap {
        Image "Textures\\white.blp",
    }
    Bitmap {
        Image "Common\\Effect\\Form\\Illusion\\Texture\\ShalltearRoseMirrorRimRose.blp",
    }
}
Materials 3 {
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
        PriorityPlane 3,
        Layer {
            FilterMode Transparent,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 1,
        }
    }
}
${geometries.map(geosetBlock).join('\n')}
${geosetAnimationBlock(0, [0.58, 0.58, 0.58], frameAlpha)}
${geosetAnimationBlock(1, [0.025, 0.04, 0.76], redAlpha)}
${geosetAnimationBlock(2, [1, 1, 1], roseAlpha)}
Bone "ShalltearRoseMirrorRoot" {
    ObjectId 0,
    GeosetId Multiple,
    GeosetAnimId None,
    Translation 7 {
        Linear,
        0: { 0, 0, -10 },
        600: { 0, 0, 0 },
        700: { 0, 0, 0 },
        5700: { 0, 0, 0 },
        5800: { 0, 0, 0 },
        6200: { 0, 0, 4 },
        6500: { 0, 0, 12 },
    }
    Scaling 8 {
        Linear,
        0: { 0.62, 0.62, 0.62 },
        420: { 1.05, 1.05, 1.05 },
        600: { 1, 1, 1 },
        700: { 1, 1, 1 },
        5700: { 1, 1, 1 },
        5800: { 1, 1, 1 },
        6200: { 1.05, 1.05, 1.05 },
        6500: { 1.18, 1.18, 1.18 },
    }
}
Bone "ShalltearRoseSprites" {
    ObjectId 1,
    Parent 0,
    GeosetId 2,
    GeosetAnimId 2,
    Scaling 7 {
        Linear,
        0: { 0.3, 0.3, 0.3 },
        600: { 1, 1, 1 },
        700: { 1, 1, 1 },
        1700: { 1.045, 1.045, 1.045 },
        2700: { 1, 1, 1 },
        4700: { 1.045, 1.045, 1.045 },
        5700: { 1, 1, 1 },
    }
}
PivotPoints 2 {
    { 0, 0, 80 },
    { 0, 0, 80 },
}
`;

if (!fs.existsSync(rosePngPath)) {
  throw new Error(`Missing editable rose texture source: ${rosePngPath}`);
}
const roseDataUrl = `data:image/png;base64,${fs.readFileSync(rosePngPath).toString('base64')}`;

function roseSvg(x, y, size) {
  return `<image href="${roseDataUrl}" x="${x - size / 2}" y="${y - size / 2}" width="${size}" height="${size}"/>`;
}

const preview = `<svg xmlns="http://www.w3.org/2000/svg" width="620" height="760" viewBox="0 0 620 760">
  <defs>
    <linearGradient id="mirror" x1="0" y1="0" x2="1" y2="1"><stop stop-color="#260308"/><stop offset="0.5" stop-color="#7d0b14"/><stop offset="1" stop-color="#180106"/></linearGradient>
    <linearGradient id="silver" x1="0" y1="0" x2="1" y2="0"><stop stop-color="#7e858e"/><stop offset="0.45" stop-color="#f0e7e4"/><stop offset="0.7" stop-color="#a8adb4"/><stop offset="1" stop-color="#f4d8d9"/></linearGradient>
    <filter id="redGlow"><feGaussianBlur stdDeviation="5" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  </defs>
  <rect width="620" height="760" fill="#111722"/>
  <rect x="170" y="105" width="280" height="550" rx="8" fill="url(#mirror)" opacity="0.9"/>
  <rect x="150" y="78" width="320" height="604" rx="3" fill="none" stroke="url(#silver)" stroke-width="11"/>
  <rect x="164" y="94" width="292" height="572" rx="2" fill="none" stroke="#a90d23" stroke-width="5" filter="url(#redGlow)"/>
  <path d="M158 92 L205 139 M462 92 L415 139 M158 668 L205 621 M462 668 L415 621" fill="none" stroke="#851020" stroke-width="3"/>
  ${roseSvg(158, 92, 76)}${roseSvg(462, 92, 76)}${roseSvg(150, 380, 62)}${roseSvg(470, 380, 62)}${roseSvg(158, 668, 76)}${roseSvg(462, 668, 76)}
  <text x="310" y="725" fill="#d8dadd" font-size="18" text-anchor="middle">Shalltear Rose Mirror Rim · front preview</text>
</svg>`;

fs.mkdirSync(outputDirectory, { recursive: true });
fs.mkdirSync(path.dirname(previewPath), { recursive: true });

const model = new Model();
model.loadMdl(mdl);
fs.writeFileSync(mdxPath, model.saveMdx());
fs.writeFileSync(previewPath, preview, 'utf8');

const verified = new Model();
verified.loadMdx(fs.readFileSync(mdxPath));
if (verified.name !== 'ShalltearRoseMirrorRim' || verified.geosets.length !== 3 || verified.sequences.length !== 3 || verified.bones.length !== 2) {
  throw new Error('Generated MDX did not pass structural verification');
}
const expectedTextures = [
  'Textures\\white.blp',
  'Common\\Effect\\Form\\Illusion\\Texture\\ShalltearRoseMirrorRimRose.blp',
];
if (verified.textures.length !== 2 || verified.textures.some((texture, index) => texture.path !== expectedTextures[index])) {
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
