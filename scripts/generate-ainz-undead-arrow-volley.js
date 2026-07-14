const fs = require('fs');
const path = require('path');

const modelLibraryPath = process.env.MDX_MODEL_LIB;
if (!modelLibraryPath) {
  throw new Error('MDX_MODEL_LIB must point to mdx-m3-viewer/dist/cjs/parsers/mdlx/model.js');
}

const Model = require(modelLibraryPath).default;
const sourcePath = path.resolve('C:\\Users\\Administrator\\Desktop\\特效（特效w3x整合出来的）\\spiritarrow_byepsilon.mdx');
const outputDirectory = path.resolve(__dirname, '..', 'imports', 'Common', 'Effect', 'Form', 'RiseFall');
const mdxPath = path.join(outputDirectory, 'AinzUndeadArrowVolley.mdx');
const previewPath = path.resolve(__dirname, '..', 'image_temp', 'AinzUndeadArrowVolley-preview.svg');
const minimumExtent = [-240, -240, -90];
const maximumExtent = [240, 240, 650];
const boundsRadius = 760;

function formatNumber(value) {
  const rounded = Math.abs(value) < 0.000001 ? 0 : value;
  return Number(rounded.toFixed(6)).toString();
}

function vector(values) {
  return `{ ${values.map(formatNumber).join(', ')} }`;
}

function readVector(flatArray, index, size) {
  return Array.from(flatArray.slice(index * size, index * size + size));
}

function quaternionFromXTo(direction) {
  const length = Math.hypot(...direction) || 1;
  const x = direction[0] / length;
  const y = direction[1] / length;
  const z = direction[2] / length;
  const quaternion = [0, -z, y, 1 + x];
  const quaternionLength = Math.hypot(...quaternion) || 1;
  return quaternion.map((value) => value / quaternionLength);
}

function geosetBlock(item) {
  const { vertices, normals, textureVertices, faces, vertexGroups, matrixIndices, materialId } = item;
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
${vertexGroups.map((group) => `        ${group},`).join('\n')}
    }
    Faces 1 ${faces.length} {
        Triangles {
            { ${faces.join(', ')} },
        }
    }
    Groups ${matrixIndices.length} ${matrixIndices.length} {
${matrixIndices.map((matrix) => `        Matrices { ${matrix} },`).join('\n')}
    }
    MinimumExtent ${vector(minimumExtent)},
    MaximumExtent ${vector(maximumExtent)},
    BoundsRadius ${boundsRadius},
    Anim {
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
    Anim {
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
    Anim {
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
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

if (!fs.existsSync(sourcePath)) {
  throw new Error(`Missing selected arrow source: ${sourcePath}`);
}

const sourceModel = new Model();
sourceModel.loadMdx(fs.readFileSync(sourcePath));
const sourceGeoset = sourceModel.geosets[0];
if (!sourceGeoset || sourceGeoset.vertices.length === 0 || sourceGeoset.uvSets.length === 0) {
  throw new Error('Selected arrow source has no reusable geometry');
}

const arrows = [
  { target: [-92, -62], direction: [0.16, 0.08, -1], delay: 80, scale: 0.72 },
  { target: [-46, 58], direction: [0.09, -0.12, -1], delay: 190, scale: 0.78 },
  { target: [0, 0], direction: [0.04, 0.03, -1], delay: 310, scale: 0.85 },
  { target: [52, -42], direction: [-0.11, 0.08, -1], delay: 430, scale: 0.77 },
  { target: [96, 64], direction: [-0.15, -0.08, -1], delay: 560, scale: 0.71 },
  { target: [-82, 92], direction: [0.13, -0.14, -1], delay: 690, scale: 0.68 },
  { target: [82, -94], direction: [-0.13, 0.14, -1], delay: 820, scale: 0.69 },
];

const sourceVertexCount = sourceGeoset.vertices.length / 3;
const sourceFaceCount = sourceGeoset.faces.length;
const glowVertices = [];
const glowNormals = [];
const glowTextureVertices = [];
const glowFaces = [];
const glowVertexGroups = [];

for (let arrowIndex = 0; arrowIndex < arrows.length; arrowIndex += 1) {
  const vertexOffset = glowVertices.length;
  for (let vertexIndex = 0; vertexIndex < sourceVertexCount; vertexIndex += 1) {
    glowVertices.push(readVector(sourceGeoset.vertices, vertexIndex, 3));
    glowNormals.push(readVector(sourceGeoset.normals, vertexIndex, 3));
    glowTextureVertices.push(readVector(sourceGeoset.uvSets[0], vertexIndex, 2));
    glowVertexGroups.push(arrowIndex);
  }
  for (let faceIndex = 0; faceIndex < sourceFaceCount; faceIndex += 1) {
    glowFaces.push(sourceGeoset.faces[faceIndex] + vertexOffset);
  }
}

const headVertices = [];
const headNormals = [];
const headTextureVertices = [];
const headFaces = [];
const headVertexGroups = [];

function appendOctagonalPrism(vertices, faces, startX, endX, centerY, centerZ, radius) {
  const offset = vertices.length;
  for (const x of [startX, endX]) {
    for (let side = 0; side < 8; side += 1) {
      const angle = side * Math.PI / 4;
      vertices.push([x, centerY + Math.cos(angle) * radius, centerZ + Math.sin(angle) * radius]);
    }
  }
  for (let side = 0; side < 8; side += 1) {
    const next = (side + 1) % 8;
    faces.push(offset + side, offset + 8 + side, offset + 8 + next);
    faces.push(offset + side, offset + 8 + next, offset + next);
  }
  for (let side = 1; side < 7; side += 1) {
    faces.push(offset, offset + side + 1, offset + side);
    faces.push(offset + 8, offset + 8 + side, offset + 8 + side + 1);
  }
}

function appendArrowhead(vertices, faces, baseX, tipX, centerY, centerZ, radius) {
  const offset = vertices.length;
  vertices.push([tipX, centerY, centerZ]);
  for (let side = 0; side < 8; side += 1) {
    const angle = side * Math.PI / 4;
    vertices.push([baseX, centerY + Math.cos(angle) * radius, centerZ + Math.sin(angle) * radius]);
  }
  for (let side = 0; side < 8; side += 1) {
    faces.push(offset, offset + 1 + side, offset + 1 + ((side + 1) % 8));
  }
  for (let side = 1; side < 7; side += 1) {
    faces.push(offset + 1, offset + 1 + side + 1, offset + 1 + side);
  }
}

for (let arrowIndex = 0; arrowIndex < arrows.length; arrowIndex += 1) {
  const vertexOffset = headVertices.length;
  const localVertices = [];
  const localFaces = [];
  const centerY = 0.528564;
  const centerZ = 59.468224;
  appendOctagonalPrism(localVertices, localFaces, -92, 78, centerY, centerZ, 4.8);
  appendOctagonalPrism(localVertices, localFaces, 54, 79, centerY, centerZ, 7.2);
  appendArrowhead(localVertices, localFaces, 72, 128, centerY, centerZ, 18);
  const finOffset = localVertices.length;
  localVertices.push(
    [-88, centerY, centerZ], [-56, centerY, centerZ], [-82, centerY + 22, centerZ],
    [-88, centerY, centerZ], [-56, centerY, centerZ], [-82, centerY - 22, centerZ],
    [-88, centerY, centerZ], [-56, centerY, centerZ], [-82, centerY, centerZ + 22],
    [-88, centerY, centerZ], [-56, centerY, centerZ], [-82, centerY, centerZ - 22],
  );
  for (let fin = 0; fin < 4; fin += 1) {
    localFaces.push(finOffset + fin * 3, finOffset + fin * 3 + 1, finOffset + fin * 3 + 2);
  }
  headVertices.push(...localVertices);
  headNormals.push(...localVertices.map((vertex) => {
    const length = Math.hypot(vertex[1] - centerY, vertex[2] - centerZ) || 1;
    return [0, (vertex[1] - centerY) / length, (vertex[2] - centerZ) / length];
  }));
  headTextureVertices.push(...localVertices.map((vertex) => [
    (vertex[0] + 92) / 220,
    0.5 + (vertex[1] - centerY) / 44,
  ]));
  headVertexGroups.push(...localVertices.map(() => arrowIndex));
  headFaces.push(...localFaces.map((face) => face + vertexOffset));
}

const spriteVertices = [];
const spriteNormals = [];
const spriteTextureVertices = [];
const spriteFaces = [];
const spriteVertexGroups = [];
for (let arrowIndex = 0; arrowIndex < arrows.length; arrowIndex += 1) {
  const vertexOffset = spriteVertices.length;
  const centerY = 0.528564;
  const centerZ = 59.468224;
  spriteVertices.push(
    [-104, centerY - 44, centerZ], [132, centerY - 44, centerZ],
    [132, centerY + 44, centerZ], [-104, centerY + 44, centerZ],
    [-104, centerY, centerZ - 44], [132, centerY, centerZ - 44],
    [132, centerY, centerZ + 44], [-104, centerY, centerZ + 44],
  );
  spriteNormals.push(
    [0, 0, 1], [0, 0, 1], [0, 0, 1], [0, 0, 1],
    [0, -1, 0], [0, -1, 0], [0, -1, 0], [0, -1, 0],
  );
  spriteTextureVertices.push(
    [0, 1], [1, 1], [1, 0], [0, 0],
    [0, 1], [1, 1], [1, 0], [0, 0],
  );
  spriteFaces.push(
    vertexOffset, vertexOffset + 1, vertexOffset + 2,
    vertexOffset, vertexOffset + 2, vertexOffset + 3,
    vertexOffset + 4, vertexOffset + 5, vertexOffset + 6,
    vertexOffset + 4, vertexOffset + 6, vertexOffset + 7,
  );
  spriteVertexGroups.push(...Array(8).fill(arrowIndex));
}

const matrixIndices = arrows.map((_, index) => index + 1);
const geometries = [
  {
    vertices: glowVertices,
    normals: glowNormals,
    textureVertices: glowTextureVertices,
    faces: glowFaces,
    vertexGroups: glowVertexGroups,
    matrixIndices,
    materialId: 0,
  },
  {
    vertices: headVertices,
    normals: headNormals,
    textureVertices: headTextureVertices,
    faces: headFaces,
    vertexGroups: headVertexGroups,
    matrixIndices,
    materialId: 1,
  },
  {
    vertices: spriteVertices,
    normals: spriteNormals,
    textureVertices: spriteTextureVertices,
    faces: spriteFaces,
    vertexGroups: spriteVertexGroups,
    matrixIndices,
    materialId: 2,
  },
];

function translationTrack(arrow) {
  const [targetX, targetY] = arrow.target;
  const [directionX, directionY] = arrow.direction;
  const start = [targetX - directionX * 210, targetY - directionY * 210, 440 + arrow.delay * 0.1];
  const end = [targetX, targetY, -20];
  const arrival = arrow.delay + 430;
  return `Translation 9 {
        Linear,
        0: ${vector(start)},
        ${arrow.delay}: ${vector(start)},
        ${arrival}: ${vector(end)},
        1800: ${vector(end)},
        1900: ${vector(end)},
        2900: ${vector(end)},
        3000: ${vector(end)},
        3250: ${vector([targetX, targetY, -12])},
        3500: ${vector([targetX, targetY, 10])},
    }`;
}

const arrowBones = arrows.map((arrow, index) => `Bone "AinzUndeadArrow_${index + 1}" {
    ObjectId ${index + 1},
    Parent 0,
    GeosetId Multiple,
    GeosetAnimId None,
    ${translationTrack(arrow)}
    Rotation 1 {
        DontInterp,
        0: ${vector(quaternionFromXTo(arrow.direction))},
    }
    Scaling 1 {
        DontInterp,
        0: ${vector([arrow.scale, arrow.scale, arrow.scale])},
    }
}`).join('\n');

const sharedAlpha = [[0, 0], [80, 0.84], [1800, 0.84], [1900, 0.72], [2900, 0.72], [3000, 0.72], [3500, 0]];
const headAlpha = [[0, 0], [80, 0.96], [1800, 0.96], [1900, 0.9], [2900, 0.9], [3000, 0.9], [3500, 0]];
const spriteAlpha = [[0, 0], [80, 1], [1800, 1], [1900, 0.94], [2900, 0.94], [3000, 0.94], [3500, 0]];

const mdl = `Version {
    FormatVersion 800,
}
Model "AinzUndeadArrowVolley" {
    BlendTime 80,
    MinimumExtent ${vector(minimumExtent)},
    MaximumExtent ${vector(maximumExtent)},
    BoundsRadius ${boundsRadius},
}
Sequences 3 {
    Anim "Birth" {
        Interval { 0, 1800 },
        NonLooping,
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
    Anim "Stand" {
        Interval { 1900, 2900 },
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
    Anim "Death" {
        Interval { 3000, 3500 },
        NonLooping,
        MinimumExtent ${vector(minimumExtent)},
        MaximumExtent ${vector(maximumExtent)},
        BoundsRadius ${boundsRadius},
    }
}
Textures 4 {
    Bitmap {
        Image "Textures\\Flare.blp",
    }
    Bitmap {
        Image "Textures\\RibbonNE1_blue.blp",
    }
    Bitmap {
        Image "Textures\\white.blp",
    }
    Bitmap {
        Image "Common\\Effect\\Form\\RiseFall\\Texture\\AinzUndeadArrowVolley.blp",
    }
}
Materials 3 {
    Material {
        Layer {
            FilterMode AddAlpha,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 0,
            static Alpha 0.28,
        }
        Layer {
            FilterMode AddAlpha,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 1,
            static Alpha 0.82,
        }
    }
    Material {
        Layer {
            FilterMode Blend,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 2,
            static Alpha 0.96,
        }
    }
    Material {
        Layer {
            FilterMode Blend,
            Unshaded,
            TwoSided,
            Unfogged,
            static TextureID 3,
            static Alpha 1,
        }
    }
}
${geometries.map(geosetBlock).join('\n')}
${geosetAnimationBlock(0, [0.5, 0.025, 0.27], sharedAlpha)}
${geosetAnimationBlock(1, [0.72, 0.82, 0.92], headAlpha)}
${geosetAnimationBlock(2, [1, 1, 1], spriteAlpha)}
Bone "AinzUndeadArrowVolleyRoot" {
    ObjectId 0,
    GeosetId Multiple,
    GeosetAnimId None,
}
${arrowBones}
PivotPoints ${arrows.length + 1} {
    { 0, 0, 0 },
${arrows.map(() => '    { 3.948899, 0.528564, 59.468224 },').join('\n')}
}
`;

const previewArrows = arrows.map((arrow, index) => {
  const x = 260 + arrow.target[0] * 1.15;
  const y = 215 + index * 58;
  return `<g transform="translate(${x} ${y}) rotate(${index % 2 === 0 ? 8 : -8})"><path d="M0 0 L0 105" stroke="#54105f" stroke-width="8" opacity="0.8"/><path d="M0 104 L-11 76 L0 84 L11 76 Z" fill="#e9e1c5" stroke="#a958b5" stroke-width="2"/></g>`;
}).join('');
const preview = `<svg xmlns="http://www.w3.org/2000/svg" width="520" height="720" viewBox="0 0 520 720">
  <rect width="520" height="720" fill="#111722"/>
  <ellipse cx="260" cy="650" rx="170" ry="34" fill="#18091d" stroke="#4f1a58" stroke-width="3"/>
  ${previewArrows}
  <text x="260" y="692" fill="#ded5c2" font-size="18" text-anchor="middle">Ainz Undead Arrow Volley · formation preview</text>
</svg>`;

fs.mkdirSync(outputDirectory, { recursive: true });
fs.mkdirSync(path.dirname(previewPath), { recursive: true });
const model = new Model();
model.loadMdl(mdl);
fs.writeFileSync(mdxPath, model.saveMdx());
fs.writeFileSync(previewPath, preview, 'utf8');

const verified = new Model();
verified.loadMdx(fs.readFileSync(mdxPath));
const expectedTextures = [
  'Textures\\Flare.blp',
  'Textures\\RibbonNE1_blue.blp',
  'Textures\\white.blp',
  'Common\\Effect\\Form\\RiseFall\\Texture\\AinzUndeadArrowVolley.blp',
];
if (verified.name !== 'AinzUndeadArrowVolley' || verified.geosets.length !== 3 || verified.sequences.length !== 3 || verified.bones.length !== 8) {
  throw new Error('Generated MDX did not pass structural verification');
}
if (verified.textures.length !== expectedTextures.length || verified.textures.some((texture, index) => texture.path !== expectedTextures[index])) {
  throw new Error('Generated MDX texture verification failed');
}

process.stdout.write(JSON.stringify({
  sourcePath,
  mdxPath,
  previewPath,
  byteLength: fs.statSync(mdxPath).size,
  arrows: arrows.length,
  geosets: verified.geosets.length,
  bones: verified.bones.length,
  sequences: verified.sequences.map((sequence) => sequence.name),
  textures: verified.textures.map((texture) => texture.path),
}, null, 2));
