const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const outputDirectory = path.resolve(__dirname, '..', 'imports', 'Common', 'Effect', 'Form', 'RiseFall');
const mdxPath = path.join(outputDirectory, 'ShalltearBloodMoonDisc.mdx');

const centerZ = 360;
const discRadius = 180;

function formatNumber(value) {
  const rounded = Math.abs(value) < 0.000001 ? 0 : value;
  return Number(rounded.toFixed(6)).toString();
}

function vector(values) {
  return `{ ${values.map(formatNumber).join(', ')} }`;
}

function createGeometry(vertices, faces, materialId = 0, matrixId = 0, textureVertices, normals) {
  return { vertices, faces, materialId, matrixId, textureVertices, normals };
}

function moonDome(radialSegments = 12, angularSegments = 32, depth = 72) {
  const vertices = [[depth, 0, centerZ]];
  const normals = [[1, 0, 0]];
  const textureVertices = [[0.5, 0.5]];
  const faces = [];
  for (let ring = 1; ring <= radialSegments; ring += 1) {
    const ratio = ring / radialSegments;
    const radius = discRadius * ratio;
    const x = depth * Math.sqrt(Math.max(0, 1 - ratio * ratio));
    for (let segment = 0; segment < angularSegments; segment += 1) {
      const angle = (Math.PI * 2 * segment) / angularSegments;
      const y = Math.cos(angle) * radius;
      const zOffset = Math.sin(angle) * radius;
      vertices.push([x, y, centerZ + zOffset]);
      const normal = [x / (depth * depth), y / (discRadius * discRadius), zOffset / (discRadius * discRadius)];
      const normalLength = Math.hypot(...normal) || 1;
      normals.push(normal.map((value) => value / normalLength));
      textureVertices.push([
        0.5 + y / (discRadius * 2),
        0.5 - zOffset / (discRadius * 2),
      ]);
    }
  }
  for (let segment = 0; segment < angularSegments; segment += 1) {
    faces.push(0, 1 + segment, 1 + ((segment + 1) % angularSegments));
  }
  for (let ring = 2; ring <= radialSegments; ring += 1) {
    const innerStart = 1 + (ring - 2) * angularSegments;
    const outerStart = 1 + (ring - 1) * angularSegments;
    for (let segment = 0; segment < angularSegments; segment += 1) {
      const next = (segment + 1) % angularSegments;
      const innerCurrent = innerStart + segment;
      const innerNext = innerStart + next;
      const outerCurrent = outerStart + segment;
      const outerNext = outerStart + next;
      faces.push(innerCurrent, outerCurrent, outerNext, innerCurrent, outerNext, innerNext);
    }
  }
  return createGeometry(vertices, faces, 0, 0, textureVertices, normals);
}

function annulus(innerRadius, outerRadius, segments, x, matrixId = 0) {
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
  return createGeometry(vertices, faces, 1, matrixId);
}

function radialSpike(angle, innerRadius, outerRadius, halfWidth, x, matrixId) {
  const radialY = Math.cos(angle);
  const radialZ = Math.sin(angle);
  const tangentY = -radialZ;
  const tangentZ = radialY;
  const basePoint = (side) => [
    x,
    radialY * innerRadius + tangentY * halfWidth * side,
    centerZ + radialZ * innerRadius + tangentZ * halfWidth * side,
  ];
  return createGeometry(
    [basePoint(-1), [x, radialY * outerRadius, centerZ + radialZ * outerRadius], basePoint(1)],
    [0, 1, 2],
    1,
    matrixId,
  );
}

function mergeGeometries(geometries, materialId, matrixId) {
  const vertices = [];
  const faces = [];
  for (const geometry of geometries) {
    const offset = vertices.length;
    vertices.push(...geometry.vertices);
    faces.push(...geometry.faces.map((face) => face + offset));
  }
  return createGeometry(vertices, faces, materialId, matrixId);
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
  const normals = geometry.normals || vertices.map(() => [1, 0, 0]);
  const textureVertices = geometry.textureVertices || vertices.map((vertex) => [
    (vertex[1] + 220) / 440,
    (vertex[2] - centerZ + 220) / 440,
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
    BoundsRadius 230,
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius 230,
    }
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius 230,
    }
    Anim {
        MinimumExtent ${vector(minimum)},
        MaximumExtent ${vector(maximum)},
        BoundsRadius 230,
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

const crownSpikes = [];
for (let index = 0; index < 10; index += 1) {
  const angle = (Math.PI * 2 * index) / 10 + 0.11;
  const outerRadius = 207 + (index % 3) * 5;
  crownSpikes.push(radialSpike(angle, 193, outerRadius, index % 2 === 0 ? 5.2 : 3.8, 1.25, 1));
}

const geometries = [
  moonDome(),
  annulus(187, 196, 96, 0.65),
  annulus(171, 175, 96, 0.85),
  mergeGeometries(crownSpikes, 1, 1),
];

const discAlpha = [[0, 0], [400, 0.92], [600, 1], [700, 1], [5700, 1], [5800, 1], [6500, 0]];
const outerRingAlpha = [[0, 0], [360, 0.5], [600, 0.72], [700, 0.58], [1600, 0.82], [2500, 0.58], [3400, 0.82], [4300, 0.58], [5700, 0.58], [5800, 0.72], [6500, 0]];
const innerRingAlpha = [[0, 0], [430, 0.35], [600, 0.5], [700, 0.48], [1600, 0.35], [2500, 0.48], [3400, 0.35], [4300, 0.48], [5700, 0.48], [5800, 0.48], [6500, 0]];
const crownAlpha = [[0, 0], [470, 0.45], [600, 0.62], [700, 0.52], [1700, 0.72], [2700, 0.52], [3700, 0.72], [4700, 0.52], [5700, 0.52], [5800, 0.68], [6500, 0]];

const mdl = `Version {
    FormatVersion 800,
}
Model "ShalltearBloodMoonDisc" {
    BlendTime 150,
    MinimumExtent { -4, -220, 140 },
    MaximumExtent { 80, 220, 580 },
    BoundsRadius 260,
}
Sequences 3 {
    Anim "Birth" {
        Interval { 0, 600 },
        NonLooping,
        MinimumExtent { -4, -220, 140 },
        MaximumExtent { 80, 220, 580 },
        BoundsRadius 260,
    }
    Anim "Stand" {
        Interval { 700, 5700 },
        MinimumExtent { -4, -220, 140 },
        MaximumExtent { 80, 220, 580 },
        BoundsRadius 260,
    }
    Anim "Death" {
        Interval { 5800, 6500 },
        NonLooping,
        MinimumExtent { -4, -220, 140 },
        MaximumExtent { 80, 220, 580 },
        BoundsRadius 260,
    }
}
Textures 2 {
    Bitmap {
        Image "Common\\Effect\\Form\\RiseFall\\Texture\\ShalltearBloodMoonDisc.blp",
    }
    Bitmap {
        Image "Textures\\white.blp",
    }
}
Materials 2 {
    Material {
        Layer {
            FilterMode Blend,
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
            static TextureID 1,
        }
    }
}
${geometries.map(geosetBlock).join('\n')}
${geosetAnimationBlock(0, [1, 1, 1], discAlpha)}
${geosetAnimationBlock(1, [0.02, 0.015, 0.78], outerRingAlpha)}
${geosetAnimationBlock(2, [0.012, 0.005, 0.32], innerRingAlpha)}
${geosetAnimationBlock(3, [0.018, 0.008, 0.55], crownAlpha)}
Bone "ShalltearBloodMoonRoot" {
    ObjectId 0,
    Billboarded,
    GeosetId Multiple,
    GeosetAnimId None,
    Translation 7 {
        Linear,
        0: { 0, 0, -42 },
        600: { 0, 0, 0 },
        700: { 0, 0, 0 },
        5700: { 0, 0, 0 },
        5800: { 0, 0, 0 },
        6200: { 0, 0, 8 },
        6500: { 0, 0, 24 },
    }
    Scaling 8 {
        Linear,
        0: { 0.35, 0.35, 0.35 },
        420: { 1.08, 1.08, 1.08 },
        600: { 1, 1, 1 },
        700: { 1, 1, 1 },
        5700: { 1, 1, 1 },
        5800: { 1, 1, 1 },
        6200: { 1.08, 1.08, 1.08 },
        6500: { 1.18, 1.18, 1.18 },
    }
}
Bone "ShalltearBloodMoonCrown" {
    ObjectId 1,
    Parent 0,
    GeosetId 3,
    GeosetAnimId 3,
    Rotation 7 {
        Linear,
        0: ${vector(quaternionForXRotation(0))},
        600: ${vector(quaternionForXRotation(0))},
        700: ${vector(quaternionForXRotation(0))},
        3200: ${vector(quaternionForXRotation(Math.PI))},
        5700: ${vector(quaternionForXRotation(Math.PI * 2))},
        5800: ${vector(quaternionForXRotation(0))},
        6500: ${vector(quaternionForXRotation(Math.PI / 2))},
    }
}
PivotPoints 2 {
    { 0, 0, 360 },
    { 0, 0, 360 },
}
`;

fs.mkdirSync(outputDirectory, { recursive: true });

const model = new Model();
model.loadMdl(mdl);
fs.writeFileSync(mdxPath, model.saveMdx());

const verified = new Model();
verified.loadMdx(fs.readFileSync(mdxPath));
const expectedTextures = [
  'Common\\Effect\\Form\\RiseFall\\Texture\\ShalltearBloodMoonDisc.blp',
  'Textures\\white.blp',
];
if (verified.name !== 'ShalltearBloodMoonDisc' || verified.geosets.length !== 4 || verified.sequences.length !== 3 || verified.bones.length !== 2) {
  throw new Error('Generated MDX did not pass structural verification');
}
if (verified.textures.length !== 2 || verified.textures.some((texture, index) => texture.path !== expectedTextures[index])) {
  throw new Error('Generated MDX texture path verification failed');
}

process.stdout.write(JSON.stringify({
  mdxPath,
  byteLength: fs.statSync(mdxPath).size,
  geosets: verified.geosets.length,
  sequences: verified.sequences.map((sequence) => sequence.name),
  textures: verified.textures.map((texture) => texture.path),
}, null, 2));
